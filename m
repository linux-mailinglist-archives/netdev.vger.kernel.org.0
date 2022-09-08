Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBBA5B2320
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 18:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbiIHQHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 12:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbiIHQHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 12:07:51 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C92F9119;
        Thu,  8 Sep 2022 09:07:50 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id m1so25105085edb.7;
        Thu, 08 Sep 2022 09:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date;
        bh=CZsiNn0kUvXidgR28Tb23ZwUipa8jt5qVfdFHVjhu/s=;
        b=ASbQ8dKxyeese/GlOcIMzqpl5DffglgmZSDTGMdl0X6xiJddy/x+GWQXYP0gnwNyC9
         u7DMAG0BaH5bzm4JE2/9kfzrmzKw+V2ghmWRXHUZEADQ41ylyZQEk9K+JUa8grNkef9y
         mWdPBnLCO+p5DCyVNKjC7Wj9bspDlTnyv5p4PMX59KGbiltY18T/hPRC4a7Cga0OE7Pg
         PRD4XOZ5NuSfHTFP7CxuFpHjaKsjdq2JuVZq+lKKottHP/vLpbSx7YA5FAqdpgPKDSau
         p6lmsMvNdaN9F9ak5dEqk0IA5K46787sKVagYfQlgsDIuk5fmJglt4Htz+GliOC7d8m1
         QpQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date;
        bh=CZsiNn0kUvXidgR28Tb23ZwUipa8jt5qVfdFHVjhu/s=;
        b=iM0e9lsx/s+0am4Nruoit6WQRIpPC1d6Bfod+GpOcAzswURaN4fW4+xGBJ0Vlr5D+6
         rRokJfmSu/kYkFBM3U30P7GYL1EZbxUQyLBcXvVo+5ZfEXChIpdgyVEDVIq8y1avhSsk
         lFdgnWFsuJyILsMA9EjRQCK1vw6IE9sWeXT4w+BoTqSGjmBboVFuIVM6NDgG54e5R9KG
         Dk4s7ENSuQ6zZC1aAO9s+Z/zuD+A1Se5jojkyDCU2zngy1qdNdveyQ3ZL3MXcZ4/osGc
         4z6iRY3ZsVScdTp1pg6SUMp4W72eUsFKDFNpa1aO+ZUIMOvUyuO0F0DUYFhgeo3LwYAt
         x5QA==
X-Gm-Message-State: ACgBeo2wxM5wwueyzam03/Q1ZySNFBnM/vLtHp2LWEhtAst6C0CLZfzW
        26AYwdGV6FowquLMo6ytnUPckAv+EK4=
X-Google-Smtp-Source: AA6agR4BbXFHtNp2qJgs/L4HM2U83qojhXmPOPVaJwW93Z9yrWJFFGMV2RuJGL5+Wz0m2fnvGCKBSQ==
X-Received: by 2002:a05:6402:28cb:b0:43b:c6d7:ef92 with SMTP id ef11-20020a05640228cb00b0043bc6d7ef92mr7945512edb.333.1662653268922;
        Thu, 08 Sep 2022 09:07:48 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id p25-20020aa7d319000000b0044ee2869ef7sm5001143edq.4.2022.09.08.09.07.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Sep 2022 09:07:48 -0700 (PDT)
Subject: Re: [PATCH] ethernet/sfc: fix repeated words in comments
To:     wangjianli <wangjianli@cdjrlc.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220908124630.24314-1-wangjianli@cdjrlc.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <30f2488d-9af3-fe8d-6e6f-713a7d38800b@gmail.com>
Date:   Thu, 8 Sep 2022 17:07:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220908124630.24314-1-wangjianli@cdjrlc.com>
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

On 08/09/2022 13:46, wangjianli wrote:
> Delete the redundant word 'in'.
> 
> Signed-off-by: wangjianli <wangjianli@cdjrlc.com>
> ---
>  drivers/net/ethernet/sfc/bitfield.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sfc/bitfield.h b/drivers/net/ethernet/sfc/bitfield.h
> index 1f981dfe4bdc..0b502d1c3c9e 100644
> --- a/drivers/net/ethernet/sfc/bitfield.h
> +++ b/drivers/net/ethernet/sfc/bitfield.h
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

Nack.
"filled in" is a phrasal verb, so the existing text is correct.  Stet.

#ifdef RANT
NGL, getting kinda sick of these bogus comment text 'fixes' from people
 who clearly don't have enough mastery of English to copyedit it.
(Previous one from this author was actually wrong too but I didn't catch
 it at the time.)
English is a tricksy language, why would someone with a limited
 understanding of it think that grammar fixes are the best use of their
 time and energy?
I can't help suspecting that this is a box-ticking exercise, where a
 certain corporate culture has a standard requirement that engineers
 must get X number of Linux / opensource commits in order to get
 promoted, and this kind of mindless patch is the easiest way for them
 to achieve that.
#endif

-ed
