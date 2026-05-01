class Calculators {
  static int calculateCHA2DS2VASc(int age, String sex, Map<String, bool> pastHistory) {
    int score = 0;
    
    // H - Hypertension
    if (pastHistory['Hypertension'] == true) score += 1;
    
    // A2 - Age >= 75
    if (age >= 75) {
      score += 2;
    } else if (age >= 65) {
      // A - Age 65-74
      score += 1;
    }
    
    // D - Diabetes
    if (pastHistory['Diabetes Mellitus'] == true) score += 1;
    
    // V - Vascular disease (Count ACS as Vascular disease)
    if (pastHistory['History of ACS'] == true) score += 1; 
    
    // Sc - Sex Category (Female)
    if (sex.toLowerCase() == 'female') score += 1;

    return score;
  }

  static int calculateGRACE(int age, dynamic hrStr, dynamic bpStr, dynamic creatinineStr) {
    // Simplified GRACE score. A full score requires more detailed input (Killip class, arrest, etc.).
    int score = 0;
    
    // Age
    if (age <= 39) score += 0;
    else if (age <= 49) score += 18;
    else if (age <= 59) score += 36;
    else if (age <= 69) score += 55;
    else if (age <= 79) score += 73;
    else if (age >= 80) score += 91;

    // Heart Rate
    int hr = int.tryParse(hrStr?.toString() ?? '') ?? 0;
    if (hr > 0) {
      if (hr < 50) score += 0;
      else if (hr < 70) score += 3;
      else if (hr < 90) score += 9;
      else if (hr < 110) score += 14;
      else if (hr < 150) score += 23;
      else if (hr < 200) score += 35;
      else score += 46;
    }

    // Systolic BP (Extract from e.g., "120/80")
    int sbp = 0;
    if (bpStr != null && bpStr.toString().contains('/')) {
      sbp = int.tryParse(bpStr.toString().split('/')[0].trim()) ?? 0;
    } else {
      sbp = int.tryParse(bpStr?.toString() ?? '') ?? 0;
    }

    if (sbp > 0) {
      if (sbp < 80) score += 58;
      else if (sbp < 100) score += 53;
      else if (sbp < 120) score += 43;
      else if (sbp < 140) score += 34;
      else if (sbp < 160) score += 24;
      else if (sbp < 200) score += 10;
      else score += 0;
    }

    // Creatinine (assuming mg/dL input)
    double cr = double.tryParse(creatinineStr?.toString() ?? '') ?? 0.0;
    if (cr > 0.0) {
      if (cr <= 0.39) score += 1;
      else if (cr <= 0.79) score += 4;
      else if (cr <= 1.19) score += 7;
      else if (cr <= 1.59) score += 10;
      else if (cr <= 1.99) score += 13;
      else if (cr <= 3.99) score += 21;
      else score += 28;
    }

    return score;
  }
}
