Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93EF324E9B0
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 22:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgHVUMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 16:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727940AbgHVULp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 16:11:45 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EFDC061573;
        Sat, 22 Aug 2020 13:11:44 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id m71so2793948pfd.1;
        Sat, 22 Aug 2020 13:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jyO7f+j1vuCb+b30qlii0I3Vzsd6SOJfpP+qBF/QCfQ=;
        b=TCGw7dlnQfK1i4qQ2jBe6mOTWhegoSGcetVuhPX53UC7MxZzTeeOV3TBkRGI5YKsy2
         0Rhe4rjAlunyJ94A9/HMpY64c8MCIAuL4TSEsZbvE7093CCxAdqiZjS/+IGBZcdMSoPG
         CtZLKG4n3jOWIUh5H1KWITJYr0Gw6vt2nXBHKy3RfDNBPDFOxzj8pGhjrk/JL1CD+N31
         2p2KLlygZyrAXR0oKdfzrRPrIU/+O1G16fZPhmU8mhFlbQfMBvDK2QmMTAr6eoAhpJ/c
         wcyboBpdDMOEsrl2H9oH3Gqp7zkg7xNp62f2M+u08Q10UxzySSpDrP0sDZjwkXCrv16y
         SdPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jyO7f+j1vuCb+b30qlii0I3Vzsd6SOJfpP+qBF/QCfQ=;
        b=DP+RNcLEw0+W5tWGdRNU4XwF1tmCeGYB2SfYgUg1WrQgJwA72LS/WbRsr2tTPXpgcX
         iRhqXB7J8IRLAoj5OtQdcZ7n0hXQu/nroOTphZ3ejqAijNXTG1uoiCMSvbRT9/vbRUEX
         KccHRqIFigX3nEnjMFMaCYVCxWw7n5sLGfZ6yBszEvY+Cpp8mDjzL10DaWN5JwOELyPT
         i7ZIZS1p9Cf26Nr076TG1bsxBLx+l7wjjlhZiqhnUmN4cOV3XHFDPBkIM/6eHZcJyVgV
         OPybFcSswypGIZgHd/G03GzkhtzUSti10DsgYfg5hi0GROLxq6wSoNbACemmbB6L1HfL
         aFcw==
X-Gm-Message-State: AOAM532uTU6zxPuaqL6gEQWi0uI1P3e2vuNsI1pwaIV2868TCu245ooD
        PdK1Uo6IMY7TUKV7dgPrcuIfdlxAMKM=
X-Google-Smtp-Source: ABdhPJw5/CIYTMOh5TqqzBJTLSfkyC5kzm0G6L9QoxR1EHBD+rIjky1hLhQrED/t/U+9msb2uFdpCA==
X-Received: by 2002:a62:1c8:: with SMTP id 191mr465051pfb.147.1598127103999;
        Sat, 22 Aug 2020 13:11:43 -0700 (PDT)
Received: from 1G5JKC2.lan (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id na16sm4678779pjb.30.2020.08.22.13.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Aug 2020 13:11:43 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next 6/6] MAINTAINERS: Remove self from PHY LIBRARY
Date:   Sat, 22 Aug 2020 13:11:26 -0700
Message-Id: <20200822201126.8253-7-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200822201126.8253-1-f.fainelli@gmail.com>
References: <20200822201126.8253-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My last significant achievements to the PHY library was ensuring we
would have small bus factor by having Andrew and Heiner added. The world
has moved on past 1G, but I have not, so let more competent maintainers
take over.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index db4158515592..b1474c669e1e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6519,7 +6519,6 @@ F:	net/bridge/
 
 ETHERNET PHY LIBRARY
 M:	Andrew Lunn <andrew@lunn.ch>
-M:	Florian Fainelli <f.fainelli@gmail.com>
 M:	Heiner Kallweit <hkallweit1@gmail.com>
 R:	Russell King <linux@armlinux.org.uk>
 L:	netdev@vger.kernel.org
-- 
2.17.1

