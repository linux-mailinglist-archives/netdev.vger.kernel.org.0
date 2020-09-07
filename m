Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C27625F213
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 05:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgIGDba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 23:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgIGDb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Sep 2020 23:31:29 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6958CC061573
        for <netdev@vger.kernel.org>; Sun,  6 Sep 2020 20:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Date:Message-ID:Subject:From:To:Sender:Reply-To:Cc:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=kX9Y4JYaAio7bD6ypVCLmUddeyZOKGkT8qqgWnqbOrM=; b=NELhr7jRzg88+BYYv06qDW6Mxu
        etOxemFy+9XMszeAzcGir/o19vrhEtVFjtDrBxufvq86Sk5fm2UixLw5kxIFldNGe5iHZlsxoNhwR
        cF189dFD2PwhNqE/szGyjTYvaaFAZVDZVwNSO6XNK3m2u5wjb9cF19hf9GS1fy9z2X6exsl4fqToi
        4nvGWFVZv4SsYg54i7WmHOhzvB7SUQiKaki2yN4zynORv/dyhcBMDLeSVA8Cz3vV1haw9szx684+D
        cex9THIhqlze/WaWR0/w8JhJXk/skPZeDbJrQnI/RBPOfinLAAgTvHLX6LyEmmYIptwvtBzQtEZXQ
        q8TgizAg==;
Received: from [2601:1c0:6280:3f0::19c2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kF7sH-0005e0-Ij; Mon, 07 Sep 2020 03:31:21 +0000
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jakub Kicinski <kuba@kernel.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH net] netdevice.h: fix proto_down_reason kernel-doc warning
Message-ID: <7275c711-b313-b78c-bea5-e836f323b0ef@infradead.org>
Date:   Sun, 6 Sep 2020 20:31:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix kernel-doc warning in <linux/netdevice.h>:

../include/linux/netdevice.h:2158: warning: Function parameter or member 'proto_down_reason' not described in 'net_device'

Fixes: 829eb208e80d ("rtnetlink: add support for protodown reason")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 include/linux/netdevice.h |    1 +
 1 file changed, 1 insertion(+)

--- lnx-59-rc4.orig/include/linux/netdevice.h
+++ lnx-59-rc4/include/linux/netdevice.h
@@ -1784,6 +1784,7 @@ enum netdev_priv_flags {
  *				the watchdog (see dev_watchdog())
  *	@watchdog_timer:	List of timers
  *
+ * 	@proto_down_reason:	reason a netdev interface is held down
  *	@pcpu_refcnt:		Number of references to this device
  *	@todo_list:		Delayed register/unregister
  *	@link_watch_list:	XXX: need comments on this one

