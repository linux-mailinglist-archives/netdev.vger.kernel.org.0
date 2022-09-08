Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB0DE5B2324
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 18:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbiIHQIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 12:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiIHQIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 12:08:44 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F9210C98F;
        Thu,  8 Sep 2022 09:08:41 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id q21so17485113edc.9;
        Thu, 08 Sep 2022 09:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date;
        bh=c+UWBqauEpqfneLIMsp58ZZTXXVObQlDGf+MjI2qqhY=;
        b=oW3oyWASfc4C/C49tI8S4mCfY/V706LSOSUOkg5VR9ssX5bqA+iz5Sq+jT3wdjnFMD
         tX8Smd/Ha3+T9bTfaNO61behzvTdS1huttd+klbEtgMBw2m4jUW8mw7A7ZuidjDIkwRX
         hR7TK/QQmV9ADh9Fy0YW4jEDo/es6tqK612OJX4+yDsWsmVWYuF7sKcauDNaFuiNPs21
         p6TKy2WBHbE3agsb2D4C+aRaHN4Oh9wwUvRUvIpIy1m7GlrxQu862IZu0q0q8lFqdMRn
         Gm0BU3UIGdmV8cqB+zArCOKSIzjRortStVf67gwRgXbZQ0AVliPSnme0AvWXPmHPN8hE
         3tnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date;
        bh=c+UWBqauEpqfneLIMsp58ZZTXXVObQlDGf+MjI2qqhY=;
        b=7dDoP6p4HiThYk411x2EwNkrsLurhaCtYC+XPLN/GxVVp6pbre7OVhPantU3L9ZJ40
         WKzzo0gchXFY5BSYimb87hM6SsdGBSlb0xBzWOpEiU+HSquMWp/uaLgaI+T6NKmM6PDU
         sh5T95CT8ErlA5oHOlaSXw0qf1U5MC5BFON4hvSA28ShzwCmNxc3Tok2nbOr/BMnzJXE
         yn23BZna3I4fBm/gVexpUQa/4aNgU4QXORCPn9dyJ7WP8JiWR6478LBANwK6/soWyqdi
         ER+MsBnJUPIrVVcKwWreJ3h9MufIPYU9NEPfh3poUnpkqqLC9cq6+zkulMi653CdVLts
         mb8g==
X-Gm-Message-State: ACgBeo1spKOWnaM3TCdaRMxm0vK9BG9/hcTAujX1SG4SXjmUam22T9k6
        N+QJDs3ylh5keQA/9q4HmMWNa662alw=
X-Google-Smtp-Source: AA6agR79zwlxVklVg/nlxKCYuqWTXjx5HaEeBBeMXLywvHJVJoYHpUoI4o6WS8vyHTaFWRwfR0ou+w==
X-Received: by 2002:a05:6402:50cb:b0:440:87d4:3ad2 with SMTP id h11-20020a05640250cb00b0044087d43ad2mr7806671edb.219.1662653319629;
        Thu, 08 Sep 2022 09:08:39 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id e12-20020a1709062c0c00b0073d53f4e053sm1378829ejh.104.2022.09.08.09.08.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Sep 2022 09:08:39 -0700 (PDT)
Subject: Re: [PATCH] sfc/siena: fix repeated words in comments
To:     wangjianli <wangjianli@cdjrlc.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220908124454.23465-1-wangjianli@cdjrlc.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <ec7f175f-a340-021b-b03e-80c9c1f17d31@gmail.com>
Date:   Thu, 8 Sep 2022 17:08:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220908124454.23465-1-wangjianli@cdjrlc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/09/2022 13:44, wangjianli wrote:
> Delete the redundant word 'in'.
> 
> Signed-off-by: wangjianli <wangjianli@cdjrlc.com>
> ---
>  drivers/net/ethernet/sfc/siena/bitfield.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sfc/siena/bitfield.h b/drivers/net/ethernet/sfc/siena/bitfield.h
> index 1f981dfe4bdc..0b502d1c3c9e 100644
> --- a/drivers/net/ethernet/sfc/siena/bitfield.h
> +++ b/drivers/net/ethernet/sfc/siena/bitfield.h
> @@ -117,7 +117,7 @@ typedef union efx_oword {
>   *
>   *   ( element ) << 4
>   *
> - * The result will contain the relevant bits filled in in the range
> + * The result will contain the relevant bits filled in the range
>   * [0,high-low), with garbage in bits [high-low+1,...).
>   */
>  #define EFX_EXTRACT_NATIVE(native_element, min, max, low, high)		\
> 

Nack, as per my other response on the main sfc patch.
-ed
