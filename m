Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38834EB8DB
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 05:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242301AbiC3Dey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 23:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234408AbiC3Dew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 23:34:52 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B45220D50D;
        Tue, 29 Mar 2022 20:33:08 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id k14so16521784pga.0;
        Tue, 29 Mar 2022 20:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=O7WnR7EzqldPHCCUCQ6z4CvVrhzjPQsXRUis1ZkQcUY=;
        b=dTDPEc66gojFkJ99oenjMlwIfmivdEHOuFNxfKTYND2Ly48txHP5IzAFglJszi22yA
         hfY/x0CGl9evXATJp5cF36OoCYebGMh5iXopuir34f5cy65VHJKZ1NAhpOfd1uIcBbzx
         pnt8BosD1ahNznghfOcFj4YAv0TPuHEUf218ikgbvH2kQv8ASuK41jFJloXWqFXSfmVv
         gStebdACU26I+1HalQD9AnwEEU3w9DrxA7jHmXSNt//RII7rcXP0GLGXffTFY9EX9xFT
         oDyyTt8K115UXP29ymvh45TnwfFCQwUjsuVUkfc6IMS8/d8GQLx0zIzuUUfY+vVwC+QF
         I0ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=O7WnR7EzqldPHCCUCQ6z4CvVrhzjPQsXRUis1ZkQcUY=;
        b=JEkruS220vxDA30kIdQ/ugRZfP5c1AZXm3XlEQuwpgRslNsSdv844na5v9VrdvSvRU
         4iTvad2SuJ4otaVS/xeFpNQraPODuozTGcLXYbA3BTT6H/tndf3IlbUpj+yhCgZ+1sVp
         CNYwtg/Y5HwBL53YDH1dHkEDJ3E1gAOBz8RAsZ3QMV7WqvSmV0cjy28xyumsvfCYFkZQ
         YcTNN+vi3/8BfYylCqMzFqYr+zUqVGV/pTOPGh0kfsSf9Du3dnDQE7Hol2Zj3kCiMV0h
         OMaWKLRF6CQ7E/JABXOFK65ryeWDmtApTvFVrYJ6lZXdiMdOOnsPoazvhdcKnV7Q85VR
         v3fQ==
X-Gm-Message-State: AOAM532iDLFYi+eq15TYy15Kn/G2cB8BD0Vc/p95+lslFrupodw+mY3O
        sgTWix/XnzJEWMrtp1SsDXo=
X-Google-Smtp-Source: ABdhPJy0s78gDDYhivsHScUeNvdvM8YAWWgYR/p8Ipq/d6WEJi+TpaI4htLPtxbWmcBOfUKSOGqfPg==
X-Received: by 2002:aa7:90d5:0:b0:4e1:307c:d94a with SMTP id k21-20020aa790d5000000b004e1307cd94amr30983879pfk.38.1648611187749;
        Tue, 29 Mar 2022 20:33:07 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id pi2-20020a17090b1e4200b001c7b15928e0sm4514940pjb.23.2022.03.29.20.33.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Mar 2022 20:33:07 -0700 (PDT)
Message-ID: <6c1836e4-0ac1-a743-5b91-c6b1867b8338@gmail.com>
Date:   Tue, 29 Mar 2022 20:33:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net v2 07/14] docs: netdev: rephrase the 'Under review'
 question
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch
References: <20220329050830.2755213-1-kuba@kernel.org>
 <20220329050830.2755213-8-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220329050830.2755213-8-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/28/2022 10:08 PM, Jakub Kicinski wrote:
> The semantics of "Under review" have shifted. Reword the question
> about it a bit and focus it on the response time.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Nit below:

> ---
>   Documentation/networking/netdev-FAQ.rst | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
> index e10a8140d642..00ac300ebe6a 100644
> --- a/Documentation/networking/netdev-FAQ.rst
> +++ b/Documentation/networking/netdev-FAQ.rst
> @@ -116,10 +116,12 @@ patch. Patches are indexed by the ``Message-ID`` header of the emails
>   which carried them so if you have trouble finding your patch append
>   the value of ``Message-ID`` to the URL above.
>   
> -The above only says "Under Review".  How can I find out more?
> --------------------------------------------------------------
> +How long before my patch is accepted?
> +-------------------------------------
>   Generally speaking, the patches get triaged quickly (in less than
> -48h).  So be patient.  Asking the maintainer for status updates on your
> +48h). But be patient, if your patch is active in patchwork (i.e. it's
> +listed on the project's patch list) the chances it was missed are close to zero.
> +Asking the maintainer for status updates on your
>   patch is a good way to ensure your patch is ignored or pushed to the
>   bottom of the priority list.

I would reword that at some point, this feels a little bit retaliating.
-- 
Florian
