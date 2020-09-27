Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F8D27A1CA
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 18:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgI0QOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 12:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgI0QOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 12:14:43 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6287C0613CE;
        Sun, 27 Sep 2020 09:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=ik7a4/nsVk8BAlTpU8JGdC8GG6dWXG+8DRdMggxS0U0=; b=LMq/AnZNjA9odfL5NABJEuri3d
        LncuhwLNRHkqxISOEcTNlzY2d+wOM7RTjGKe3gyf16qM8327F9iZUTmWN1jn8bgYyuLF7pJstF1YT
        ZwCQ2PsL+HXOZZ3DjHyi+QQv1UQGR4SinrIEmLlkXN5ctnNyQQgw2kV3Qp0zU4pombGX0UxaTLUrP
        aUjDlC511KeBCeYGOzUCuj47GYaU7S2pFUy0PClVmHJciDOsZzugJuoBw9L9NKgzoc4fwOpC/D0/q
        hxHePhFzidGuLsdNNUcG1kczfN7cJWdJh13RACqYE1latlGad+DbUSGjmeIu7gUZQ3BsKcUZY7vFM
        67LObhDA==;
Received: from [2601:1c0:6280:3f0::19c2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kMZJr-0001tk-NA; Sun, 27 Sep 2020 16:14:36 +0000
Subject: Re: [PATCH] ptp: add stub function for ptp_get_msgtype()
To:     Yangbo Lu <yangbo.lu@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <20200927080150.8479-1-yangbo.lu@nxp.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <77c83c45-4087-eab8-ee66-6bcca11a5e2d@infradead.org>
Date:   Sun, 27 Sep 2020 09:14:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200927080150.8479-1-yangbo.lu@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/27/20 1:01 AM, Yangbo Lu wrote:
> Added the missing stub function for ptp_get_msgtype().
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Fixes: 036c508ba95e ("ptp: Add generic ptp message type function")
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>

Yes, that works. Thanks.

Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested


> ---
>  include/linux/ptp_classify.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/include/linux/ptp_classify.h b/include/linux/ptp_classify.h
> index 8437307..c6487b7 100644
> --- a/include/linux/ptp_classify.h
> +++ b/include/linux/ptp_classify.h
> @@ -134,5 +134,13 @@ static inline struct ptp_header *ptp_parse_header(struct sk_buff *skb,
>  {
>  	return NULL;
>  }
> +static inline u8 ptp_get_msgtype(const struct ptp_header *hdr,
> +				 unsigned int type)
> +{
> +	/* The return is meaningless. The stub function would not be
> +	 * executed since no available header from ptp_parse_header.
> +	 */
> +	return 0;
> +}
>  #endif
>  #endif /* _PTP_CLASSIFY_H_ */
> 


-- 
~Randy
