Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E9135B315
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 12:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235439AbhDKKYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 06:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235232AbhDKKYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 06:24:20 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA09C061574;
        Sun, 11 Apr 2021 03:24:04 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id j4-20020a05600c4104b029010c62bc1e20so5194846wmi.3;
        Sun, 11 Apr 2021 03:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VuieLTzBQMvy8mue0owP51dERT6G+/SkxQSTh/6CNk0=;
        b=igZCNLtmRUAJ0bgI0HFooxvVKwKvCx31jHqj6giIeEYT58bzdhkmm1JPS9Q010bowl
         wgKiTz4/WOpQCqdNSJ/PFfO9Oo/H9qeTVkNE4z7oMI9MsCwDQ3EZLsL5CvL24bMwYq3Z
         jEvalMpt49sfUs1FFupkTjBGpuIzmY+HotOmS8blSK+aDif3zHtedg77sWOFdHzIWslx
         a70jBLa7dUEfScqljoih+xORSuSjr0I6Ig7QbZq2KHTS0olqSfEAhdpnFv1E2XSfVPzE
         bLudUK37IM8pg7nn93jletLVIWFzBvlPQR5Vtgfap2TVhJDAlPhlvYT2n4jUJJns1/l1
         n/rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VuieLTzBQMvy8mue0owP51dERT6G+/SkxQSTh/6CNk0=;
        b=iweoO7EolPvMS+tiZOZdS0AKuIthCcBikqwBXjGQ9tmzE8KEfeuVCpWEIxTnMlQeTN
         LCrD758Vc8kYtnt3/EK6NTDt6XROQK4SgLV6j6LiHGMeoepJzovlQCZm7Sz9PtQ0bhaV
         K4rmJ7Kucxjv7Hv/dEZxZF2xGX0Tw1m3iBVwod+Mkrk8Eq7xwchSgWrNJVQ1mHKoBIyo
         7krwTyls2ZQSahtvL24ZjtrFkY692i9l43Ot5UmWymKiAf1JVpUsCkiVhkTfLINnYYaU
         CXzEkKRZEaSWfRG/tBSdiM/e1eZxPmfCEfY3PO3IfPNXan0jt5wCwjXVofT0Q8Uuwgpz
         oJJw==
X-Gm-Message-State: AOAM532ZoLzkOdrNNAs2hzhEh2CrG5YiEIpeb3c0P3FsL93GgyTDsqMk
        1228qwK0gBjFT4pY9f1WyyiL1gxcFhA=
X-Google-Smtp-Source: ABdhPJy3Uaoov53CD0DbmTt/pFY/5OjhTJTTulGBdHbWSosUVhaqZ10fJBNsEzn9j5gbIAbkX6gdBw==
X-Received: by 2002:a7b:cf2e:: with SMTP id m14mr1405721wmg.73.1618136643061;
        Sun, 11 Apr 2021 03:24:03 -0700 (PDT)
Received: from localhost.localdomain (p200300f137277800428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:3727:7800:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id o25sm12553309wmh.1.2021.04.11.03.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 03:24:02 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     stable@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hauke@hauke-m.de, f.fainelli@gmail.com, davem@davemloft.net,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH stable-5.4 0/2] net: dsa: lantiq_gswip: backports for Linux 5.4
Date:   Sun, 11 Apr 2021 12:23:42 +0200
Message-Id: <20210411102344.2834328-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This backports two patches (which could not be backported automatically
because the gswip_phylink_mac_link_up function is different in Linux 5.4
compared to 5.7 and newer) for the lantiq_gswip driver:
- commit 3e9005be87777afc902b9f5497495898202d335d upstream.
- commit 4b5923249b8fa427943b50b8f35265176472be38 upstream.

This is the first time that I am doing such a backport so I am not
sure how to mention the required modifications. I added them at the
bottom of each patch with another Signed-off-by. If this is not correct
then please suggest how I can do it rights.


Thank you!
Martin


Martin Blumenstingl (2):
  net: dsa: lantiq_gswip: Don't use PHY auto polling
  net: dsa: lantiq_gswip: Configure all remaining GSWIP_MII_CFG bits

 drivers/net/dsa/lantiq_gswip.c | 203 ++++++++++++++++++++++++++++-----
 1 file changed, 175 insertions(+), 28 deletions(-)

-- 
2.31.1

