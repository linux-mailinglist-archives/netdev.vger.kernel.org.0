Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F802229779
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 13:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731845AbgGVLdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 07:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgGVLdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 07:33:01 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5328CC0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 04:33:01 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id x8so832514plm.10
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 04:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=puresoftware-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:to:cc:subject:date:message-id;
        bh=j16Wd1OUo6S2SEkI1fl92ldDz7zf2moCQxQ+glyGpk8=;
        b=XnMqcRjbU1P9qUJyk4oxioVJWao9SIRp7b8ifCOokw3r+rpSnrYyfm7ED/OheN3BUK
         ZkB+Faq+CiGWwVgRV2tRVR1KDSub672uhNg6O/OY2+eakGkkoiXuL7gVWd48v9pEh1Ds
         YuY0r0uPxwGNfQNHaFTyIOxxS1BPuIqnaC078Zzo7KummVLhk7EQouMX08GrUMBAUBdw
         TjERS/pkuYLDMrraXFLr54uLONGTYA9c1pHKlyzY9wOAIL8RXn5GGaVfqDyC5X7HBltJ
         xPrgWadjLgkjEb0WKun2GeqCSXolbjadvJmSMznNYU4fQEL1cdJvVxTy6ePooIKiakqm
         sL4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=mime-version:x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=j16Wd1OUo6S2SEkI1fl92ldDz7zf2moCQxQ+glyGpk8=;
        b=kBwB4uFV4udiwXgndQImhkAWaXS/NFFmKTtsreEvfkyjc8Yy/Oo8W+JHVaUCr7I4r4
         Sv4PiuCBeYFZ8fFid643gg73ekiNpn8zfAlw4rmhOdMWpw+j/nCBtn/4IWiCg5TxD7Ar
         3a/NmXzRMn+9vG7brlW4qJzEn6EH1hpie4nWA+UgA6F6C5652n64g2N7icMzg4YBRgGN
         KLp4i2A/PqqxB5ITh2c1+hDJKNVOVmpdUDD4qjvkC6Kl7hGJj+ig+6xH2JH65LHIp8Nq
         jeux0HgHJWygsqWAA9jvNSzv7ZpwqYlIidArtIRHvR0OeTDarrw7LCUKBD8ofttjhydH
         WE/A==
MIME-Version: 1.0
X-Gm-Message-State: AOAM530i6BP3y+QrLvhYT7/d36GppdTfwgef8k6Ywk2Kty7JBkFd7m1d
        UFmWUTKkYsjVmcMZc3i6xg7R6mz7hw6YFaS/JFHwqf5rfRSS/giqSjFBulDCkYIAgBxeb+geRzm
        3F+nqOaxpsw==
X-Google-Smtp-Source: ABdhPJxV6r3AeGLEWjowVKZ+EvV7pSQ1kqnA1K0nmffp5maXWY/8XNgYfUlVxZJUKuGm4+SQUxvn4A==
X-Received: by 2002:a17:90a:ac14:: with SMTP id o20mr9657210pjq.185.1595417580816;
        Wed, 22 Jul 2020 04:33:00 -0700 (PDT)
Received: from embedded-PC.puresoft.int ([125.63.92.170])
        by smtp.gmail.com with ESMTPSA id 66sm24783715pfa.92.2020.07.22.04.32.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jul 2020 04:33:00 -0700 (PDT)
From:   Vikas Singh <vikas.singh@puresoftware.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org
Cc:     calvin.johnson@oss.nxp.com, kuldip.dwivedi@puresoftware.com,
        madalin.bucur@oss.nxp.com, vikas.singh@nxp.com,
        Vikas Singh <vikas.singh@puresoftware.com>
Subject: [PATCH 0/2] Add fwnode helper functions to MDIO bus driver
Date:   Wed, 22 Jul 2020 17:02:25 +0530
Message-Id: <1595417547-18957-1-git-send-email-vikas.singh@puresoftware.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain; charset="US-ASCII"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add helper functions to handle fwnodes on MDIO bus in case of
ACPI probing. These helper functions will be used in DPAA MAC driver.

The patches are in below logical order:
1. Add helper function to attach MAC with PHY
2. Associate device node with fixed PHY by extending "fixed_phy_status"

Vikas Singh (2):
  net: phy: Add fwnode helper functions
  net: phy: Associate device node with fixed PHY

 drivers/net/phy/fixed_phy.c |  2 ++
 drivers/net/phy/mdio_bus.c  | 66 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mdio.h        |  4 +++
 include/linux/phy_fixed.h   |  2 ++
 4 files changed, 74 insertions(+)

-- 
2.7.4


-- 




*Disclaimer* -The information transmitted is intended solely for the 
individual
or entity to which it is addressed and may contain confidential 
and/or
privileged material. Any review, re-transmission, dissemination or 
other use of
or taking action in reliance upon this information by persons 
or entities other
than the intended recipient is prohibited. If you have 
received this email in
error please contact the sender and delete the 
material from any computer. In
such instances you are further prohibited 
from reproducing, disclosing,
distributing or taking any action in reliance 
on it.As a recipient of this email,
you are responsible for screening its 
contents and the contents of any
attachments for the presence of viruses. 
No liability is accepted for any
damages caused by any virus transmitted by 
this email.
