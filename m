Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87A3B52E13A
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 02:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344031AbiETAgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 20:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232460AbiETAg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 20:36:29 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 356065DA12;
        Thu, 19 May 2022 17:36:28 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id u3so9432399wrg.3;
        Thu, 19 May 2022 17:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=20g10QH4u/3O0tBO6ofFWhrt9ZuFgao8sbSN8hXJynU=;
        b=Xs2tZvkUhGUidDE1n3SJS4u3GAqDBT0pD0YTr8+WjofwhZJ4LAUgEKbSeM9DjnkZyW
         aw6Pxr9T2SQ/qrxMF1Vb/iamHZ2FC8ppfRw9z85una19facSffA3O0KjsNZQFxS9vkJU
         Y4iNUbpxojolrC3BN+9xXZ2bDr1ul1hEKKydP42C/AR7NZsdpl3nauU+Z2tUqWYmLKg0
         SLzR0Xfb7YvfAaTyirgmoCuz4i7arJnv5Gt/bUayLfCpPSd9I5hw5/SHls6cPE5GR1qd
         Y9Rmy1tIzqb8EOlOmhM9LPIPfsBuJSUsqWM3PnwinzYV5jKLm8xy7PKY3LYoOMCFFc7G
         0ROA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=20g10QH4u/3O0tBO6ofFWhrt9ZuFgao8sbSN8hXJynU=;
        b=xQymGrSLhfJTTSy8g7cyPbWZL9300HdBCSR3Bukkr8GcF1vsNe7dv+w8RoIjPg9lci
         JqPWUPtIRriPYVryQpHKx43M+asS9JvmMXWfXxzrxr2I/4Dh2wawXq9zdrYuj+SYKCWm
         M825wM+c90onste/SLM+pIjGLIGRHsq5RAsLw9CTJDS7kzikAjpAxhSjU0bMc4xtC/XC
         zNH5JHTmHZxdROlqoY69WX7YeSpsxgLWd/YWErMwIbHNet95pPDOb2Eqy4ulyZjNdl5m
         gt38lgIaSxhX985OT3uq/KHlDxwl9ijW3qSB6e20wcydiaWr0CQrWnoI7H6M7we3lyx9
         k50g==
X-Gm-Message-State: AOAM533vxD05mHALrS9qhg0Sq9OE3fl2CubmyS0VA0ld8JONkE/r0Mxo
        Dsc6DiuYqrTDdVbBm2zU5ptN2yZbgvc=
X-Google-Smtp-Source: ABdhPJwKTnUkWXcKClggkLAd997j0lZE2h8MSJkc5Y+J0faRwVERo3wUnSrffxMBZ4Al4GCagUN1KQ==
X-Received: by 2002:a05:6000:1acd:b0:20c:7201:9267 with SMTP id i13-20020a0560001acd00b0020c72019267mr6073089wry.41.1653006986589;
        Thu, 19 May 2022 17:36:26 -0700 (PDT)
Received: from localhost.localdomain ([41.232.195.220])
        by smtp.gmail.com with ESMTPSA id bh9-20020a05600c3d0900b0039444973258sm951063wmb.0.2022.05.19.17.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 17:36:26 -0700 (PDT)
From:   Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
To:     netdev@vger.kernel.org
Cc:     outreachy@lists.linux.dev, roopa@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, eng.alaamohamedsoliman.am@gmail.com
Subject: [PATCH net-next v2] net: vxlan: Fix kernel coding style
Date:   Fri, 20 May 2022 02:36:14 +0200
Message-Id: <20220520003614.6073-1-eng.alaamohamedsoliman.am@gmail.com>
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

