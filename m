Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D81C02974A1
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 18:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752307AbgJWQiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 12:38:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751822AbgJWQds (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 12:33:48 -0400
Received: from mail.kernel.org (ip5f5ad5a3.dynamic.kabel-deutschland.de [95.90.213.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9599A24687;
        Fri, 23 Oct 2020 16:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603470827;
        bh=gJmp8cTYgH9MZLys45Ah0xGqa1fV26E8JRNpZkLrsiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MhMmMVS5CJYbiKztHHUURNljwpTUMbkH8LBuDEPfp1Vt1uku1HlNTj/ysswk3cpCp
         W+yFL3Pk/Ud3BjmUwFrQaQfeL+XB3ewA5dhHIXtgDpQyQDgkjPb7cSzQzEAoELt+Em
         b3Uz+w74LdYoinZlvf1XiqCZGG1psnFMTVi3VJQ4=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kW00f-002AwB-Gw; Fri, 23 Oct 2020 18:33:45 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v3 20/56] net: core: fix some kernel-doc markups
Date:   Fri, 23 Oct 2020 18:33:07 +0200
Message-Id: <492b5ee3aca655ffad6e95e61d9b4019e69b8e3a.1603469755.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1603469755.git.mchehab+huawei@kernel.org>
References: <cover.1603469755.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some identifiers have different names between their prototypes
and the kernel-doc markup.

In the specific case of netif_subqueue_stopped(), keep the
current markup for __netif_subqueue_stopped(), adding a
new one for netif_subqueue_stopped().

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 include/linux/netdevice.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 964b494b0e8d..db79ab7580dd 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1490,7 +1490,7 @@ struct net_device_ops {
 };
 
 /**
- * enum net_device_priv_flags - &struct net_device priv_flags
+ * enum netdev_priv_flags - &struct net_device priv_flags
  *
  * These are the &struct net_device, they are only set internally
  * by drivers and used in the kernel. These flags are invisible to
@@ -3576,7 +3576,7 @@ static inline void netif_stop_subqueue(struct net_device *dev, u16 queue_index)
 }
 
 /**
- *	netif_subqueue_stopped - test status of subqueue
+ *	__netif_subqueue_stopped - test status of subqueue
  *	@dev: network device
  *	@queue_index: sub queue index
  *
@@ -3590,6 +3590,13 @@ static inline bool __netif_subqueue_stopped(const struct net_device *dev,
 	return netif_tx_queue_stopped(txq);
 }
 
+/**
+ *	netif_subqueue_stopped - test status of subqueue
+ *	@dev: network device
+ *	@skb: sub queue buffer pointer
+ *
+ * Check individual transmit queue of a device with multiple transmit queues.
+ */
 static inline bool netif_subqueue_stopped(const struct net_device *dev,
 					  struct sk_buff *skb)
 {
-- 
2.26.2

