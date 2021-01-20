Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F472FDAC9
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 21:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732696AbhATU0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 15:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731500AbhATN4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 08:56:49 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A221C061796
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 05:53:44 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id f132so25036792oib.12
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 05:53:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=qKm/5nHdMA8bMVyhwHXXL3R+iJeDftGlaorh/puXb0A=;
        b=friO0R3et4GMB30ymxR+9DjkEuitqE518ec1XDJ0FDqtk4UMhpAKvRCMlcQ4QESeqD
         f/hkpmGvakqgZkvw/IAgGLYMF1Il/UVlpAMQ3/yySIZF43INnY2qaOfqchs+QBdTheUN
         jQJQbsxGvhiPqCc+c06HqWihvnS/fNMnBu36wGGsV7kIPSu6NjycN/bdJGt+GjzOu+6P
         OuqhQVI9UfLd2jgjhvX6mHqyC8wmeRxM4s9EMJnPchho/3xRWc40utytNwjJd6Dpr06j
         YbUUVmMZsq5UBg8cPaA4SkL8nqXnBsNPSFKxr0IJR0gIj1xigscax5tuE0VwgS08fF8U
         mStw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qKm/5nHdMA8bMVyhwHXXL3R+iJeDftGlaorh/puXb0A=;
        b=MEnpJWKERRQbIks6zh5iEOeeUHN/U0JH9l+C7ocE7fhUJxZlCcRQm72tTOsXmtenOq
         hWyKqmFyfj806WQyk3wrgMODMMpDukcRUks0FQV3fY3eIN6UK4A5T5h3JYvU/qPB8UqB
         RnfmWnVP9F4jnlj20zsZr4F7Ewin7l2vmieQbQQlIJJg88puDPVdUug1IY6EM6W4p0ZB
         xnBwto/Ko+pgFAv1jfIidI/ZF9MDso9G1calVltezuoY8ukzR9SeccFbi+hDtJP4mH3e
         N8AZ7FgPTepZbUFS6rB4X5Am5sriGdNDQPyZjnDaWCaggSjSBns4b0MvFzT2OaKn3A4Q
         d4vg==
X-Gm-Message-State: AOAM532iIBfVUF/J4/kPeUMM3ZMLTZZmvwog6uJfYIoYhZPkv0FbxSgH
        W6HFHRDVWZi7IF4Vp6B+4w==
X-Google-Smtp-Source: ABdhPJyW7azWUng2V3EuxCt4KZvXb7UVZuz8AYagOEb9wD5lbiU/g3+UWnC4KRmM3gY/VtVbzsBwvA==
X-Received: by 2002:aca:3bd6:: with SMTP id i205mr2959908oia.156.1611150823647;
        Wed, 20 Jan 2021 05:53:43 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id t2sm410153otj.47.2021.01.20.05.53.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Jan 2021 05:53:42 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH] MAINTAINERS: add entry for Arrow SpeedChips XRS7000 driver
Date:   Wed, 20 Jan 2021 07:53:23 -0600
Message-Id: <20210120135323.73856-1-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add myself as maintainer of the Arrow SpeedChips XRS7000 series Ethernet
switch driver.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: George McCollister <george.mccollister@gmail.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 096b584e7fed..992530a481a0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2787,6 +2787,14 @@ F:	arch/arm64/
 F:	tools/testing/selftests/arm64/
 X:	arch/arm64/boot/dts/
 
+ARROW SPEEDCHIPS XRS7000 SERIES ETHERNET SWITCH DRIVER
+M:	George McCollister <george.mccollister@gmail.com>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
+F:	drivers/net/dsa/xrs700x/*
+F:	net/dsa/tag_xrs700x.c
+
 AS3645A LED FLASH CONTROLLER DRIVER
 M:	Sakari Ailus <sakari.ailus@iki.fi>
 L:	linux-leds@vger.kernel.org
-- 
2.11.0

