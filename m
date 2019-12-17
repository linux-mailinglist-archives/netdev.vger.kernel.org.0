Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84E5A12223F
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 03:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfLQCwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 21:52:55 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44936 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727089AbfLQCwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 21:52:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Date:Message-ID:Subject:From:To:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=fxJjfXqU1Z/O0cmSyFLAanH8oMDyYqJQgFk8nTaHzuU=; b=jWMbl7mouzUpENKMLOqU4f55l
        guCgX3M0yFNP0NbLoxdnJOFdY+rwDFf31T/PZMzEeeGZWv9W6uec1l7XiZi7My9npZW7rmmXiikJn
        ToeP0s5tdMOZrBEzgYcgDHaaFlqsJyaRxJtIvvEq14bF9jeJF3QGmnQrJqNYjZFDA8f0gyeiRZHCV
        NN5MkDz73Vbb7rEXzf/pq+PE7rzg1v9hVtxBLOXTx9jpbMVd3O+6dyaIXPo4uh2MJakjZbb1uxGdl
        enu7k9EXrsJuYv9lKrALxJZwgMGUP3YwJN3MFGiOQl638yWCnm2p+n6ucfazhQO+7Ddz/0wJTKAio
        0tNKM3kEQ==;
Received: from [2601:1c0:6280:3f0::fee9]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ih2yj-0003ve-8I; Tue, 17 Dec 2019 02:52:53 +0000
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Taehee Yoo <ap420073@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] net: fix kernel-doc warning in <linux/netdevice.h>
Message-ID: <c576bade-11b1-8962-2330-c7ea72088b18@infradead.org>
Date:   Mon, 16 Dec 2019 18:52:45 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix missing '*' kernel-doc notation that causes this warning:

../include/linux/netdevice.h:1779: warning: bad line:                                 spinlock

Fixes: ab92d68fc22f ("net: core: add generic lockdep keys")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Taehee Yoo <ap420073@gmail.com>
---
 include/linux/netdevice.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-55-rc2.orig/include/linux/netdevice.h
+++ lnx-55-rc2/include/linux/netdevice.h
@@ -1775,7 +1775,7 @@ enum netdev_priv_flags {
  *			for hardware timestamping
  *	@sfp_bus:	attached &struct sfp_bus structure.
  *	@qdisc_tx_busylock_key: lockdep class annotating Qdisc->busylock
-				spinlock
+ *				spinlock
  *	@qdisc_running_key:	lockdep class annotating Qdisc->running seqcount
  *	@qdisc_xmit_lock_key:	lockdep class annotating
  *				netdev_queue->_xmit_lock spinlock

