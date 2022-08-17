Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5E41597078
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 16:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239928AbiHQN7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 09:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239536AbiHQN6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 09:58:45 -0400
Received: from smtp236.sjtu.edu.cn (smtp236.sjtu.edu.cn [202.120.2.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F126A75CDC;
        Wed, 17 Aug 2022 06:58:33 -0700 (PDT)
Received: from proxy02.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
        by smtp236.sjtu.edu.cn (Postfix) with ESMTPS id 8BD1F1008B392;
        Wed, 17 Aug 2022 21:58:29 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by proxy02.sjtu.edu.cn (Postfix) with ESMTP id 602EB2009BEA0;
        Wed, 17 Aug 2022 21:58:24 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from proxy02.sjtu.edu.cn ([127.0.0.1])
        by localhost (proxy02.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id M2sepWPQLjQx; Wed, 17 Aug 2022 21:58:24 +0800 (CST)
Received: from localhost.localdomain (unknown [202.120.40.82])
        (Authenticated sender: qtxuning1999@sjtu.edu.cn)
        by proxy02.sjtu.edu.cn (Postfix) with ESMTPSA id C0A792009BEB4;
        Wed, 17 Aug 2022 21:58:10 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     eperezma@redhat.com, jasowang@redhat.com, sgarzare@redhat.com,
        mst@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Guo Zhi <qtxuning1999@sjtu.edu.cn>
Subject: [RFC v2 4/7] vsock: announce VIRTIO_F_IN_ORDER in vsock
Date:   Wed, 17 Aug 2022 21:57:15 +0800
Message-Id: <20220817135718.2553-5-qtxuning1999@sjtu.edu.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220817135718.2553-1-qtxuning1999@sjtu.edu.cn>
References: <20220817135718.2553-1-qtxuning1999@sjtu.edu.cn>
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,RCVD_IN_SORBS_WEB,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order feature is used by vsock now, since vsock already use buffer in
order.

Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
---
 drivers/vhost/vsock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index b0108009c39a..3dd3a2a27d27 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -32,6 +32,7 @@
 enum {
 	VHOST_VSOCK_FEATURES = VHOST_FEATURES |
 			       (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
+			       (1ULL << VIRTIO_F_IN_ORDER) |
 			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET)
 };
 
-- 
2.17.1

