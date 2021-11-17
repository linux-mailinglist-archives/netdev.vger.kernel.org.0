Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40D1454E3A
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 20:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240629AbhKQUAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 15:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234602AbhKQUAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 15:00:16 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36DFC061570
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 11:57:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=EluXlquMQDXDJSFDscPX7qXDEN9E4odvGUrbI3WWx+Q=; b=SArZhIzHaaim+PpdP1p7WdXswS
        jlW8Le0TWjX2C5lQ0LIzwOu0i3kMtI0Mxl0R/DkFQG3BZ9/Dh1Ypn4yLNVEzTlBe9i/iCdeco1RLg
        zsCIT5MT+Ct+9UGMrXe952xt+ts2QOWWx238887JeI52JWBBF+Elq0Pmu/suphSEtAH9Ru/tHFmZo
        M0c9P8nwmw2wDFLTf7iOqyF7urZ6604BCQmRe/x3g30S40HIkxiLep9Rj3rSbqZxshSeh93JvdZua
        AQaibng8bW0U/64suVIAICcasyiwtaVfLlMmrn0F4ry86HF/LIgeTQVxOC3Cv+QPwS42oT7RQviIB
        YpJD96wQ==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mnR3N-006Cgq-5s; Wed, 17 Nov 2021 19:57:09 +0000
Subject: Re: [PATCH net-next 1/1] net: add missing include in
 include/net/gro.h
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>
References: <20211117100130.2368319-1-eric.dumazet@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <dac40aa1-dd8c-9e1c-80d8-8751707425be@infradead.org>
Date:   Wed, 17 Nov 2021 11:57:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211117100130.2368319-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/17/21 2:01 AM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> This is needed for some arches, as reported by Geert Uytterhoeven,
> Randy Dunlap and Stephen Rothwell
> 
> Fixes: 4721031c3559 ("net: move gro definitions to include/net/gro.h")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>   include/net/gro.h | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/include/net/gro.h b/include/net/gro.h
> index d0e7df691a807410049508355230a4523af590a1..9c22a010369cb89f9511d78cc322be56170d7b20 100644
> --- a/include/net/gro.h
> +++ b/include/net/gro.h
> @@ -6,6 +6,7 @@
>   #include <linux/indirect_call_wrapper.h>
>   #include <linux/ip.h>
>   #include <linux/ipv6.h>
> +#include <net/ip6_checksum.h>
>   #include <linux/skbuff.h>
>   #include <net/udp.h>
>   
> 

Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>

thanks.

-- 
~Randy
