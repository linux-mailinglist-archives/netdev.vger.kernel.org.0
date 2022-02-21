Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 762424BEAAC
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 20:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbiBUS1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:27:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233351AbiBUS0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:26:12 -0500
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA392BB3F;
        Mon, 21 Feb 2022 10:22:07 -0800 (PST)
Received: by mail-qv1-xf29.google.com with SMTP id v10so34127374qvk.7;
        Mon, 21 Feb 2022 10:22:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=00FTKimPfYzBMP/rJrScDVkcWdLsN3tbxLeb3b/ES0s=;
        b=f/pW1i/dFqsLzxJb4ANxGPQRtMAC59EizWVN6kf7QbwY5AK1/8/yTYqW3ow0gyijNq
         yyR8Namv+HXL1ZvPk+540pdUJbR6XTjwbJjeg9ikTtgSecQhpmFN1miIrfRDEHrV7/yd
         sGgJ6F7Zdxv5r+jWbpY4jsnlKY0yKa/sCuQvieKjfFrssg4q4QFg0BX5xh/78YftUfBz
         m1DLzToCUf79gxzJYlipyuFF7DK5my99sbyGXPw662GqXYGZZ4rBFJ45VRy+ojZbkRze
         i/QYXveyUsZjM0MAnrT02OqmplJStMzTXSny5SIZNxFzXfadDtQ2SF0yekFfY/w8B5Q6
         l6gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=00FTKimPfYzBMP/rJrScDVkcWdLsN3tbxLeb3b/ES0s=;
        b=Pax01EDpOYzhEbrBMugrai8GxnWZyaPFCNYzC2Et2sPNF2lWC8YGkv4AgNzjq0wRvt
         +Vwl+NzZqE580d1qIZzAR2hbOBi95ZhfzElPXcX4T4wE9hVnkqhi52Huef5OlNcOG3or
         /jJXMbFb8BoN4SHZhZNpEh1ZfJIkn8fiLbJw7JX2MpfiGLiN+iAQkhCRb8O5B2Hqd5y1
         wsPYXT6r1OmosNv+5SB+Ha5xB6Dp/TOcPAaNCA8q9IyJoIYW2MjwEeyudUxBvdPBLhvf
         uo8wkTU+wjWty0UaMAQM+mVO4ILR2oYC8ykOYnuJ5/ewHcCF13tj2WB2dLcV1evs+qdk
         kLsw==
X-Gm-Message-State: AOAM530fSKyjus7W7pI8f7PPTb0Cv6uWtc8Rd5dlQd47zdSwo1fxKbjb
        GAz/3QuKQJb+o4+DV8uy+hgi3iYSjqF96A==
X-Google-Smtp-Source: ABdhPJy23lpHcWTjqGEIqFsr4qmnMTgvKFWLXKDugiNIPGMhCo0OKMkJUGfjTFteSoQw5vkRARzF8g==
X-Received: by 2002:a05:622a:1a16:b0:2de:37ad:25ef with SMTP id f22-20020a05622a1a1600b002de37ad25efmr3009578qtb.131.1645467725594;
        Mon, 21 Feb 2022 10:22:05 -0800 (PST)
Received: from [120.7.1.38] (198-84-206-107.cpe.teksavvy.com. [198.84.206.107])
        by smtp.gmail.com with ESMTPSA id e1sm22491435qtw.71.2022.02.21.10.22.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 10:22:05 -0800 (PST)
Subject: Re: Linux 5.17-rc5
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
References: <CAHk-=wgsMMuMP9_dWps7f25e6G628Hf7-B3hvSDvjhRXqVQvpg@mail.gmail.com>
 <8f331927-69d4-e4e7-22bc-c2a2a098dc1e@gmail.com>
 <CAHk-=wiAgNCLq2Lv4qu08P1SRv0D3mXLCqPq-XGJiTbGrP=omg@mail.gmail.com>
 <CANn89iJkTmDYb5h+ZwSyYEhEfr=jWmbPaVoLAnKkqW5VE47DXA@mail.gmail.com>
 <CAHk-=wigDNpiLAAS8M=1BUt3FCjWNA8RJr1KRQ=Jm_Q8xWBn-g@mail.gmail.com>
From:   Woody Suwalski <wsuwalski@gmail.com>
Message-ID: <7b1a0613-810f-3406-89b3-10d45f3a1b7b@gmail.com>
Date:   Mon, 21 Feb 2022 13:22:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:68.0) Gecko/20100101 Firefox/68.0
 SeaMonkey/2.53.10.2
MIME-Version: 1.0
In-Reply-To: <CAHk-=wigDNpiLAAS8M=1BUt3FCjWNA8RJr1KRQ=Jm_Q8xWBn-g@mail.gmail.com>
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

Linus Torvalds wrote:
> On Mon, Feb 21, 2022 at 10:02 AM Eric Dumazet <edumazet@google.com> wrote:
>> I am pretty sure Pablo fixed this one week ago.
> .. looks about right. Apart from the "it was never sent to me, so -rc5
> ended up showing the problem" part.
>
>               Linus
Patch works-for-me. Thanks...
Woody

