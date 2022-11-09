Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8EB6623762
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 00:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbiKIXTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 18:19:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiKIXTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 18:19:15 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8725013E39
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 15:19:14 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id l15so113279qtv.4
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 15:19:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rGNZF8dGsqBuXq/CbL9m2LBRm/mmLig2pj3Vwn197ew=;
        b=ltvQlwVXjuy134dBIeKeSBw1nZ0ollwAy41skSGReR0PmQ0G/vyONe3tuBcsJj+WE2
         hVsXTPpAn4/YO2vZ5tzbfsQP8fo8OVm5zG4AGfePI7MDofIJsWbQ0OLV/IM01TIcic3t
         ocH9opV1FLtiXHTJEA/FSNkxRQSTMssEzwSHiSbz4L+RyQTtSiFVEeCsD0DFhNta8sj1
         Y6tG+np8q/+dmneVDLawQSxTE4NOYDLYSLnxiO/h5KKM3Wamnv95qnrRSyqGCeFdxLXK
         Ljm8G1vWS6rsrGFziKdb0VM2tcDoScELHy6fY3CCcQ+ouD9br9FBPJLkjrZCJMeE2gUr
         ix0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rGNZF8dGsqBuXq/CbL9m2LBRm/mmLig2pj3Vwn197ew=;
        b=S2wDrVawd2xOfCtA4sjQlttOZkb4Kte6T4pZcvQdnmUjZ1/jjeXOLNui86EGzxYOEP
         ooIz9mqyMKNvIcMZsTuiIUbMgNz57jamPP48o+z5D8WWxRYg3i9viuqV0nMNPzmcCiPP
         xxtBm8rUGYIyUepM2OWQ+XuLEbkZf6u8L/TtFHlU+9aRGdA8s6e4ZpNd7fcbp/tq/U1F
         4MUm6EI2eHEX66JZSg1BGqgJ9agCtN0qviqI8VAbqsqlJYFn084RZjhSW/U/YQwO3h8U
         odrIG1dko71wTX88kPO1Ug0RDvNCrjV3u31Yi501Bc2CFiPcVsG+vfkFsrasmxOD6nbh
         Wmeg==
X-Gm-Message-State: ACrzQf2WJEo3s4mw1+2XLU2K9mNN3Z7RZqEnmK+AEuEE1IEJBQJOVWoK
        nUNNAihAZPdciePpSRzilGi1gF3CK15YtQ==
X-Google-Smtp-Source: AMsMyM6o9mAkip/3togVEo6mvUAYmvF9JpWh5jiOfuO8h2xFe7ustC5hbHZjVq7waHLUrtPOlWVcxA==
X-Received: by 2002:ac8:7ecd:0:b0:3a5:69a1:c05e with SMTP id x13-20020ac87ecd000000b003a569a1c05emr22826248qtj.149.1668035953149;
        Wed, 09 Nov 2022 15:19:13 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id fg26-20020a05622a581a00b00399b73d06f0sm10379364qtb.38.2022.11.09.15.19.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 15:19:12 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net] MAINTAINERS: Move Vivien to CREDITS
Date:   Wed,  9 Nov 2022 15:19:07 -0800
Message-Id: <20221109231907.621678-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Last patch from Vivien was nearly 3 years ago and he has not reviewed or
responded to DSA patches since then, move to CREDITS.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 CREDITS     | 5 +++++
 MAINTAINERS | 2 --
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/CREDITS b/CREDITS
index 1841184c834d..54672cbcd719 100644
--- a/CREDITS
+++ b/CREDITS
@@ -918,6 +918,11 @@ S: Ottawa, Ontario
 S: K1N 6Z9
 S: CANADA
 
+N: Vivien Didelot
+E: vivien.didelot@gmail.com
+D: DSA framework and MV88E6XXX driver
+S: Montreal, Quebec, Canada
+
 N: Jeff Dike
 E: jdike@karaya.com
 W: http://user-mode-linux.sourceforge.net
diff --git a/MAINTAINERS b/MAINTAINERS
index e1bc31a6624b..239407627be2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12226,7 +12226,6 @@ F:	arch/mips/boot/dts/img/pistachio*
 
 MARVELL 88E6XXX ETHERNET SWITCH FABRIC DRIVER
 M:	Andrew Lunn <andrew@lunn.ch>
-M:	Vivien Didelot <vivien.didelot@gmail.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/marvell.txt
@@ -14324,7 +14323,6 @@ F:	drivers/net/wireless/
 
 NETWORKING [DSA]
 M:	Andrew Lunn <andrew@lunn.ch>
-M:	Vivien Didelot <vivien.didelot@gmail.com>
 M:	Florian Fainelli <f.fainelli@gmail.com>
 M:	Vladimir Oltean <olteanv@gmail.com>
 S:	Maintained
-- 
2.34.1

