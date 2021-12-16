Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE350476D1F
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 10:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbhLPJNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 04:13:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232823AbhLPJNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 04:13:47 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE22C061574;
        Thu, 16 Dec 2021 01:13:47 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id p4so22726254qkm.7;
        Thu, 16 Dec 2021 01:13:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q/hhF4jTsVszJcCW+fmTHlINRGm/jEfgDRWafE6Yat4=;
        b=Zc0oy+sBIn17gWBaiDDzJW/eHMwT6978QgdYxBmlhcdF21FeE1ll9Md205Ipoeonqm
         ex0Qom9ur//byowuhgL1Q0RA85KSRPbB1U4wCQI4BVGXUjRGUin22lvgSNVNpffkGLaB
         sbHTF6YcDRj9p9DXjnhGCOWwRdfRZ/Uw7tldyU2hq48Xr2lg6ApwswTVOZGW9ywAcltC
         sRVklwolp0quqV7LYgrM2wW45hgc87C5IwkPJb8D/zbTUaFtm7fFTvLOQydQNif11HzN
         M7hD4Vx4KGQJOYVW+lh/A6DtMaIFX4xqo9UfpvnG99xk3OG6et15r8CAo3PqYd6qNu+i
         0LYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q/hhF4jTsVszJcCW+fmTHlINRGm/jEfgDRWafE6Yat4=;
        b=kWxXqmJhhOnwItQkDa+iezbbckbip1L8IAZwPp6FjZxcCBcz16n/TNizh4hVHUDoRd
         XYm7dwNVBHV0Bnj2TXWK5gwDJwTV3uNkHArdSuZUyJJyNjaAu+cOlj6dVUFXhr+uAT5C
         DcqrGPQpYFnulOYMhxXgyEWJE9YPH9cR44y3kMa/UYrdCvQXvnW8sRGInVOTrlXqysLp
         1VFKsD3VwL0WXr7riPrQMPBYNnZ37ZWUv5gLz9EkgXf75vnKSX0sUMSNRGrRAcIdvDPe
         tp7iUhkkojwe5U6lttFC/AFOQatZdYG/q1Cpn9cINS74BWeEIhnygWJ51RXlUTQaorJE
         kFCg==
X-Gm-Message-State: AOAM531r/FQXCjv4Lu/cdnJ5M9GPBlrvItwu4pvOUiWu/UZuT+UkmuO4
        qeYRfKal5YKJ5uTmmyofOQM=
X-Google-Smtp-Source: ABdhPJzZhk3mpSCMhK1TdH7jJBfBy0i7hNKQehTOkxhuBCUHQh7YQVGG17oVpW0Ewi82MiAIlkTbWQ==
X-Received: by 2002:a05:620a:2942:: with SMTP id n2mr11334275qkp.608.1639646026338;
        Thu, 16 Dec 2021 01:13:46 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id u11sm3852694qtw.29.2021.12.16.01.13.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 01:13:45 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: deng.changcheng@zte.com.cn
To:     woojung.huh@microchip.com
Cc:     UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net: dsa: microchip: remove unneeded variable
Date:   Thu, 16 Dec 2021 09:13:39 +0000
Message-Id: <20211216091339.449609-1-deng.changcheng@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Changcheng Deng <deng.changcheng@zte.com.cn>

Remove unneeded variable used to store return value.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
---
 drivers/net/dsa/microchip/ksz_common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 47a856533cff..55dbda04ea62 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -302,7 +302,6 @@ int ksz_port_mdb_del(struct dsa_switch *ds, int port,
 	struct ksz_device *dev = ds->priv;
 	struct alu_struct alu;
 	int index;
-	int ret = 0;
 
 	for (index = 0; index < dev->num_statics; index++) {
 		if (!dev->dev_ops->r_sta_mac_table(dev, index, &alu)) {
@@ -324,7 +323,7 @@ int ksz_port_mdb_del(struct dsa_switch *ds, int port,
 	dev->dev_ops->w_sta_mac_table(dev, index, &alu);
 
 exit:
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(ksz_port_mdb_del);
 
-- 
2.25.1

