Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E46D719EB98
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 15:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgDENt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 09:49:59 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33156 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgDENt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 09:49:59 -0400
Received: by mail-wm1-f68.google.com with SMTP id z14so5857860wmf.0
        for <netdev@vger.kernel.org>; Sun, 05 Apr 2020 06:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references:reply-to
         :mime-version:content-transfer-encoding;
        bh=L3c3HjFnEPfOn7OLYmFJnF9OygmltTZwNyqX02+3Ls0=;
        b=f3tHDKEBLMdGbUtp14HZOViF7glcvz/aPTCUQrDfHT6C1cBTbwx5oW2mDREfmxp70v
         +X7hhLh3RScmSvmbvhK3ruWsh06cSWWN+lOVudLEbsCA9Z3+rlaR2f2RN9Z4hlq/p6ms
         uzW68YaFl1PLvBQ8c7JCX+SNw9yRXA1G4FGlTQgt++KeIDFbk7NkaNZQTzAEqlX/XFAy
         lNIX3biR27Scgv+6tw1kFT6ORO2xQlxjp5w5mX1h6MxevL1Bw+Y1DMhYmuq5EGIC0txV
         gWnLZMSwMUzrYc5OXvtRnOon1Zgq2N2D7AkqkE5UHbOzrbLlJD1ypo12FzbXiAZQ9ULt
         W74g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:reply-to:mime-version:content-transfer-encoding;
        bh=L3c3HjFnEPfOn7OLYmFJnF9OygmltTZwNyqX02+3Ls0=;
        b=SPYMMpy3LV2WoT00CNU68fx9/CZbFU7OTzRBqhKFi+9krgKcmx5X7uWuIJpR2Zaw3Q
         HUAUYOdGEerJMXpEFGdgCQm0tpK9GsfI/7xsVXi7eeep2yEPXWw4T/eutmlaVCVWDD1R
         Mts6k4dTrG2XeEELzntcbHYJUd7Kt1CQAxG+9KFz6nzNUG4O4HR1Br63IhKLxhSIIFGs
         MkE192pSgIbK/twZiDNGblQlHrewpvYAfqgkuOTdAsTVOF/V+G7+a+3740BHZ4LZFNum
         EXxDSSorfdq2YQk3AQ+RFiPRPNZUIfR2SUtVpY0R6b5fgwbRlJWv8IWPAp2wixb9BCBy
         gUvA==
X-Gm-Message-State: AGi0Puaf5Gk8sEx5fLOOB644Nd7Qhww+E2nnX67FfvydeodZuKs6C9Y0
        dT2eJF3f31Qd+IKveNKJ44LAgWjs
X-Google-Smtp-Source: APiQypJEfZ4MhrKIEweVJw1ZyVRKDVjvRResgaGSMNf8VRH6d0/nfRA5tNWrbofFzJMnahTbs+FfuA==
X-Received: by 2002:a1c:9658:: with SMTP id y85mr17907285wmd.63.1586094596830;
        Sun, 05 Apr 2020 06:49:56 -0700 (PDT)
Received: from localhost ([2a01:e35:2f01:a61:fc49:14b:88c:2a9c])
        by smtp.gmail.com with ESMTPSA id q9sm3997473wrp.61.2020.04.05.06.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2020 06:49:55 -0700 (PDT)
From:   "=?UTF-8?q?Bastien=20Roucari=C3=A8s?=" <roucaries.bastien@gmail.com>
X-Google-Original-From: =?UTF-8?q?Bastien=20Roucari=C3=A8s?= <rouca@debian.org>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bastien=20Roucari=C3=A8s?= <rouca@debian.org>
Subject: [PATCH iproute2 1/6] Better documentation of mcast_to_unicast option
Date:   Sun,  5 Apr 2020 15:48:53 +0200
Message-Id: <20200405134859.57232-2-rouca@debian.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200405134859.57232-1-rouca@debian.org>
References: <20200405134859.57232-1-rouca@debian.org>
Reply-To: rouca@debian.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This option is useful for Wifi bridge but need some tweak.

Document it from kernel patches documentation

Signed-off-by: Bastien Roucariès <rouca@debian.org>
---
 man/man8/bridge.8 | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index b9bd6bc5..efb84582 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -383,6 +383,34 @@ there is no MDB entry. By default this flag is on.
 Controls whether a given port will replicate packets using unicast
 instead of multicast. By default this flag is off.
 
+This is done by copying the packet per host and
+changing the multicast destination MAC to a unicast one accordingly.
+
+.BR mcast_to_unicast
+works on top of the multicast snooping feature of
+the bridge. Which means unicast copies are only delivered to hosts which
+are interested in it and signalized this via IGMP/MLD reports
+previously.
+
+
+This feature is intended for interface types which have a more reliable
+and/or efficient way to deliver unicast packets than broadcast ones
+(e.g. WiFi).
+
+However, it should only be enabled on interfaces where no IGMPv2/MLDv1
+report suppression takes place. IGMP/MLD report suppression issue is usually
+overcome by the network daemon (supplicant) enabling AP isolation and
+by that separating all STAs.
+
+Delivery of STA-to-STA IP mulitcast is made possible again by
+enabling and utilizing the bridge hairpin mode, which considers the
+incoming port as a potential outgoing port, too (see
+.B hairpin
+option)
+
+Hairpin mode is performed after multicast snooping, therefore leading to
+only deliver reports to STAs running a multicast router.
+
 .TP
 .BR "neigh_suppress on " or " neigh_suppress off "
 Controls whether neigh discovery (arp and nd) proxy and suppression is
-- 
2.25.1

