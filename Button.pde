class Button {
  float B_R = 60;
  int index;
  float x;
  float y;
  String name;
  boolean on;
  public Button(int _i, float x_, float y_, String name_) {
    index = _i;
    x = x_;
    y = y_;
    name = name_;
    on = false;
  }
  void iterate(Player player, Room room) {
    float px = player.coor[0];
    float py = player.coor[1];
    float pz = player.coor[2];
    if (px >= x-B_R && px < x+B_R && py >= y-B_R && py < y+B_R && pz == 0) {
      if (!on) {
        String note = "";
        if (index == 0) {
          if (playback_speed > 0) {
            playback_speed = min(1024, playback_speed*2);
          } else {
            playback_speed = 1;
          }
        } else if (index == 1) {
          if (playback_speed > 1) {
            playback_speed = max(1, playback_speed/2);
          } else {
            playback_speed = 0;
          }
        } else if (index == 2) {
          R += 1;
          createSwatters(room, SWATTER_COUNT);
          note = "Swatters-grown to-"+swatterSizeToText(R);
        } else if (index == 3) {
          R -= 1;
          createSwatters(room, SWATTER_COUNT);
          note = "Swatters-shrunk to-"+swatterSizeToText(R);
        } else if (index == 4) {
          SWAT_SPEED *= 1.09;
          note = "Swatters-sped up to-"+swatterSpeedToText(SWAT_SPEED, true);
        } else if (index == 5) {
          SWAT_SPEED /= 1.09;
          note = "Swatters-slowed to-"+swatterSpeedToText(SWAT_SPEED, true);
        } else if (index == 6) {
          MUTATION_FACTOR += 0.02;
          note = "Mutation factor-increased to-"+nf(MUTATION_FACTOR, 0, 2);
        } else if (index == 7) {
          MUTATION_FACTOR -= 0.02;
          note = "Mutation factor-decreased to-"+nf(MUTATION_FACTOR, 0, 2);
        } else if (index == 8) {
          SWATTER_COUNT += 3;
          createSwatters(room, SWATTER_COUNT);
          note = "Swatter count-increased to-"+SWATTER_COUNT;
        } else if (index == 9) {
          SWATTER_COUNT -= 3;
          createSwatters(room, SWATTER_COUNT);
          note = "Swatter count-decreased to-"+SWATTER_COUNT;
        }
        if (note.length() >= 1) {
          statNotes.set(statNotes.size()-1, note);
        }
        sfx[6+index%2].play();
      }
      on = true;
    } else {
      on = false;
    }
  }
  void drawButton() {
    g.pushMatrix();
    g.translate(x, y, 0);
    color fillColor = on ? color(100, 255, 100) : color(0, 150, 0);
    color textColor = on ? color(0, 0, 0) : color(255, 255, 255);
    g.fill(fillColor);
    g.rect(-B_R, -B_R, B_R*2, B_R*2);
    g.fill(textColor);
    g.textAlign(CENTER);
    g.textSize(30);
    g.pushMatrix();
    g.translate(0, 0, EPS);
    String[] parts = name.split(",");
    for (int i = 0; i < parts.length; i++) {
      g.text(parts[i], 0, -20+30*i);
    }
    g.popMatrix();
    g.fill(0);
    if (index == 0) {
      g.text("Playback speed: "+playback_speed+"x", 75, -100);
    } else if (index == 2) {
      g.text("Swatter size: "+swatterSizeToText(R), 75, -100);
    } else if (index == 4) {
      g.text("Swatter speed: "+swatterSpeedToText(SWAT_SPEED, false), 75, -100);
    } else if (index == 6) {
      g.text("Mutation factor: "+nf(MUTATION_FACTOR, 0, 2), 75, -100);
    } else if (index == 8) {
      g.text("Swatter count: "+SWATTER_COUNT, 75, -100);
    }
    g.popMatrix();
  }
  String swatterSizeToText(float x) {
    return (int)(x*4)+" cm";
  }
  String swatterSpeedToText(float x, boolean shorten) {
    if (shorten) {
      return nf(x*2400, 0, 1)+"-sph";
    } else {
      return nf(x*2400, 0, 1)+" swats per hour";
    }
  }
}
