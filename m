Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAD25BB130
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 18:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiIPQna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 12:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiIPQn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 12:43:29 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DCB96B66F;
        Fri, 16 Sep 2022 09:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=VIQTp/mMAJwvm8srHrgUT5jXYUVcFNlxqKlrpAKS8/Q=; b=TTsMrOU/Q99WvPzchvMwiLdj56
        WqQD05hCi3BbaE/9SZlJWjHfa7Lp8GRCJliWOVkcYlRUx0QHBvUYT9ZmdE1DCIuVBSPbbL/S2mOtx
        kSKKJNhS1DStBFP64mlrvvnRwUkWWfnyiIJ5LpYR5256qj9RWtn4OItdVLrdncfJKIEP9vj3Hgd2c
        XCijfTeqziTcgHKdQyAYNLmJqWsi8YBvgSbwixcrM1aV90Y2LfP1gtqgLpEk5DxpnpTJMB5Z8u+DJ
        aA385crkIMafEB4qwxD3MGHddMXeKFmfIDYmQSdgUnrWZPraDJ+d06hF8300c1f8XSPADUnge5dsm
        YNpsybQg==;
Received: from [2601:1c2:d80:3110::c55a]
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oZEQn-00D9WO-QY; Fri, 16 Sep 2022 16:43:10 +0000
Message-ID: <b2144e21-4c51-2f71-eed7-1d78305c3bec@infradead.org>
Date:   Fri, 16 Sep 2022 09:43:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 2] liquidio: CN23XX: delete repeated words, add missing
 words and fix typo in comment
To:     Ruffalo Lavoisier <ruffalolavoisier@gmail.com>,
        Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220916150709.19975-1-RuffaloLavoisier@gmail.com>
Content-Language: en-US
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220916150709.19975-1-RuffaloLavoisier@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

You missed one comment from v1 (see below).

Also, the Subject: should be in the format
[PATCH v3]
on your next version, please.

On 9/16/22 08:07, Ruffalo Lavoisier wrote:
> - Delete the repeated word 'to' in the comment.
> 
> - Add the missing 'use' word within the sentence.
> 
> - Correct spelling on 'malformation'.
> 
> Signed-off-by: Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>
> ---
> I have reflected all the reviews. Thanks !
> 
>   drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h | 2 +-
>   drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h
> index 3f1c189646f4..244e27ea079c 100644
> --- a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h
> +++ b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h
> @@ -88,7 +88,7 @@
>   #define    CN23XX_SLI_PKT_IN_JABBER                0x29170
>   /* The input jabber is used to determine the TSO max size.
>    * Due to H/W limitation, this need to be reduced to 60000

                               this needs

> - * in order to to H/W TSO and avoid the WQE malfarmation
> + * in order to use H/W TSO and avoid the WQE malformation
>    * PKO_BUG_24989_WQE_LEN
>    */
>   #define    CN23XX_DEFAULT_INPUT_JABBER             0xEA60 /*60000*/
> diff --git a/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h b/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h
> index d33dd8f4226f..e85449249670 100644
> --- a/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h
> +++ b/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h
> @@ -37,7 +37,7 @@
>   
>   /* The input jabber is used to determine the TSO max size.
>    * Due to H/W limitation, this need to be reduced to 60000

                               this needs

> - * in order to to H/W TSO and avoid the WQE malfarmation
> + * in order to use H/W TSO and avoid the WQE malformation
>    * PKO_BUG_24989_WQE_LEN
>    */
>   #define    CN23XX_DEFAULT_INPUT_JABBER             0xEA60 /*60000*/
