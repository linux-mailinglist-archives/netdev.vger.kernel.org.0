Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE76204A8F
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 09:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731346AbgFWHJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 03:09:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:39774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730957AbgFWHJP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 03:09:15 -0400
Received: from mail.kernel.org (unknown [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DAF320771;
        Tue, 23 Jun 2020 07:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592896155;
        bh=0UtiECJ6/lhRz1NT5gRsAalsNQvZKA/yaIYlTTswtgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sWwuSQKFqsxJfl4gMJqTNWFdZ2zuVmlIMsRpyi6XUKK2Cvf5tITTfElx4fYwHoy1P
         7wR2G0zLNy+7FHEJrxSyihG4lVORiVlNCiqGzTOLvCy6VX/L1EHhlL806IX6r5T7NR
         tT6L+YL4uAcD6pWrOPJRq6aLL7sJiXjsgXmby8Ic=
Received: from mchehab by mail.kernel.org with local (Exim 4.93)
        (envelope-from <mchehab@kernel.org>)
        id 1jnd3R-003qiq-1N; Tue, 23 Jun 2020 09:09:13 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Subject: [PATCH v2 03/15] net: netdevice.h: add a description for napi_defer_hard_irqs
Date:   Tue, 23 Jun 2020 09:08:59 +0200
Message-Id: <807a3840e7bc1562adefadb0535c9f47e6ab52e0.1592895969.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1592895969.git.mchehab+huawei@kernel.org>
References: <cover.1592895969.git.mchehab+huawei@kernel.org>
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
index 39e28e11863c..027df84f0f59 100644
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

