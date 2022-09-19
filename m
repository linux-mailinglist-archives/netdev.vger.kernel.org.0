Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E74AC5BC0F6
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 03:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiISBRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 21:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiISBRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 21:17:37 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBBCC14D39;
        Sun, 18 Sep 2022 18:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=3slYwVTJ7xIHyNfZL8OGsEwhN5Ode0KIAXbLHwiqGfE=; b=haZzIR8yi4CY9GXU8XGFXAN+iV
        zgGJlH+7MFBuhGTi9CKwKNQ7d7n5U8nbdAiYTAXb7UKhpwBBfyv39cM5kXB+7Y6aiYuqDVmFJ8543
        fmNNX844Doqak63dOBBsERG3q9KiQC+FyJb+OPQ+ydErj3Uj65iW3H3Yucpo5XDGrAvdhkdHFIHfw
        VgCVJqnZucvZ5eWU42maUU23+LPDhzfepBqTXK3FlKceu14L9G3ZAvBXeGfxBLwhLw8wDd4zUW0my
        1Ynm3fWtNXNge6Ke1BiFOB7ncbNcubIC7Tuze+xiNj5xJPIvQJeGOFmKPuvi4IZjEi59U6SbavQTH
        YDWZ0ksw==;
Received: from [2601:1c2:d80:3110::a2e7]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oa5PV-005LfD-Qj; Mon, 19 Sep 2022 01:17:22 +0000
Message-ID: <e7fa7741-94d8-b5d4-e3df-fa111d873e0a@infradead.org>
Date:   Sun, 18 Sep 2022 18:17:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v3] liquidio: CN23XX: delete repeated words, add missing
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
References: <20220919010410.6081-1-RuffaloLavoisier@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220919010410.6081-1-RuffaloLavoisier@gmail.com>
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

Hi--

On 9/18/22 18:04, Ruffalo Lavoisier wrote:
> - Delete the repeated word 'to' in the comment.
> 
> - Add the missing 'use' word within the sentence.
> 
> - Correct spelling on 'malformation'.
> 
> Signed-off-by: Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>
> ---
> Please check if it has been corrected properly!

Once again there is a needed change that is missing. Please see below.

> 
>  drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h | 2 +-
>  drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h
> index 3f1c189646f4..244e27ea079c 100644
> --- a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h
> +++ b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_regs.h
> @@ -88,7 +88,7 @@
>  #define    CN23XX_SLI_PKT_IN_JABBER                0x29170
>  /* The input jabber is used to determine the TSO max size.
>   * Due to H/W limitation, this need to be reduced to 60000

                             this needs

> - * in order to to H/W TSO and avoid the WQE malfarmation
> + * in order to use H/W TSO and avoid the WQE malformation
>   * PKO_BUG_24989_WQE_LEN
>   */
>  #define    CN23XX_DEFAULT_INPUT_JABBER             0xEA60 /*60000*/
> diff --git a/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h b/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h
> index d33dd8f4226f..e85449249670 100644
> --- a/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h
> +++ b/drivers/net/ethernet/cavium/liquidio/cn23xx_vf_regs.h
> @@ -37,7 +37,7 @@
>  
>  /* The input jabber is used to determine the TSO max size.
>   * Due to H/W limitation, this need to be reduced to 60000

                             this needs

> - * in order to to H/W TSO and avoid the WQE malfarmation
> + * in order to use H/W TSO and avoid the WQE malformation
>   * PKO_BUG_24989_WQE_LEN
>   */
>  #define    CN23XX_DEFAULT_INPUT_JABBER             0xEA60 /*60000*/

-- 
~Randy
