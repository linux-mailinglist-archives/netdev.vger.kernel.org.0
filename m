Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C621391F77
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 20:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235661AbhEZSsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 14:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235652AbhEZSr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 14:47:59 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E030C061574;
        Wed, 26 May 2021 11:46:28 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id ot16so1309897pjb.3;
        Wed, 26 May 2021 11:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9bT1ZH2VErkLjURREhlNnyvjAiTIdcoMHigd3+xuYoM=;
        b=MZnW+StndiGq+ptCj4DXVyubgTUn812g6BnYI7MvTnu+vqRY/+YbHVGzpp1/oWikIr
         SKQZOI+7Skw+i5ByzHySq+f7nguTwMWLS4Jhu5cfUsTHIiokJD25zlUc/IKXdHu3N3kb
         PyslOcP/r0k9USN167V7pRyYtOkqSWoV0NtJsueMx4aqbjMnzlcV0f1DhP8QGE8JUQxZ
         ORDtoX7QUQj7ex7HSmtt8R2UudMT4mHUIoNf3qXQiHnJMo0AxeZcEQJNGMMRiLk/El2z
         60NQMqhq59g50QpxIYIp3NZy2kT8mmHpSm32915Ri+jdOh7f1fXNjgnwbCxgCsazkhRl
         6qFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9bT1ZH2VErkLjURREhlNnyvjAiTIdcoMHigd3+xuYoM=;
        b=OZhTWo/BYgjlc1UwrwmrTqIHNSr+qwdOjsgZ0shH7B6iWmND8b+4tiFKfEm3FVV0lB
         3GKZ69Luug4Wd5EYfAqogE/mDDaz6RxCs7frtKpgnccvwtj3BMdXk9zYq2KTnMAFl3Pt
         tGFp59b/Zgt3HacOXZOU93QD+o7sgia5jkJV/yHudMVrQKQXZq4ryK4iGcinDAo1xiXI
         Dyqo36CoTFSrA76iFNjsZIViHAoIJ65D1Rf7MCy3Wn9KpSI06TEyYmtJJDSnt5uGpu64
         I3P8fcnA/TvLmhGXkJbr82c29fJh2PBWL9RUNzY9QiLg9XJCMEPt/N7zfyxnj8vo2wQn
         2TAQ==
X-Gm-Message-State: AOAM5303iSMdvy0TKEsrWVu5avUt5mXpnA0JsIedXoO8ewwJBnU0Cug2
        kAaGMrUfUI7A+hQm/7kF73Zc/XIcewE=
X-Google-Smtp-Source: ABdhPJzQjSDOdlnMN0NoWWGUqMOyWN9yoLFAKBO//PERzAHG6Dls2LxWoTGOQ2SxyAg2NwfF86qd0w==
X-Received: by 2002:a17:90a:f593:: with SMTP id ct19mr37526110pjb.225.1622054787260;
        Wed, 26 May 2021 11:46:27 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ck21sm3370pjb.24.2021.05.26.11.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 11:46:26 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     olteanv@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: phy: Document phydev::dev_flags bits allocation
Date:   Wed, 26 May 2021 11:46:17 -0700
Message-Id: <20210526184617.3105012-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the phydev::dev_flags bit allocation to allow bits 15:0 to
define PHY driver specific behavior, bits 23:16 to be reserved for now,
and bits 31:24 to hold generic PHY driver flags.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/linux/phy.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 60d2b26026a2..852743f07e3e 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -496,6 +496,11 @@ struct macsec_ops;
  * @mac_managed_pm: Set true if MAC driver takes of suspending/resuming PHY
  * @state: State of the PHY for management purposes
  * @dev_flags: Device-specific flags used by the PHY driver.
+ *		Bits [15:0] are free to use by the PHY driver to communicate
+ *			    driver specific behavior.
+ *		Bits [23:16] are currently reserved for future use.
+ *		Bits [31:24] are reserved for defining generic
+ *			     PHY driver behavior.
  * @irq: IRQ number of the PHY's interrupt (-1 if none)
  * @phy_timer: The timer for handling the state machine
  * @phylink: Pointer to phylink instance for this PHY
-- 
2.25.1

