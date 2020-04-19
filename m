Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754181AF655
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 05:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgDSDIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 23:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbgDSDIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 23:08:51 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FA7C061A0C;
        Sat, 18 Apr 2020 20:08:51 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id n16so3291876pgb.7;
        Sat, 18 Apr 2020 20:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HtCqRr1lMTX0JXiamjHR7TbLRldbnlssn2WnfkSf7dM=;
        b=S4iH2O591G6zmLgi3xeDv7IV3lf8YUaN7PKuOfc1wWLO7kQU2Jn3Z++jyKKDMkbeTG
         EnVGhI8i/l6QCO/wvxtO26ZkbObBrBlQjLypRO/O54JATNNzYE6K78XXQwupCtd43UL2
         X0ZxSElBufJYvyplv4YBlo9zZPS6NrMdX1tROHKe5+yy6SeAgkQE7yrqEyCGzSQZDTA7
         E573vEP+40eX6s3AlNvfn216xxqy6u7QYZWejfCtxG8WhPqEGLPPLX+0i0G/l47L7T/m
         5MB/qdHlv8ezZM0JMtQ1EQFU2/nkm65HKW04z67xx3X1cV1ApKYkNRE/RmKvEK2fXVAd
         F7Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HtCqRr1lMTX0JXiamjHR7TbLRldbnlssn2WnfkSf7dM=;
        b=hsFl11G4DZkldbJp6CdtnR23TxNhnunay4LY6JLW/oUVKSJdQ2nHAKuOPlkeLnFrc1
         AcjIw48XF6F/Uyx+bV6bCQ43vS3Z0SejoPuYTokE1ghFZjVR+m9woGYsD4bwBfjJeeqB
         wOsoiGBymOqUi4/25rWbDKnlx1mPruSl8yCmyJ39Joo8gboV1KbCHTvnGzoqMM3gBajN
         641pJsvXcxMjTmv0HUBk8lTXvzlOHmw/pDPJmy9N0pbxMNvPS1+TLb0mEIThA626bl+J
         FYU2n5D3XZ6hILt8XCiQdic0XBSyKmVJgT+eUA/fhNuL3Jw/XDineag5t9m12JOHFqVK
         VJcA==
X-Gm-Message-State: AGi0Pua/wWAE44FwqwlbfOA0x1Le4dMBjY24GdXus25/JUZdJeSbUqHz
        4qdfRH1uMpK7i68iFcb2kfhbQgE6
X-Google-Smtp-Source: APiQypK43JJB72Xml4+Ac4LUUKe6d23h7l/4noJdxuBPOvRXNPdd8l6jSMMBY7tZvuR7nqsjWimIsA==
X-Received: by 2002:aa7:9218:: with SMTP id 24mr10457252pfo.312.1587265730437;
        Sat, 18 Apr 2020 20:08:50 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id g12sm8686146pfm.129.2020.04.18.20.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2020 20:08:49 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v2 0/2] dt-bindings: net: mdio.yaml fixes
Date:   Sat, 18 Apr 2020 20:08:41 -0700
Message-Id: <20200419030843.18870-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patch series documents some common MDIO devices properties such as
resets (and delays) and broken-turn-around. The second patch also
rephrases some descriptions to be more general towards MDIO devices and
not specific towards Ethernet PHYs.

Florian Fainelli (2):
  dt-bindings: net: mdio: Document common properties
  dt-bindings: net: mdio: Make descriptions more general

 .../devicetree/bindings/net/mdio.yaml         | 37 ++++++++++++++++---
 1 file changed, 32 insertions(+), 5 deletions(-)

-- 
2.19.1

