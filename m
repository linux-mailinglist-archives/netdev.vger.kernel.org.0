Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2B21600B9
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 22:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgBOVlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 16:41:15 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53326 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgBOVlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 16:41:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Date:Message-ID:Subject:From:To:Sender:Reply-To:Cc:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=bGHqYfSInCAN/tEcnh131kwNSejoiypREgU7kcwNj+I=; b=edAg9Cnag0H5z0od8Kcpiq8rce
        2SpbLdIwsTn0GO99zquAtYI+9UnNQyp3kz5rtOiSBSkpf7MRmLjqv6R7qLfyML9ksjnvXz3I3YHFd
        UNYk9jbPLQdbmXfCC8PplrvuG62B4S9sMTQ4mF0cJLKwZ9vrsRVD7ERDMvX96ei3++aTGSUDiqLTD
        JJKLmSikOSxfGses6aqp70u+eN8r8Rh5g6KlsHQDcHDmM+WmWSWNh6U+EAqsg0c4jTf3QwFaZ9aA6
        t5lXEUC6ewsO4BRnO1nNfphwhcpoE9+ORKCmnqTsZXVc2IhCsMt93C13SaH4JyyFPol4KyFa5cvdl
        rQg6zu8Q==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j35Ba-0006jk-3E; Sat, 15 Feb 2020 21:41:14 +0000
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH -net] skbuff: remove stale bit mask comments
Message-ID: <677a95d0-0db9-edec-0fa5-d7d3e1b5ec11@infradead.org>
Date:   Sat, 15 Feb 2020 13:41:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Remove stale comments since this flag is no longer a bit mask
but is a bit field.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 net/core/skbuff.c |    2 --
 1 file changed, 2 deletions(-)

--- lnx-56-rc1.orig/net/core/skbuff.c
+++ lnx-56-rc1/net/core/skbuff.c
@@ -467,7 +467,6 @@ struct sk_buff *__netdev_alloc_skb(struc
 		return NULL;
 	}
 
-	/* use OR instead of assignment to avoid clearing of bits in mask */
 	if (pfmemalloc)
 		skb->pfmemalloc = 1;
 	skb->head_frag = 1;
@@ -527,7 +526,6 @@ struct sk_buff *__napi_alloc_skb(struct
 		return NULL;
 	}
 
-	/* use OR instead of assignment to avoid clearing of bits in mask */
 	if (nc->page.pfmemalloc)
 		skb->pfmemalloc = 1;
 	skb->head_frag = 1;


