Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305825BE641
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 14:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbiITMuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 08:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbiITMuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 08:50:21 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAF261B12
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 05:50:19 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id d16so1287261ils.8
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 05:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=zQKgQ4HqE6wGzsyWaju9zoDk2+yG62YwCmFP6Uq7Ybg=;
        b=fYLN3d+bXN+MueTMze9Q8X6v353Up/GFFmi+EjF1hMneXt78kSyeeghELK0zuJJdpq
         2zvNjmPJKy2mSaeouPbyeWFtS8LlFQOFGnFm4WG3pJ0BtfFigTNSy+gXCamnBgOsvlB8
         ZTEVV7RLxC8QQ/35ydv4daofvisKRz7d7Z7zb7+Z6D2ZaFwsHGLsJKs0OYwkytdSM8s8
         CUD4l/yiG3v/UXDrsC+7Il+CRkWbumwBWzFAjEJakWmbeJXPvreJvXGXiix1fg4OQHDb
         BOGS4insDNyJ0dCu88LWA5Y9iIDjNVoIZ6lgV5/wAGhxVQZJbM4Hk/4IPQwfv3nyGUTd
         LJ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=zQKgQ4HqE6wGzsyWaju9zoDk2+yG62YwCmFP6Uq7Ybg=;
        b=VcSpI7UCzK1klLGxFO6IKxjjaIfsjyR1uyutfSenFl1s9Ry+TQXNiYrQe/Ty2wPeDD
         KZxHXAtHVXm/PhjuVEWIelRVb82OH7KgJU/qStubTpRRHWx6alkCqTwMFa6/98D4vHif
         hchRQ8lemb5BszKeHj+EIXxKf9gD58pM3kmcc9Tc1WNhmYQmVOY01afxJ6j4kwjOjL6o
         P7Af7bpmBIWwOV+V03c/Jbh01RIvB27+iCCY6Tgik6IBFyBeoWUnI6K6MHpQitL4MK+R
         JTCMGDRqBj/uiVRn8iphBcq3qFX7HswPS/RPzY/xEm+oVppt5fw7ruSUFgohq5HhhgXS
         QRXQ==
X-Gm-Message-State: ACrzQf3wJjx+L9Y2oIjQteOMZUxIPzE6qiQjhBj0vBuPgkueQWA4FVz8
        E+ORi5XzM/qbRbKa0nhfpd/ZUOp/PGNdK89A
X-Google-Smtp-Source: AMsMyM5zr3Cun3OYjYJC8x4bIwCaiiqupw70+97apWEch/GHkgE7BtksNT5A+S9+j+89fT61O9fv5g==
X-Received: by 2002:a92:c543:0:b0:2f5:ae52:a023 with SMTP id a3-20020a92c543000000b002f5ae52a023mr4533245ilj.118.1663678218268;
        Tue, 20 Sep 2022 05:50:18 -0700 (PDT)
Received: from [172.22.22.4] ([98.61.227.136])
        by smtp.googlemail.com with ESMTPSA id y11-20020a056602178b00b00688b30a7812sm31398iox.42.2022.09.20.05.50.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 05:50:17 -0700 (PDT)
Message-ID: <b26912a7-0770-4b1f-4cf4-bed81298cbdb@linaro.org>
Date:   Tue, 20 Sep 2022 07:50:16 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next 3/6] net: ipa: move and redefine
 ipa_version_valid()
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220910011131.1431934-1-elder@linaro.org>
 <20220910011131.1431934-4-elder@linaro.org>
 <d98d439ef5ee8a1744481bf1f076fbed918c3cef.camel@redhat.com>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <d98d439ef5ee8a1744481bf1f076fbed918c3cef.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/20/22 3:29 AM, Paolo Abeni wrote:
> On Fri, 2022-09-09 at 20:11 -0500, Alex Elder wrote:
>> Move the definition of ipa_version_valid(), making it a static
>> inline function defined together with the enumerated type in
>> "ipa_version.h".  Define a new count value in the type.
>>
>> Rename the function to be ipa_version_supported(), and have it
>> return true only if the IPA version supplied is explicitly supported
>> by the driver.
> 
> I'm wondering if the above is going to cause regressions with some IPA
> versions suddenly not probed anymore by the module?

That is a really good observation.

The way versions are handled is a little bit inconsistent.  The
code is generally written in such a way that *any* version could
be used (between a certain minimum and maximum, currently 3.0-4.11).
In other words, the *intent* in the code is to make it so that
quirks and features that are version-specific are handled the right
way, even if we do not (yet) support it.

So for example the inline macro rsrc_grp_encoded() returns the
mask to use to specify an endpoint's assigned resource group.
IPA v4.7 uses one bit, whereas others use two or three bits.
We don't "formally" support IPA v4.7, because I (or someone
else) haven't set up a Device Tree file and "IPA config data"
to test it on real hardware.  Still, rsrc_grp_encoded() returns
the right value for IPA v4.7, even though it won't be needed
until IPA v4.7 is tested and declared supported.

The intent is to facilitate adding support for IPA v4.7 (and
others).  In principle one could simply try it out and it should
work, but in reality it is unlikely to be that easy.

Finally, as mentioned, to support a version (such as 4.7) we
need to create "ipa_data-v4.7.c", which defines a bunch of
things that are version-specific.  Because those definitions
are missing, no IPA v4.7 hardware will be matched by the
ipa_match[] table.

So the answer to your question is that currently none of the
unsupported versions will successfully probe anyway.

> Additionally there are a few places checking for the now unsupported
> version[s], I guess that check could/should be removed? e.g.
> ipa_reg_irq_suspend_en_ee_n_offset(),
> ipa_reg_irq_suspend_info_ee_n_offset()
> ...

I'm a fan of removing unused code like this, but I really would
like to actually support these other IPA versions, and I hope
the code is close to ready for that.  I would just need to get
some hardware to test it with (and it needs to rise to the top
of my priority list...).

Does this make sense to you?

Thank you very much for taking the time to review this.

					-Alex

> Thanks,
> 
> Paolo
> 

