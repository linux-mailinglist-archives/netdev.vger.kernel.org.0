Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDDF630FA0
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 18:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbiKSROk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 12:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiKSROi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 12:14:38 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590ED13F7B;
        Sat, 19 Nov 2022 09:14:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=JU2+ZJVbVVTJbcrbiBUSe/4vYflalSTNI21pEuGrk90=; b=ld2+Dckvp8CiCxIb1CeyVk23LY
        lB1/XVpSTk02qTQp1SnXknuggoZYxIpX/oV5QvO1hmYkwLcd578AJUA3UppXIlqLpmXYGq1KdONQm
        zDPfkbNmG1bs+Llv5BEM0kzvy7PI1hnwNYuTZ8FelZxKJkPP5dfdHd+A/Wwq7Jo7Tg2aMg2PCCcOv
        xGHPgikY67I+X+igS29qk+ChynMdRPdDx0u0CESzTTnMPG0O8jFotMEgBpUexikyDtzyTQEXyvIDQ
        RDpw5g1aGgZNzsWYVpXAwNLBVkX1CFgYHTk4pAzHRTztHR75WzdoDnbU+f+zN5wcTxu/QNnp2T/+M
        kEE4jr+A==;
Received: from [2601:1c2:d80:3110::a2e7]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1owRQ1-00FUxZ-S8; Sat, 19 Nov 2022 17:14:17 +0000
Message-ID: <bce610de-60a5-2c00-0231-e5891c480ccf@infradead.org>
Date:   Sat, 19 Nov 2022 09:14:15 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] octeontx2-pf: Remove duplicate MACSEC setting
Content-Language: en-US
To:     Zheng Bin <zhengbin13@huawei.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     zhangqilong3@huawei.com
References: <20221119133616.3583538-1-zhengbin13@huawei.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20221119133616.3583538-1-zhengbin13@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/19/22 05:36, Zheng Bin wrote:
> Commit 4581dd480c9e ("net: octeontx2-pf: mcs: consider MACSEC setting")
> has already added "depends on MACSEC || !MACSEC", so remove it.
> 
> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.


> ---
>  drivers/net/ethernet/marvell/octeontx2/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/Kconfig b/drivers/net/ethernet/marvell/octeontx2/Kconfig
> index 6b4f640163f7..993ac180a5db 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/Kconfig
> +++ b/drivers/net/ethernet/marvell/octeontx2/Kconfig
> @@ -32,7 +32,6 @@ config OCTEONTX2_PF
>  	tristate "Marvell OcteonTX2 NIC Physical Function driver"
>  	select OCTEONTX2_MBOX
>  	select NET_DEVLINK
> -	depends on MACSEC || !MACSEC
>  	depends on (64BIT && COMPILE_TEST) || ARM64
>  	select DIMLIB
>  	depends on PCI
> --
> 2.31.1
> 

-- 
~Randy
