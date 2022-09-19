Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322805BC295
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 07:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiISFnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 01:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiISFnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 01:43:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D67513CD0;
        Sun, 18 Sep 2022 22:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=kswQqtRlZTZy0+pl26j2Fc3u0w7hABeodJ93mF1gq9E=; b=swDE5xKPpm175fQFHK2kafcX4Y
        y61lkoF5R3kI/qVTG6DcqfjDvQw3ov8X7GFnk6+TViLBSR996/oh+VIGfn1Qqx1I9bEaGX0vgeNdM
        RamBWffzo2jq/ewoKEgqAeF3IOMsTKGo4RAb2udZDxjmFj403V7vkyCLWacXWeMscm7xwStUQtuyV
        y3fT7vnoL1glPhcIvZHF/wHsPxy0+tHn+MjamENsyJqewiGf9LQ9qP4NO7XEJWHYP0CQPg24L8xTH
        eiP9cvTTGm3T3jRmW+7d6wyPraZjXbOk1vPvZByiKP/Azl2JUnOPQFdt3R3cFfOShy1mVmG0NpV/q
        mE+ilRsA==;
Received: from [2601:1c2:d80:3110::a2e7]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oa9Yc-008HTl-7l; Mon, 19 Sep 2022 05:43:02 +0000
Message-ID: <bc075348-63fc-7f15-db48-9601efd77d62@infradead.org>
Date:   Sun, 18 Sep 2022 22:43:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v5] liquidio: CN23XX: delete repeated words, add missing
 words and fix typo in comment
Content-Language: en-US
To:     Ruffalo Lavoisier <ruffalolavoisier@gmail.com>,
        Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220919053447.5702-1-RuffaloLavoisier@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220919053447.5702-1-RuffaloLavoisier@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/18/22 22:34, Ruffalo Lavoisier wrote:
> - Delete the repeated word 'to' in the comment.
> 
> - Add the missing 'use' word within the sentence.
> 
> - Correct spelling on 'malformation', 'needs'.
> 
> Signed-off-by: Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h | 4 ++--
>  drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h
> index 3f1c189646f4..a0fd32476225 100644
> --- a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h
> +++ b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h
> @@ -87,8 +87,8 @@
>   */
>  #define    CN23XX_SLI_PKT_IN_JABBER                0x29170
>  /* The input jabber is used to determine the TSO max size.
> - * Due to H/W limitation, this need to be reduced to 60000
> - * in order to to H/W TSO and avoid the WQE malfarmation
> + * Due to H/W limitation, this needs to be reduced to 60000
> + * in order to use H/W TSO and avoid the WQE malformation
>   * PKO_BUG_24989_WQE_LEN
>   */
>  #define    CN23XX_DEFAULT_INPUT_JABBER             0xEA60 /*60000*/
> diff --git a/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h b/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h
> index d33dd8f4226f..e956109415cd 100644
> --- a/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h
> +++ b/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h
> @@ -36,8 +36,8 @@
>  #define     CN23XX_CONFIG_PCIE_FLTMSK              0x720
>  
>  /* The input jabber is used to determine the TSO max size.
> - * Due to H/W limitation, this need to be reduced to 60000
> - * in order to to H/W TSO and avoid the WQE malfarmation
> + * Due to H/W limitation, this needs to be reduced to 60000
> + * in order to use H/W TSO and avoid the WQE malformation
>   * PKO_BUG_24989_WQE_LEN
>   */
>  #define    CN23XX_DEFAULT_INPUT_JABBER             0xEA60 /*60000*/

-- 
~Randy
