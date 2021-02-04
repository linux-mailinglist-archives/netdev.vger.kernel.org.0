Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A70B30E90D
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 02:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234150AbhBDA5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 19:57:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233467AbhBDA5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 19:57:34 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1EACC061573;
        Wed,  3 Feb 2021 16:56:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=HkUAF+HEHd9uglFyYDmvKHcOMqP4J05wPUeGwwc3zxg=; b=kT/rDGL0OlNNU4p1x4lAaMGUzy
        CvUCk8sTo4bkxTM7TyNAyI4B3TiKwTZWyJZLTDYCvNCnwOL5pWUwtc04JVLHyhScSKGnCDRQFrdDz
        ZtQJbbmWjJexRrJFzFGvyQrMYrIku9Y16hQyZPr/uqSnQ+rZF3lQsfJhKz0gWPSui5qZZf82otIwL
        1Ozo2D9+R+yiW5FV2uL23kRWJ1r8IoXqmK4Hx/IqY1NbYpxFpYZYphlSsXrg/TMWslD74hbljMR0T
        OYoh3yyTawOy62THD/TyjsxRj7THDe517PhuvwjwU8c0Ae7WNh3ZbOj4oCn21C6BiUx2mEwy4DXcG
        ofhraNJQ==;
Received: from [2601:1c0:6280:3f0::aec2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l7Sx1-0005Ct-9I; Thu, 04 Feb 2021 00:56:51 +0000
Subject: Re: [PATCH v2] rt2x00: remove duplicate word and fix typo in comment
To:     samirweng1979 <samirweng1979@163.com>, stf_xl@wp.pl,
        helmut.schaa@googlemail.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
References: <20210204005119.18060-1-samirweng1979@163.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <bcae0800-8ed3-b33a-9489-03e7d9b82840@infradead.org>
Date:   Wed, 3 Feb 2021 16:56:46 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210204005119.18060-1-samirweng1979@163.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/21 4:51 PM, samirweng1979 wrote:
> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> remove duplicate word 'we' in comment
> change 'then' to 'than' in comment
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  drivers/net/wireless/ralink/rt2x00/rt2x00crypto.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00crypto.c b/drivers/net/wireless/ralink/rt2x00/rt2x00crypto.c
> index c861811..ad95f9e 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00crypto.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00crypto.c
> @@ -179,7 +179,7 @@ void rt2x00crypto_rx_insert_iv(struct sk_buff *skb,
>  	 * Make room for new data. There are 2 possibilities
>  	 * either the alignment is already present between
>  	 * the 802.11 header and payload. In that case we
> -	 * we have to move the header less then the iv_len
> +	 * have to move the header less than the iv_len
>  	 * since we can use the already available l2pad bytes
>  	 * for the iv data.
>  	 * When the alignment must be added manually we must
> 


-- 
~Randy

