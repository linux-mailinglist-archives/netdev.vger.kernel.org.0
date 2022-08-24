Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94A6E59FF5F
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 18:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237669AbiHXQVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 12:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234401AbiHXQVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 12:21:49 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7B472FE4
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 09:21:47 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id w22so1945224ljg.7
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 09:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=k6SNW7J2SfguWP3OtBkY8mnZEFPOGhbwfNAroApAm7s=;
        b=MDJnXAgDBHvTy76WavYOAveBAAEJ4DAnVQYs79aBAeInxvPqro6z4CvQfIAZaGVhM+
         aWSYYWovl4+EL2Flp1IaHQb0pgOHUx9an6lv6Yc3TjwnST6GRXFM2pyJeReqXU9IowHI
         J6x0unmhNJP//73W02rIysB8YfSB7CRnd4swVn9ybcgRL1BRPyzBBT/y/fiJlW1PgOB+
         fqcakNSaa34n4rjePG/3MiXn6WsBf93cdNvuZ0gQfgFu8qMfCxpGtMh3iXE/wF6QsXBa
         7TE2cj/LiP8TOuW4wCc35mbTMN9AsQ4rhePj0YP0XNLzvzT96Nh1MAUyjG1PUK315skg
         iRHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=k6SNW7J2SfguWP3OtBkY8mnZEFPOGhbwfNAroApAm7s=;
        b=djhJ3w+LnSBPy8/j9gAj5wuwIV3rFpymgCHMafCeJTVWYcQzV26KC0QvcOUxm8RiDJ
         UJP9xPxryqqcedpEDOqkgFBwFEJIRcHyA/iipQ6dQDTat9cdqy1uxxtH0rIaFoU4GS7a
         nk4QEsosWzeiAcmkRIFxo0eUMuytNm7/PUUuAVkvF3CCk5YNw7KBi1NTz07iK+eB+RGn
         NC6ox9xuqBYQP9/khxWGBz3Nnjm9RmEJCfaxZ2mATJ4afo/2m9u6gtWUVS8WmifSsfsY
         oPh+o/bE63uuEEFwgWQcu4gNvFjEncKQp8zdjiY5CrSc0e9KD2x92XNYT4Z/lt2H2gra
         BLAQ==
X-Gm-Message-State: ACgBeo1vESwbM9zZA5sWIUZxTXg1hmvRAAgw0IDLaJtO1kl6K71i5R0a
        oSpFKVJGssIBoIhLNhbGkYSn7w==
X-Google-Smtp-Source: AA6agR7JPXg0zTi67AlYDYylMurz8hYT+xKnReiKHT727s+i59BNOBILUXH0f+RwwsQFXE9MsFctWQ==
X-Received: by 2002:a2e:505d:0:b0:261:ce76:52b7 with SMTP id v29-20020a2e505d000000b00261ce7652b7mr6356ljd.286.1661358106060;
        Wed, 24 Aug 2022 09:21:46 -0700 (PDT)
Received: from [192.168.0.71] (82.131.98.15.cable.starman.ee. [82.131.98.15])
        by smtp.gmail.com with ESMTPSA id q9-20020a056512210900b0048b1d92991asm3019085lfr.303.2022.08.24.09.21.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Aug 2022 09:21:45 -0700 (PDT)
Message-ID: <cb9ee490-744d-bc5d-715d-7a23d2b682c8@linaro.org>
Date:   Wed, 24 Aug 2022 19:21:44 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: ST ST95HF DRIVER security bug
Content-Language: en-US
To:     =?UTF-8?B?157Xmdeb15DXnCDXqdeY16jXkNeV16E=?= 
        <mdstrauss91@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, linux-nfc@lists.01.org
References: <CAAMXCFnzLX-yWKSJ5JoBxcE8E0=cSQeDExGoFBxhkusUNeYncg@mail.gmail.com>
 <d499ec9a-a1e3-83e0-b66f-346a9186b4a6@linaro.org>
 <CAAMXCF=15tSmz7=nzVRgw166wDmMGiBuLx6Of-NLvboMN3nAuQ@mail.gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <CAAMXCF=15tSmz7=nzVRgw166wDmMGiBuLx6Of-NLvboMN3nAuQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/08/2022 18:12, מיכאל שטראוס wrote:
>>
>> Please use scripts/get_maintainers.pl to Cc relevant people. You got the
>> same comment last time as well...
>>
> Sorry my bad, i forgot we already contacted.
> I actually ran it and your name came up for some reason.
> 
>> ./scripts/get_maintainer.pl drivers/nfc/st95hf/spi.c
> 
> Bad divisor in main::vcs_assign: 0
> 
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> (maintainer:NFC
>> SUBSYSTEM)
> 
> netdev@vger.kernel.org (open list:NFC SUB

and other addresses... why removing them?

> 
> 
> 
> 
>>  What does it mean "current source"? Please be specific which exactly
> 
> kernel version is affected, which commit introduced it.
> 
> *Effected version: *
> - v6.0-rc2 <https://github.com/torvalds/linux/releases/tag/v6.0-rc2>  ...
> - *v4.5-rc1* <https://github.com/torvalds/linux/releases/tag/v4.5-rc1>
> *Introducing commit:  *
> https://github.com/torvalds/linux/commit/cab47333f0f75b685bce1facecb73bf3632e1360
> 
> Then the risk is quite low, right? SPI busses are not user hot-pluggable
>> except some development boards (so again a real niche). Basically it's
>> impact is negligible
>>
> Agreed.
> 
> What does it mean "remote device"? NFC? NFC tag does not talk over SPI...
>>
> I was wondering maybe the tag is the source for the content that actually
> overflows the kernel buffer,
> In which case it changes the picture a bit.

The buffer is used for SPI transfer, so the NFC tag - except that it
works with that device - is rather long shot.


Best regards,
Krzysztof
