Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84ACC1A1840
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 00:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgDGWce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 18:32:34 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54212 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgDGWce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 18:32:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=ceHE465QANvH7KjEA3vF1AMqSosilk1LOTmLSQVO4mc=; b=cdoLVg0f+DkRDM0bHuqLu3x5sp
        mI8ZHvmxQYcVGrGSyLYhb44NUomTxgXFy4Ygh69JBzIy36w2UgzzPH5tbvlFJ62Z5/SjOpzgDgp9f
        R34ZbRDTWb4708A5ppRpG+BCV+CD2XweradaE7zN6BN+a4hkuh0Mx0njn0Y8h7NOYX2GcqoDL4WnG
        pr39YOZJEuTeLJ3Z9heTrmODkvGcKPHdff3hxQNgU3hkUK8IRvyE+/vFo8e0LAw5jqXN95nGtIhrd
        hsDsuuTrYM+UZP0D8qZmG5+3HH+h1Z0xns3+CM5at4unx2lYgGrP7I6/siIsUih3GpaWukF5Jaw23
        5X+GVXlw==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jLwlk-0000Ds-Tl; Tue, 07 Apr 2020 22:32:32 +0000
Subject: Re: [PATCH] Documentation: sock.h - fix warnings
To:     Lothar Rubusch <l.rubusch@gmail.com>, kuba@kernel.org,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20200406215230.21758-1-l.rubusch@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <2d7059a9-930b-c62b-bf47-f5822720579b@infradead.org>
Date:   Tue, 7 Apr 2020 15:32:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200406215230.21758-1-l.rubusch@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/6/20 2:52 PM, Lothar Rubusch wrote:
> Fix some sphinx warnings at 'make htmldocs'.
> 
> Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
> ---
>  include/net/sock.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 6d84784d33fa..2924bcbbd402 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -2554,8 +2554,8 @@ sk_is_refcounted(struct sock *sk)
>  
>  /**
>   * skb_steal_sock
> - * @skb to steal the socket from
> - * @refcounted is set to true if the socket is reference-counted
> + * @skb: to steal the socket from
> + * @refcounted: is set to true if the socket is reference-counted
>   */
>  static inline struct sock *
>  skb_steal_sock(struct sk_buff *skb, bool *refcounted)
> 

Hi,
How about something like this instead:

 /**
- * skb_steal_sock
- * @skb to steal the socket from
- * @refcounted is set to true if the socket is reference-counted
+ * skb_steal_sock - steal a socket from an sk_buff
+ * @skb: sk_buff to steal the socket from
+ * @refcounted: is set to true if the socket is reference-counted
  */


and preferably (IMO) the subject should be more like this:

[PATCH] net: sock.h: fix skb_steal_sock() kernel-doc notation


thanks.
-- 
~Randy

