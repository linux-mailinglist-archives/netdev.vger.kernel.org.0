Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2A43FD433
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 09:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242493AbhIAHIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 03:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242472AbhIAHIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 03:08:37 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B446C061575;
        Wed,  1 Sep 2021 00:07:40 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id s12so3274671ljg.0;
        Wed, 01 Sep 2021 00:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tkBnSZ8tPceYf/KAGSxnZEdY1ZtMechZKaYpAIYU2LU=;
        b=JpZndJyO+xZ+tPnCYMD2xifEVddZnLPmd+brJFxJkwgMGOki8Lmrj1E5wmSr96IMF2
         S2Apqee7gU620BrjYj372ooKP+8t9+eOpanhgTbBXxuyW1S1QJdek8diuRmJnZWBSHP0
         f8x73VwBsyNvw8onW+48c7JbZjT/DCDNyA0vsq7xZocBUOVHgMuHajEYEwa4rQrzualO
         pFJGL87zIX0WAtdWO9FdmeIubO/opQkioRArXx5apfDvDl7UbupTCfjwlIOa/IS1hozI
         YIiI68VsoRZf5cZRnVcWpLbvJcpgHr+p8mRnRd7DYMOuMqGgRGDcpwiNgsUOa00/uAss
         1fDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tkBnSZ8tPceYf/KAGSxnZEdY1ZtMechZKaYpAIYU2LU=;
        b=WDOpA3ktNUIuYvIMCmmwZ4okXhrY8s0+LBZIuRAROXJzYNpaox0oMdedmmvfQDMB0j
         vStLcM9v19o3JtqstDUZtmPT0jnmVNdjrB+vfnBiV0/egQsFIc6YUlN6QVIkVCD0TYPh
         b9kIN0k0cfj1dmemCNMYO/8CoybEGclGwCkgLgnDQ+5o1r5cNAaeZDnsIuAPBiENXGEU
         81InCLsqZE7+70WLa2sc8fzUDYPhp8D1gNv/C1OPInDc28+ezdg03ALWtEooH8hW6tyR
         QD4J250Veggd3hxNu2C6Pf1B6ED174BjPwWkimp/C7IxYVVMmbN/n57p545FdPS2oQjz
         sQ+Q==
X-Gm-Message-State: AOAM533hbgdBmZy6E7VDGzenOBmZVhuv26VvQ9ldcUX3BVi4buDnJAsr
        s4YIRLHZbxtdp/z+BdeV4ObIB/673vur9E5l
X-Google-Smtp-Source: ABdhPJzBtCI4VowD9Iwme8UWUOdfX0tOvBmQwSrdCZKL4TslD81zSa8XW6GbUD12UflGAFZbRun0ew==
X-Received: by 2002:a05:651c:2120:: with SMTP id a32mr28497251ljq.252.1630480058455;
        Wed, 01 Sep 2021 00:07:38 -0700 (PDT)
Received: from [10.0.0.40] (91-155-111-71.elisa-laajakaista.fi. [91.155.111.71])
        by smtp.gmail.com with ESMTPSA id j5sm1942288lfu.1.2021.09.01.00.07.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 00:07:37 -0700 (PDT)
Subject: Re: [PATCH] kconfig: forbid symbols that end with '_MODULE'
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Kalle Valo <kvalo@codeaurora.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.com>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, Networking <netdev@vger.kernel.org>
References: <20210825041637.365171-1-masahiroy@kernel.org>
 <9df591f6-53fc-4567-8758-0eb1be4eade5@gmail.com>
 <CAK7LNATDMzR1DnwwAcQFHaKZeGVYDZ1oDKL-QOe_7DaB_yByAA@mail.gmail.com>
From:   =?UTF-8?Q?P=c3=a9ter_Ujfalusi?= <peter.ujfalusi@gmail.com>
Message-ID: <d9e777dc-d274-92ee-4d77-711bfd553611@gmail.com>
Date:   Wed, 1 Sep 2021 10:07:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAK7LNATDMzR1DnwwAcQFHaKZeGVYDZ1oDKL-QOe_7DaB_yByAA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 26/08/2021 05:28, Masahiro Yamada wrote:
> On Wed, Aug 25, 2021 at 8:59 PM Péter Ujfalusi <peter.ujfalusi@gmail.com> wrote:

...

>>> diff --git a/sound/soc/ti/Kconfig b/sound/soc/ti/Kconfig
>>> index 698d7bc84dcf..c56a5789056f 100644
>>> --- a/sound/soc/ti/Kconfig
>>> +++ b/sound/soc/ti/Kconfig
>>> @@ -211,7 +211,7 @@ config SND_SOC_DM365_VOICE_CODEC
>>>         Say Y if you want to add support for SoC On-chip voice codec
>>>  endchoice
>>>
>>> -config SND_SOC_DM365_VOICE_CODEC_MODULE
>>> +config SND_SOC_DM365_VOICE_CODEC_MODULAR
>>
>> This Kconfig option is only used to select the codecs needed for the
>> voice mode, I think it would be better to use something like
>>
>> SND_SOC_DM365_SELECT_VOICE_CODECS ?
> 
> I do not have a strong opinion.
> I am fine with any name unless it ends with _MODULE.
> 
> 
> The sound subsystem maintainers and Arnd,
> author of 147162f575152db800 are CC'ed.
> 
> If they suggest a better name, I'd be happy to adopt it.
> 

Can you resend (a separate patch would be even better) with
SND_SOC_DM365_SELECT_VOICE_CODECS

for sound/soc/ti/Kconfig ?

Thank you,
Péter
