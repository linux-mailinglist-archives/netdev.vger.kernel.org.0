Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27F0052E123
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 02:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343976AbiETAYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 20:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233295AbiETAYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 20:24:47 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D9712B035;
        Thu, 19 May 2022 17:24:46 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id bg25so3742777wmb.4;
        Thu, 19 May 2022 17:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=20g10QH4u/3O0tBO6ofFWhrt9ZuFgao8sbSN8hXJynU=;
        b=Ix8txj7HZlP4pkKpnQkD6w/Ta1NjrUF+EUPO63qCu66VvykKqidQ+QN11qF859RgYL
         fNqTkU9R7jfPlESSITpDg0smh8qtd3SQ2h/SheuaK6C70G/7GdZKnTPmD+I2mOas8DJ+
         MVd7P4obQ46T8ScO3wq/EkjkFUnNdACtdv8HTzmMf6aYuWJ4/t0DVcEduC2xxcmiV57Z
         rMpIUYeNw+G2azEYBdpdZc0oCFUGIeHLR2C8eJvxWr4mW95z0dL0SATB8bKBl+oBo9DP
         j87MUBR0bEXQhXeejUOjrkdLHAa4IzAwXkKs+S/zhx/DOhz+g22YfVXbNbTyIThUDhmk
         dNpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=20g10QH4u/3O0tBO6ofFWhrt9ZuFgao8sbSN8hXJynU=;
        b=DSENuGHojYqCfbZ6TIrQKXqGp3E9smbYHPbkg1Q0K2iY81sYckAckOHlD70C8YFd27
         0PQYLZSbsBY/P+u/55UqsjQwGsdxoBtQymhDCD6VGRodUww58FMi/OsqD1r0yaXR2bwJ
         PIagQMLAcoz6YbOjerWrDn1xzlzWzAPCs92p3fur+3dMcrwI3QdgizWzyjZRfcdlSPJF
         dMiIl7YNBQNli/J1YtLYhi86Uj04qDqw108/p8Mdmhjter/5N/LK2aR0LMU9WbCuelid
         wzZStrqiDXBGSvrUFnp41sYA4w1LgNSVDRjkWhKNlhu8aZbw4pIoPNsn/5TxcW6h6iDP
         +DGg==
X-Gm-Message-State: AOAM53354B9Cb5fjIj7bdTmtDB5iC53EEAsZLcvLU418W3Ost1vjHC0v
        BZWFTxLDPyDn4tavSCi7vwnhuU27QEw=
X-Google-Smtp-Source: ABdhPJzkvNd/2XdRASC6d9kdRATZKM9PWZpd59l/dbVxfTOEt/PIabimum+RKJ1jFLlhKcqF16LNJg==
X-Received: by 2002:a05:600c:190b:b0:394:880f:ae2c with SMTP id j11-20020a05600c190b00b00394880fae2cmr5766016wmq.79.1653006284951;
        Thu, 19 May 2022 17:24:44 -0700 (PDT)
Received: from localhost.localdomain ([41.232.195.220])
        by smtp.gmail.com with ESMTPSA id z6-20020a7bc146000000b003942a244ebesm778951wmi.3.2022.05.19.17.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 17:24:44 -0700 (PDT)
From:   Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
To:     netdev@vger.kernel.org
Cc:     outreachy@lists.linux.dev, roopa@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, eng.alaamohamedsoliman.am@gmail.com
Subject: [PATCH net-next v2] net: vxlan: Fix kernel coding style
Date:   Fri, 20 May 2022 02:24:32 +0200
Message-Id: <20220520002432.4740-1-eng.alaamohamedsoliman.am@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The continuation line does not align with the opening bracket
and this patch fix it.

Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
---
changes in v2:
	fix the alignment of the "DST, VNI, ifindex and port are mutually exclusive with NH_ID"
  string to the open parenthesis of the NL_SET_ERR_MSG macro in vxlan_fdb_parse().
---
 drivers/net/vxlan/vxlan_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 293082c32a78..29db08f15e38 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1138,7 +1138,7 @@ static int vxlan_fdb_parse(struct nlattr *tb[], struct vxlan_dev *vxlan,
 	if (tb[NDA_NH_ID] && (tb[NDA_DST] || tb[NDA_VNI] || tb[NDA_IFINDEX] ||
 	    tb[NDA_PORT])) {
 			NL_SET_ERR_MSG(extack,
-						  "DST, VNI, ifindex and port are mutually exclusive with NH_ID");
+					"DST, VNI, ifindex and port are mutually exclusive with NH_ID");
 			return -EINVAL;
 		}
 
@@ -1297,7 +1297,7 @@ int __vxlan_fdb_delete(struct vxlan_dev *vxlan,
 static int vxlan_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
 			    struct net_device *dev,
 			    const unsigned char *addr, u16 vid,
-				struct netlink_ext_ack *extack)
+			    struct netlink_ext_ack *extack)
 {
 	struct vxlan_dev *vxlan = netdev_priv(dev);
 	union vxlan_addr ip;
-- 
2.25.1

