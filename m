Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53F2D57C6E3
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 10:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbiGUIxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 04:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232653AbiGUIxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 04:53:21 -0400
Received: from smtp236.sjtu.edu.cn (smtp236.sjtu.edu.cn [202.120.2.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80CC7FE4F;
        Thu, 21 Jul 2022 01:53:20 -0700 (PDT)
Received: from proxy02.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
        by smtp236.sjtu.edu.cn (Postfix) with ESMTPS id 5DFA21008B392;
        Thu, 21 Jul 2022 16:44:22 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by proxy02.sjtu.edu.cn (Postfix) with ESMTP id 376B32007EB67;
        Thu, 21 Jul 2022 16:44:22 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from proxy02.sjtu.edu.cn ([127.0.0.1])
        by localhost (proxy02.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id n2EMzlF6ilrD; Thu, 21 Jul 2022 16:44:22 +0800 (CST)
Received: from localhost.localdomain (unknown [202.120.40.82])
        (Authenticated sender: qtxuning1999@sjtu.edu.cn)
        by proxy02.sjtu.edu.cn (Postfix) with ESMTPSA id E37C22008B6BB;
        Thu, 21 Jul 2022 16:44:10 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     eperezma@redhat.com, jasowang@redhat.com, sgarzare@redhat.com,
        mst@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Guo Zhi <qtxuning1999@sjtu.edu.cn>
Subject: [RFC 2/5] vhost: announce VIRTIO_F_IN_ORDER support
Date:   Thu, 21 Jul 2022 16:43:38 +0800
Message-Id: <20220721084341.24183-3-qtxuning1999@sjtu.edu.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220721084341.24183-1-qtxuning1999@sjtu.edu.cn>
References: <20220721084341.24183-1-qtxuning1999@sjtu.edu.cn>
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,RCVD_IN_SORBS_WEB,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order feature is supported by default in vhost.

Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
---
 drivers/vhost/vhost.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 7b2c0fbb5..b425c8f50 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -241,6 +241,7 @@ enum {
 			 (1ULL << VIRTIO_RING_F_EVENT_IDX) |
 			 (1ULL << VHOST_F_LOG_ALL) |
 			 (1ULL << VIRTIO_F_ANY_LAYOUT) |
+			 (1ULL << VIRTIO_F_IN_ORDER) |
 			 (1ULL << VIRTIO_F_VERSION_1)
 };
 
-- 
2.17.1

