Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3160751FDE3
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 15:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235453AbiEINVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 09:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235411AbiEINUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 09:20:50 -0400
X-Greylist: delayed 183 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 09 May 2022 06:16:52 PDT
Received: from cmccmta1.chinamobile.com (cmccmta1.chinamobile.com [221.176.66.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F31BE21607E;
        Mon,  9 May 2022 06:16:52 -0700 (PDT)
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from spf.mail.chinamobile.com (unknown[172.16.121.7])
        by rmmx-syy-dmz-app02-12002 (RichMail) with SMTP id 2ee262791389588-0e0d4;
        Mon, 09 May 2022 21:13:46 +0800 (CST)
X-RM-TRANSID: 2ee262791389588-0e0d4
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[112.0.145.115])
        by rmsmtp-syy-appsvr04-12004 (RichMail) with SMTP id 2ee462791387782-51810;
        Mon, 09 May 2022 21:13:46 +0800 (CST)
X-RM-TRANSID: 2ee462791387782-51810
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>
Subject: [PATCH] virtio_net: Remove unused case in virtio_skb_set_hash()
Date:   Mon,  9 May 2022 21:14:32 +0800
Message-Id: <20220509131432.16568-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In this function, "VIRTIO_NET_HASH_REPORT_NONE" is included
in "default", so it canbe removed.

Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
---
 drivers/net/virtio_net.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 87838cbe3..b3e5d8637 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1172,7 +1172,6 @@ static void virtio_skb_set_hash(const struct virtio_net_hdr_v1_hash *hdr_hash,
 	case VIRTIO_NET_HASH_REPORT_IPv6_EX:
 		rss_hash_type = PKT_HASH_TYPE_L3;
 		break;
-	case VIRTIO_NET_HASH_REPORT_NONE:
 	default:
 		rss_hash_type = PKT_HASH_TYPE_NONE;
 	}
-- 
2.20.1.windows.1



