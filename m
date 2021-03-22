Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBBF3440CF
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 13:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhCVMW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 08:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbhCVMWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 08:22:09 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57A0C061574;
        Mon, 22 Mar 2021 05:22:08 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id x16so8479397qvk.3;
        Mon, 22 Mar 2021 05:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XsQnydc2awVFJv3Ue+BxKT29h1h7Ehp3w+k1yfrJoCY=;
        b=fN9TNJ2ZJrt4INDTiAMOlivZaN1qvkjRzaRQ46j7u3EN2iNfQL9G7R/JNkWZafzvPZ
         PKoa98tmM3GY1o36OI3hwID55h9fz3BKfeJ/rCbBMUNP+I8DWRsfzFdpJM7n90vVxv79
         De+Zc0HeBmKVF+Mnaj7HBrkATJzC7Ms/OGrxjEIUHvsYyXQAAxWW6lINNe94GzzEJUsi
         E7BJkNV32LaalAkk5YEw3BFFhYObBoIFc6zW1WKKDi4VrekX9Zh/jkN7QVTmRd4O5+Oo
         BtazMrgc89b40Bzv8GW1QdJ3llOqNK389r3Fk6uJMP1cHYMe8co11p2Dbko4pVqQqZzM
         RWNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XsQnydc2awVFJv3Ue+BxKT29h1h7Ehp3w+k1yfrJoCY=;
        b=H+OBQHa33YzXUgOrSx4F9AuRLcanichSDYe3189/73SpLCtuyvhME5O0lnHWPDIBgC
         oO7vA0N75y93QDSPwDVvEzZm7rhD/HrhjMlSOfq0jE8se0WHpuJ8RrTXcNeOl2MhYBUH
         wS/kYh+3QC9aBiuU85QztLBLeETYw2QjSZTunAUdDRYQ+3eS61pOYl43iqXcPVsdIxtp
         9kcu7dJNVgWFMYsZW1CIZIpg0ZCJlsxDrt4LN6mg6eqbNQKfPQmFvuFkUL1pzF0ZhdyD
         +jwZP69ti1xfF9I4/oq6JfrRBFtqpaQKeyaqZDq5uSna3+0IEyvB6sDCrfkEAeEz+S1x
         pSzw==
X-Gm-Message-State: AOAM531NEaCgmpcRfXznK21388kHAgUCCTK2nLCdkyQavbRGJN5CAodJ
        VUKFShYm1uysc3APixeibdc=
X-Google-Smtp-Source: ABdhPJyOIhIjYOowrtO2ct8mIs8i5mTdMXXhZYw13jbxDMLwFS5JkPigWGUCv6ylF304Q8NPTaRL7Q==
X-Received: by 2002:a05:6214:932:: with SMTP id dk18mr20866863qvb.10.1616415727986;
        Mon, 22 Mar 2021 05:22:07 -0700 (PDT)
Received: from localhost.localdomain ([143.244.44.200])
        by smtp.gmail.com with ESMTPSA id q24sm10451005qki.120.2021.03.22.05.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 05:22:07 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, tparkin@katalix.com,
        mschiffer@universe-factory.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] net: l2tp: Fix a typo
Date:   Mon, 22 Mar 2021 17:51:55 +0530
Message-Id: <20210322122155.2420640-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/verifed/verified/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/l2tp/l2tp_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 203890e378cb..2ee20743cb41 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -802,7 +802,7 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tunnel, struct sk_buff *skb)
 	u16 version;
 	int length;

-	/* UDP has verifed checksum */
+	/* UDP has verified checksum */

 	/* UDP always verifies the packet length. */
 	__skb_pull(skb, sizeof(struct udphdr));
--
2.31.0

