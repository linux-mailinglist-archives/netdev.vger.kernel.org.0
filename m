Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31AC45BA5A9
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 06:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiIPER2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 00:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiIPER0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 00:17:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D4C9F74A;
        Thu, 15 Sep 2022 21:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=MEez9kK9Q97P1sNxTGr3lx3ZTRfEr4B4CaTzZ35o3+U=; b=YIWUCsCzoDIpAz4Rd/l7Q5gAp1
        h05ASEEwsY6s/Y348jsKaoQMlveis882eVIUvW8Nfk4v/Y1fMCQoZ0WaxoLwRvYPz5Q6z6uVQuO6F
        EPApgKdv1xYkkm2Z48VDd7Sia5UTpDeni2zylLp4+K679Pfi0vep6z3AP3yFryI5tZHREqT9qNdyI
        71xwY6UiAgxUUsEDGWO8LUuIwdrQ6cusT+sQ2HJGPPWflXg7pLPOC0YTDdcq0S3+Jx3CDJEAO0ajv
        yNQUS5oXVQyNo8PPzTSuCOSymv7RaEdqFuqSOZm4tJjFFtcSCshAQGRpehpKeVeJ5TjHA4wx1TWyR
        sxFt+A3g==;
Received: from [2601:1c2:d80:3110::c55a]
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oZ2mq-001qML-Dj; Fri, 16 Sep 2022 04:17:08 +0000
Message-ID: <293d8d5b-8423-a8bc-a42f-34b08ee65717@infradead.org>
Date:   Thu, 15 Sep 2022 21:17:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] liquidio: CN23XX: delete repeated words
To:     Ruffalo Lavoisier <ruffalolavoisier@gmail.com>,
        Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220915084637.5165-1-RuffaloLavoisier@gmail.com>
Content-Language: en-US
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220915084637.5165-1-RuffaloLavoisier@gmail.com>
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

Hi--

There are several other problems here also.
Preferably fix all of them.

On 9/15/22 01:46, Ruffalo Lavoisier wrote:
> - Delete the repeated word 'to' in the comment
> 
> Signed-off-by: Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>
> ---
>   drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h | 2 +-
>   drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h
> index 3f1c189646f4..9a994b5bfff5 100644
> --- a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h
> +++ b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h
> @@ -88,7 +88,7 @@
>   #define    CN23XX_SLI_PKT_IN_JABBER                0x29170
>   /* The input jabber is used to determine the TSO max size.
>    * Due to H/W limitation, this need to be reduced to 60000

                               this needs

> - * in order to to H/W TSO and avoid the WQE malfarmation > + * in order to H/W TSO and avoid the WQE malfarmation

Now it is missing some word. Something like
       in order to use H/W TSO
makes some sense.

Also, s/malfarmation/malformation/

>    * PKO_BUG_24989_WQE_LEN
>    */
>   #define    CN23XX_DEFAULT_INPUT_JABBER             0xEA60 /*60000*/
> diff --git a/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h b/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h
> index d33dd8f4226f..19894b7c1ce8 100644
> --- a/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h
> +++ b/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h
> @@ -37,7 +37,7 @@
>   
>   /* The input jabber is used to determine the TSO max size.
>    * Due to H/W limitation, this need to be reduced to 60000
> - * in order to to H/W TSO and avoid the WQE malfarmation
> + * in order to H/W TSO and avoid the WQE malfarmation

Same as comments above.

>    * PKO_BUG_24989_WQE_LEN
>    */
>   #define    CN23XX_DEFAULT_INPUT_JABBER             0xEA60 /*60000*/
