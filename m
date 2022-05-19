Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 453D252DA77
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 18:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233747AbiESQkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 12:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242122AbiESQkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 12:40:02 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532A9DE318;
        Thu, 19 May 2022 09:40:01 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id j24so8021865wrb.1;
        Thu, 19 May 2022 09:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g94V+007bcGCjAyasUfYbZusStl21uCfYeR0vKeXVf0=;
        b=Hin01e1la6QOK00QfgmMbrXlXFaf2VdjroqEbWbljSiLZ/qJBOP17F6LoXPDizcJpZ
         nZpsxfXUSsogmY/6Ko4uMdE2PF1dv2OWvx/JdVqO18PV05vmaIOyhRBVBwoiUZQMCt7Z
         /iV+4wUIHNG65yq12SFY9yV6L0woB2stMcLfq+i85QHWqE8ImMOKw6ewUac//hleytOW
         +Whp4OemtZ8s6UIYz9CdMx9O7tueLWyHLuqJCXxSjRQAzHbcsUFXhou0IZfcr8LXXOyO
         rWW1aDrgjreerko2wsBokIIVKoQkO4qa9mai19ya98tQuoSke+bekMxZKdcOhLIEX0fZ
         0ReA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g94V+007bcGCjAyasUfYbZusStl21uCfYeR0vKeXVf0=;
        b=ttQ7IhMpVafSRN3gkNkKl8WD8CqigkX2OW3IYDQ+Cz/NGdtMPPW+GCFf4Yaf4crGXh
         MDlm9BfkgSV5x0bWnG4repSYUA7+fIc7BtggXLAFPR5CbfT9SbGOL0+qQ3UdlLGEHMbU
         rEZd6Jo3XDU2OemS78jtpY2Gy+9lEqQEgXC6KiCIT3XfXfcs7xtm4S21SIpvJ9GuH/xO
         em/XE5iyzhXWofNDao2qCLhh3Pe8YAHxQT6FFHT2LsgmNgDpbDe8Nht7RLBtiytcjnbO
         PhXYlXqn+eCOeMk67jxwFpACpZkSrkQd9l0l/TfhBt3upVBaa4/4uHCoVZclfVAs3hT9
         iZOA==
X-Gm-Message-State: AOAM531IZj/UjD4GAss/4BW5+hxtcJNtwmQJqhxnf2uwaJUk5xT74TcQ
        V3nkjBMSQz1PYQAPCMltyRS4yt5BXPE=
X-Google-Smtp-Source: ABdhPJzQB6LAwzzqPBlOe+HRAwwCoxmApZLwaN/+L8lDFNt/Clf6eLSVXo62V8B8ieF3j345piND/Q==
X-Received: by 2002:a5d:6701:0:b0:20c:dc44:f7e7 with SMTP id o1-20020a5d6701000000b0020cdc44f7e7mr4795391wru.484.1652978399576;
        Thu, 19 May 2022 09:39:59 -0700 (PDT)
Received: from localhost.localdomain ([41.232.195.220])
        by smtp.gmail.com with ESMTPSA id u6-20020adfc646000000b0020d0c48d135sm104873wrg.15.2022.05.19.09.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 09:39:59 -0700 (PDT)
From:   Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
To:     netdev@vger.kernel.org
Cc:     outreachy@lists.linux.dev, roopa@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, eng.alaamohamedsoliman.am@gmail.com
Subject: [PATCH net-next] net: vxlan: Fix kernel coding style
Date:   Thu, 19 May 2022 18:39:39 +0200
Message-Id: <20220519163939.10347-1-eng.alaamohamedsoliman.am@gmail.com>
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
 drivers/net/vxlan/vxlan_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 293082c32a78..fb7a09baeeb5 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1138,7 +1138,7 @@ static int vxlan_fdb_parse(struct nlattr *tb[], struct vxlan_dev *vxlan,
 	if (tb[NDA_NH_ID] && (tb[NDA_DST] || tb[NDA_VNI] || tb[NDA_IFINDEX] ||
 	    tb[NDA_PORT])) {
 			NL_SET_ERR_MSG(extack,
-						  "DST, VNI, ifindex and port are mutually exclusive with NH_ID");
+				       "DST, VNI, ifindex and port are mutually exclusive with NH_ID");
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

