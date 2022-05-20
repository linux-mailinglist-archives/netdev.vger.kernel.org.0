Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51F8D52E103
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 02:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239332AbiETAOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 20:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233411AbiETAOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 20:14:40 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1E732EED;
        Thu, 19 May 2022 17:14:39 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 67-20020a1c1946000000b00397382b44f4so347755wmz.2;
        Thu, 19 May 2022 17:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=20g10QH4u/3O0tBO6ofFWhrt9ZuFgao8sbSN8hXJynU=;
        b=fSzaKDSuxGbJn3oZ4Dcgv0dfPaVgY9xf5z/dOJ3Q5t6vVm2jdVoYG+t+44lASq8NV0
         tuVkPZx0nnnGMLuq2A5YprVvmQRNqBsjlkSZ3G+CnpRMZiDxaYGPxRUmXXrJeZdn7PsA
         ESF+Emm21o38av3mUTFVEB4ExGGmEq5rbmG1UfFjfzmgHpGkWc8Bd7ehdhXQ1THt/uF4
         yQkuQjx/R2jFPehno5Dn4osbKk2mF/9ZHAVaxhDpuVu2mymrc0shN4WsSq6pNKINXPC3
         lVwZL2Rt9mpQwT8Ui9aldv1thEwsCkEzL8b6W/pHBbrmVl7vSuTN1y/uLv+8xlnAidE5
         iThw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=20g10QH4u/3O0tBO6ofFWhrt9ZuFgao8sbSN8hXJynU=;
        b=jMb3eGzcqBbFgvSw/+0ZYsRVXy2mOzKJ48Xg/rPki76ISBC5x2wkOOIBYNKgxzYUPH
         DaQkVrNtN9/sCD5WFgnAO2JtrG0eYesxZeW9BcewLw9yz9d21q7eG+K7TTqsJUa3nYpO
         hKLwei4D9zoUlv+mJLfVcwcDuzZamkb3jNE+T1Mg0NubYoMWGfEMNRKc6QFQLDSZJlbj
         oibz2wqqroErfa4Er3eTue3fPQMVM7sswLMyi7pCCJVf18IBa1fwWwlYOGRKNv2/8uZf
         BG45xfACw9VZgPXEe5h/uoQCOoFFzlV63y72W9zLp6nQHta/4+ao/kRxfr8yvi2BShyz
         AQMQ==
X-Gm-Message-State: AOAM5308B7GzYbTylzljh8qcu8enZMdOXtXnsKXcKWHJwb/RXPdZRNR2
        h6Yl4iE8h1nA6NG6Jn5Qbzl/bRzPPVQ=
X-Google-Smtp-Source: ABdhPJzUXnkFWi9Di8i8FqYL8i+jJ3zn/03w+hUEibCPfQt4uKi6wYhIhvw4K8d4+QYrU19Dgw2IQQ==
X-Received: by 2002:a05:600c:5105:b0:394:7d22:aa93 with SMTP id o5-20020a05600c510500b003947d22aa93mr5877560wms.107.1653005678095;
        Thu, 19 May 2022 17:14:38 -0700 (PDT)
Received: from localhost.localdomain ([41.232.195.220])
        by smtp.gmail.com with ESMTPSA id b9-20020a05600c150900b003942a244ed2sm818111wmg.23.2022.05.19.17.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 17:14:37 -0700 (PDT)
From:   Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
To:     netdev@vger.kernel.org
Cc:     outreachy@lists.linux.dev, roopa@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, eng.alaamohamedsoliman.am@gmail.com
Subject: [PATCH net-next v2] net: vxlan: Fix kernel coding style
Date:   Fri, 20 May 2022 02:14:33 +0200
Message-Id: <20220520001433.4140-1-eng.alaamohamedsoliman.am@gmail.com>
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

