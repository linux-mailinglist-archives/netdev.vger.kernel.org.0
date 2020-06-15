Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D251F8E77
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 08:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbgFOGts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 02:49:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:59508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728377AbgFOGrM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 02:47:12 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 851EA20714;
        Mon, 15 Jun 2020 06:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592203631;
        bh=jDK8Uor/fpsM4yRLViMTy1agyY9cCKKRqBG5oq5+LdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehi9sGzurgw4E5tM1yCbZZ6Zrh2qjYe3cN4GPWYJQVmfsn0qBTQknmOP5zrQP8Npy
         YPy/JskY05TESk1Z4o56NlFLUDoS1vEz0kB6ZVLCFyFeDcFRtA0c/PmA40BkGCMXq6
         UxcTQ0TcO9VF9jBxFx7QunCONF5EdDtoygZFfANE=
Received: from mchehab by mail.kernel.org with local (Exim 4.93)
        (envelope-from <mchehab@kernel.org>)
        id 1jkith-009nm8-Es; Mon, 15 Jun 2020 08:47:09 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Subject: [PATCH 03/29] net: netdevice.h: add a description for napi_defer_hard_irqs
Date:   Mon, 15 Jun 2020 08:46:42 +0200
Message-Id: <78501c720579094a0dd744e64915650bb9698438.1592203542.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1592203542.git.mchehab+huawei@kernel.org>
References: <cover.1592203542.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changeset 6f8b12d661d0 ("net: napi: add hard irqs deferral feature")
added a new element at struct net_device.

Add a description for it, based on what's described at the changeset
which added such feature.

Fixes: 6f8b12d661d0 ("net: napi: add hard irqs deferral feature")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 include/linux/netdevice.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 6fc613ed8eae..f3ca52958a17 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1742,6 +1742,8 @@ enum netdev_priv_flags {
  *	@real_num_rx_queues: 	Number of RX queues currently active in device
  *	@xdp_prog:		XDP sockets filter program pointer
  *	@gro_flush_timeout:	timeout for GRO layer in NAPI
+ *	@napi_defer_hard_irqs:	If not zero, provides a counter that would
+ *				allow to avoid NIC hard IRQ, on busy queues.
  *
  *	@rx_handler:		handler for received packets
  *	@rx_handler_data: 	XXX: need comments on this one
-- 
2.26.2

