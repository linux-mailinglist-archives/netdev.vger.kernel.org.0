Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD8AB1A1873
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 01:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgDGXDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 19:03:23 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57912 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgDGXDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 19:03:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=s1JRC9UTjrpVaaznypvcaop9jkIc+jkBgPaGR0b1V4E=; b=ViIhDwqXnVvpWGHvkuTOZ1CwUc
        Lco0zepkMSHaieXz4AjlRkrAarIyi/glEiOlzNmfA+ttIO+TyLAH4Ri6LElvKNznt4L227T+bebh2
        jpZm689O6Gjt60s9wOQVdJMLtP3Am/A5tnnSc69W6p7c45bHWD0JChEqFymVCKBX/uaZJsSQVFnie
        KbtfwDqja5bW3U7YE8KabdHyRlnOKktdSoEGPBlSASE1W7cvRqqpObomTb1+rIBMypqhakuf+vx4J
        caVHMBxTcoaJ2VUm0jLQLIxxNJgopDxV9OD8Y4IcAKc8mI0TgjbFBZCVnpeOQ2Yne6DHGzQ7HT6KR
        CwY1Rbew==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jLxFa-0000M5-Tt; Tue, 07 Apr 2020 23:03:22 +0000
Subject: Re: [PATCH v2] net: sock.h: fix skb_steal_sock() kernel-doc
To:     Lothar Rubusch <l.rubusch@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org
References: <20200407225526.16085-1-l.rubusch@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <f04e4472-cd56-de94-2403-ca91f31a8293@infradead.org>
Date:   Tue, 7 Apr 2020 16:03:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200407225526.16085-1-l.rubusch@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/7/20 3:55 PM, Lothar Rubusch wrote:
> Fix warnings related to kernel-doc notation, and wording in
> function description.
> 
> Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  include/net/sock.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 6d84784d33fa..3e8c6d4b4b59 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -2553,9 +2553,9 @@ sk_is_refcounted(struct sock *sk)
>  }
>  
>  /**
> - * skb_steal_sock
> - * @skb to steal the socket from
> - * @refcounted is set to true if the socket is reference-counted
> + * skb_steal_sock - steal a socket from an sk_buff
> + * @skb: sk_buff to steal the socket from
> + * @refcounted: is set to true if the socket is reference-counted
>   */
>  static inline struct sock *
>  skb_steal_sock(struct sk_buff *skb, bool *refcounted)
> 


-- 
~Randy

