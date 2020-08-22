Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5509C24E9AB
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 22:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgHVULt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 16:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727835AbgHVULj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 16:11:39 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58432C061575;
        Sat, 22 Aug 2020 13:11:39 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id g33so2623241pgb.4;
        Sat, 22 Aug 2020 13:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6Kfvc07KnFV6nKclJZr/cFA7EIyFxekC1g+RcPpqClY=;
        b=pcy5DBKwp0IUeVnQfZV16PyG6BlMWsBm61fif66TBVPzkcGL0gy46BQ0kFxcV0Oejm
         Bklv7P2M0Lt+hkI8k2rDxVov1eiIiSHYU+w/X8FOqK8sDoHjdiIEyy6nyuuF3tgY/NZk
         fkC/TGTMf+Ns+Qe6jT8qkAlqBBoGLXbtGi91Fp8vm7p2XL6s0yIMJrqb1k7BU/1MSw/u
         uGpe8OtBpbhNOvFgjc4nB+Yq0EpqM86r+KS33rfNKuo+prbd84DCRJOC6nqsrPnhe2vY
         mCqObsf8fRH5GsXX52t8pkCjfQYcAue+Gf+GI8tntn27Tz3jjiHliKeFNp35rrzEm11O
         /AtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6Kfvc07KnFV6nKclJZr/cFA7EIyFxekC1g+RcPpqClY=;
        b=CdVlBXknsMSe2jBro5JwAGvSjNZCh7V22V7JYTEMhELGZhyl3iJOobeVsu8kO8AM+Q
         8vkfAS9ac7M//rrhEVBXqkf0gdNgmXq0qVs17BOQRDs1Z2kxP6xh/T58pzjbKj6FAOXg
         b8WF9LxGNyTREOvZL8U2qyJPQVj8Tfhh/ri9XvmZUklbsVPXhQrG6uaCi0CQDSZK3yNy
         fvTsRFlG9PafBXX8PbH3e7FyaxLTOTpQjKUkTqzOpk77xxwPuBmKEZEAMXMUSbrgebAB
         KygDxj9FD8rT/w7F1vQpqzQHqY5qze9pg90iWAI9Bf9k7cRHDUsSjVqygMrDnkDCiC+F
         zZaQ==
X-Gm-Message-State: AOAM530mzWwz3IcKywbOInQncmkvPkEY0aCtRRjfwxOCPecsPMTB1FYy
        LQpH9u6/dsn+kkuTm0PpcITiDSgRjFE=
X-Google-Smtp-Source: ABdhPJynfwQul2i/+fsRtGZNQqd4QLafqNZ7W8yorcSKcbzP7Agw/DXGrnYywp0BlYWtm0UWxFVEOQ==
X-Received: by 2002:a63:475d:: with SMTP id w29mr5901152pgk.287.1598127098341;
        Sat, 22 Aug 2020 13:11:38 -0700 (PDT)
Received: from 1G5JKC2.lan (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id na16sm4678779pjb.30.2020.08.22.13.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Aug 2020 13:11:37 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next 3/6] MAINTAINERS: GENET: Add DT binding file
Date:   Sat, 22 Aug 2020 13:11:23 -0700
Message-Id: <20200822201126.8253-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200822201126.8253-1-f.fainelli@gmail.com>
References: <20200822201126.8253-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the DT binding was added in aab5127d94e6 ("Documentation: add
Device tree bindings for Broadcom GENET"), the file was not explicitly
listed under the GENET MAINTAINERS section, do that now.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index cd80f641f9fd..5aeb00031182 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3580,6 +3580,7 @@ M:	Florian Fainelli <f.fainelli@gmail.com>
 L:	bcm-kernel-feedback-list@broadcom.com
 L:	netdev@vger.kernel.org
 S:	Supported
+F:	Documentation/devicetree/bindings/net/brcm,bcmgenet.txt
 F:	drivers/net/ethernet/broadcom/genet/
 F:	include/linux/platform_data/bcmgenet.h
 
-- 
2.17.1

