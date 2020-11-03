Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF4E52A3AB3
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 03:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbgKCCzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 21:55:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbgKCCzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 21:55:44 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199B7C0617A6;
        Mon,  2 Nov 2020 18:55:44 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id r10so12511436pgb.10;
        Mon, 02 Nov 2020 18:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=I2zaxNy7Koprks7U2CkvxZK+6R7/l1nRgPFPQ7Oc2Qk=;
        b=Bs4CGIEGxSOmM5e7SQELu7VnsVKiXgXuiZcJLhsGdv1iT7sK9LekeecJ+PcNiCLTPX
         ZcTafYgrEgC59QnMfCozRfFWaej31GL0105HOEN9E/Im7qpOGIUyrjvfz8Ab/xFdWt21
         h/u6EBj6kV5cckfO17s+KLO7WVdcDLCR3gR/A0RO90opF7hA14vn3U+t6D23L6WCowzv
         FVf3kcWzCpefvVFROp+s1znZUBfFhpKTUg3ZZmeU1J2mkjkkWz3LT6hLqpduChqEnZax
         4K1eW+HTlk0e0PC1f+jPVVSnVLEBdAWEzs+I8ylnJClH0GSC12M7zhJymaguMVEUVRPd
         yB2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=I2zaxNy7Koprks7U2CkvxZK+6R7/l1nRgPFPQ7Oc2Qk=;
        b=pvoBG37GcVOLL2HeuOiHnr4ukDh07MR1U1naKMnWhAy0aTCHHVBim2UGMa2AZJcLIv
         HqV3k3EJtxpLVTvBYHHNF2XuI4qhSG2DKjVZBAtV1eKWUvpGf3LXQxYxwkiWkjfMwfw0
         3B4i5f4wdhfGrqR7zSUOvkQrRhfuxzZrvgYc9+Oa177Vl5/cvpeF9mXUpjKXBXDPF7cr
         mQZZXPz0bmxeYiMCcCnRqicYBbLDvNJj4+DqYFCALqmLpYQig1H6Os9Oj3t/uu3CENrg
         zzs+fQ/CXEVkk+4sqoUK3tPKbVwS3IyRM2rX9wjpW4NLnJpnWfvmseJdzA5PNA8wuFjH
         TbHA==
X-Gm-Message-State: AOAM533ONW1JiDvPm1bd7HHG8NAcFZ+fsmfZ17EqvLIvK2tg4ltkoiD5
        jUhqY5CHblswjddXv8sftQGRjRPXpeJZif8=
X-Google-Smtp-Source: ABdhPJyUoLiXtbIlw5FaqSiqJplGsFEIurmcVCO9suomj847kRWqWlL8+uK6HDpQVI0njLBzC1D0tA==
X-Received: by 2002:a17:90a:3e4a:: with SMTP id t10mr1368239pjm.151.1604372143771;
        Mon, 02 Nov 2020 18:55:43 -0800 (PST)
Received: from localhost.localdomain ([47.242.155.38])
        by smtp.gmail.com with ESMTPSA id s23sm13401150pgl.47.2020.11.02.18.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 18:55:43 -0800 (PST)
From:   Pujin Shi <shipujin.t@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pujin Shi <shipujin.t@gmail.com>
Subject: [PATCH V2] net: ethernet: mscc: fix missing brace warning for old compilers
Date:   Tue,  3 Nov 2020 10:55:19 +0800
Message-Id: <20201103025519.1916-1-shipujin.t@gmail.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For older versions of gcc, the array = {0}; will cause warnings:

drivers/net/ethernet/mscc/ocelot_vcap.c: In function 'is1_entry_set':
drivers/net/ethernet/mscc/ocelot_vcap.c:755:11: warning: missing braces around initializer [-Wmissing-braces]
    struct ocelot_vcap_u16 etype = {0};
           ^
drivers/net/ethernet/mscc/ocelot_vcap.c:755:11: warning: (near initialization for 'etype.value') [-Wmissing-braces]

1 warnings generated

Fixes: 75944fda1dfe ("net: mscc: ocelot: offload ingress skbedit and vlan actions to VCAP IS1")
Signed-off-by: Pujin Shi <shipujin.t@gmail.com>
---
 drivers/net/ethernet/mscc/ocelot_vcap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index d8c778ee6f1b..b5167570521c 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -752,7 +752,7 @@ static void is1_entry_set(struct ocelot *ocelot, int ix,
 					     dport);
 		} else {
 			/* IPv4 "other" frame */
-			struct ocelot_vcap_u16 etype = {0};
+			struct ocelot_vcap_u16 etype = {{0}};
 
 			/* Overloaded field */
 			etype.value[0] = proto.value[0];
-- 
2.18.1

