Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A93704DBBFB
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 01:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355269AbiCQBAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 21:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355930AbiCQA76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 20:59:58 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5E113E31
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 17:58:40 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id w127so4169924oig.10
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 17:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=73JwOaCUEMBMS9Z8XZ30f1vfEK61WWpxTXG0NNJeeKo=;
        b=C340OfqU1HJ7/DUuFVU2SN8hHyLCiTh6MR7fHeW5X7S9911ixPG6PzKZtwRh+J0w7a
         9XnQR/UYMnWV9HsCbs8TR2oqyJAFNQmUb7qRBXAQXno9qnid/dr9r6F1EBHHR5jQOzmW
         5f6H4QOwv+mFmziubzqgnr0WtRPq/hZL0YQRmJDihLK/6bnN72yICXs8uHTzeInyeI4m
         PcTibreBO4OyRw2ds0ooeILxCR1dvj9Mhmoxm4bNIcHpuPjT+YuDE/iiBsGPzCVmorUJ
         00mr1TM8SSya9bswy08w8t7cPiPHuUSJC13BGT4n+zM9uvhRaFX3R5VpVJ7HkKUX1Sal
         6apQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=73JwOaCUEMBMS9Z8XZ30f1vfEK61WWpxTXG0NNJeeKo=;
        b=ND1a4MYBqT9Fv4czn2cSuAu0gt4IrT1mLDAvt7Tbxg50gK0w11zVt/O3XeQr8YT3Xo
         I+qsQDSHqUvcUvZ8g2pKeUSAGNuzb/rtxvtdxa9xOq0DXKZ+R+Pmrq2fH8UFqKdpZ89Y
         batUh3C57t1/+oJfGIYZlV2W/UECNAWaPL4vK2FaobgG8TWxU+QA9ULXzrnX+79oOBnE
         mwMGkmaUtjTPzDSy4U2UdRTdR1ZJPbuoLeDlw8AtpdYwPyBwZTo+RwNJF1Zhhf3pE+pS
         2OmTOs/u30odR6/sjzXxlR56pkbL0Rv8TeYgd6p0uC4npQkc+KtZ7FWQ6OFg9hJ7Yl/w
         1t3g==
X-Gm-Message-State: AOAM533ogXOwHT4QzwU46HiTRp7JWx153vcpqFiSR28BcK9wx65BpqGY
        3lyEw5Vg6oKS5UAzNCmULrQ=
X-Google-Smtp-Source: ABdhPJwrumKzVt1O1oKExoB9B3tpGlv2o7itPontYyXFNWKZGSkVHE+kk0HSWuLRndzAnce3hGVJ0g==
X-Received: by 2002:a05:6808:8cb:b0:2ee:f75b:41f1 with SMTP id k11-20020a05680808cb00b002eef75b41f1mr2314778oij.123.1647478719260;
        Wed, 16 Mar 2022 17:58:39 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.65])
        by smtp.googlemail.com with ESMTPSA id y128-20020acae186000000b002d97bda3873sm1728072oig.56.2022.03.16.17.58.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 17:58:38 -0700 (PDT)
Message-ID: <95c69336-4aa5-eed7-22bb-ba1f20044d7f@gmail.com>
Date:   Wed, 16 Mar 2022 18:58:38 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH iproute2-next v5 2/2] f_flower: Implement gtp options
 support
Content-Language: en-US
To:     Wojciech Drewek <wojciech.drewek@intel.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
References: <20220316110815.46779-1-wojciech.drewek@intel.com>
 <20220316110815.46779-3-wojciech.drewek@intel.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220316110815.46779-3-wojciech.drewek@intel.com>
Content-Type: text/plain; charset=UTF-8
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

On 3/16/22 5:08 AM, Wojciech Drewek wrote:
> @@ -1869,6 +1951,13 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
>  				fprintf(stderr, "Illegal \"erspan_opts\"\n");
>  				return -1;
>  			}
> +		} else if (matches(*argv, "gtp_opts") == 0) {

strcmp(). not allowing any more matches for new options.

