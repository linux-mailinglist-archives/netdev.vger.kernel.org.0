Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 077A219B683
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 21:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732669AbgDATos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 15:44:48 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:33404 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732314AbgDATos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 15:44:48 -0400
Received: by mail-il1-f194.google.com with SMTP id k29so1245552ilg.0
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 12:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dMitRcdeMSgR41kZoY5zsFRfUziC2C0G3PVuFqFOiLI=;
        b=u/dmKdJhlfmAN2bTLr3r6kTbcyymnzw9e9+YbKgpSsBwe2ATN8zQJ3vxb/yJxpmxmY
         dLMVNBaWcC7VxA3WZXCOx6dvXRuhXj3nWYJG++B7GV0T3fZoGvPV2dGNM/oMfe9Di5wm
         uru2cfNrwaJ57UtsUYADY9Rd9RBsLDQtxRttndz9G/w6Lg0vkWRKxw62dwh4LiQShIvc
         4OVSVO7seqvcNFTGL796rXFHZKkeM3DEbfWnBIhUxWRPiLGiJUwG9obks03oMW85b0oY
         yMHerCmf9wrKbYzblUqyARqgnnhaclyhZeCswooOW27VWUHcdHEoSca4sGkBYGd27H5d
         p9Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dMitRcdeMSgR41kZoY5zsFRfUziC2C0G3PVuFqFOiLI=;
        b=WwNjsNJNo19bbSfjygmHGOT7r/SFbi7ybcBChUzT1onhLyFC0EiC55tMP9RVumR1Ou
         Hl5ejE5Qm2ACGksgwQovWdWRljF3Vj3BV6emimTyREEEfG3VmGBXX877Vs6BbxrZghbj
         NmCEMuXTf/zbXXvLUrD+1hV8Asudbh3PYBNeFOM08YwR4WEC0eC3AJduDk4jpHO93WHh
         Dj0BdQkXdsN5vOmOjFIDPUCR3QiDL2RqhKAwY4Dd7slNV7lpU2E8ML3dI6rKiQJsrXLN
         uPzN+VJYUUl8Kxnc3oCOOr6r2QViBK01cZySDis+c7EQLXCxTruZH2VRsQg7y2oOFEui
         eSvg==
X-Gm-Message-State: ANhLgQ18nCNIB7JOZW93uQpZQE5AxC2Md3Bl0UZrH8PcCJGeRMDjCk9K
        8hCxZxkxTOOeW6Us4tKmz8eN6w==
X-Google-Smtp-Source: ADFU+vv6gM2W9Al7wSbRGq6lK0fdMsCJr3NrEvCQKv0kVf4YbgNiCh1CoBVCByVfkaCPoLN4WIoSkw==
X-Received: by 2002:a92:8cc7:: with SMTP id s68mr23999899ill.268.1585770285630;
        Wed, 01 Apr 2020 12:44:45 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id z13sm830881ioh.16.2020.04.01.12.44.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2020 12:44:44 -0700 (PDT)
Subject: Re: [PATCH v3] bitfield.h: add FIELD_MAX() and field_max()
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Maxim Kuvyrkov <maxim.kuvyrkov@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
References: <20200311024240.26834-1-elder@linaro.org>
 <20200401173515.142249-1-ndesaulniers@google.com>
 <3659efd7-4e72-6bff-5657-c1270e8553f4@linaro.org>
 <CAKwvOdn7TpsZJ70mRiQARJc9Fy+364PXSAiPnSpc_M9pOaXjGw@mail.gmail.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <3c878065-8d25-8177-b7c4-9813b60c9ff6@linaro.org>
Date:   Wed, 1 Apr 2020 14:44:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAKwvOdn7TpsZJ70mRiQARJc9Fy+364PXSAiPnSpc_M9pOaXjGw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/1/20 2:13 PM, Nick Desaulniers wrote:
> On Wed, Apr 1, 2020 at 11:24 AM Alex Elder <elder@linaro.org> wrote:
>>
>> On 4/1/20 12:35 PM, Nick Desaulniers wrote:
>>>> Define FIELD_MAX(), which supplies the maximum value that can be
>>>> represented by a field value.  Define field_max() as well, to go
>>>> along with the lower-case forms of the field mask functions.
>>>>
>>>> Signed-off-by: Alex Elder <elder@linaro.org>
>>>> Acked-by: Jakub Kicinski <kuba@kernel.org>
>>>> ---
>>>> v3: Rebased on latest netdev-next/master.
>>>>
>>>> David, please take this into net-next as soon as possible.  When the
>>>> IPA code was merged the other day this prerequisite patch was not
>>>> included, and as a result the IPA driver fails to build.  Thank you.
>>>>
>>>>   See: https://lkml.org/lkml/2020/3/10/1839
>>>>
>>>>                                      -Alex
>>>
>>> In particular, this seems to now have regressed into mainline for the 5.7
>>> merge window as reported by Linaro's ToolChain Working Group's CI.
>>> Link: https://github.com/ClangBuiltLinux/linux/issues/963
>>
>> Is the problem you're referring to the result of a build done
>> in the midst of a bisect?
>>
>> The fix for this build error is currently present in the
>> torvalds/linux.git master branch:
>>     6fcd42242ebc soc: qcom: ipa: kill IPA_RX_BUFFER_ORDER
> 
> Is that right? That patch is in mainline, but looks unrelated to what
> I'm referring to.
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6fcd42242ebcc98ebf1a9a03f5e8cb646277fd78
> From my github link above, the issue I'm referring to is a
> -Wimplicit-function-declaration warning related to field_max.
> 6fcd42242ebc doesn't look related.

I'm very sorry, I pointed you at the wrong commit.  This one is
also present in torvalds/linux.git master:

  e31a50162feb bitfield.h: add FIELD_MAX() and field_max()

It defines field_max() as a macro in <linux/bitfield.h>, and
"gsi.c" includes that header file.

This was another commit that got added late, after the initial
IPA code was accepted.

>> I may be mistaken, but I believe this is the same problem I discussed
>> with Maxim Kuvyrkov this morning.  A different build problem led to
>> an automated bisect, which conluded this was the cause because it
>> landed somewhere between the initial pull of the IPA code and the fix
>> I reference above.
> 
> Yes, Maxim runs Linaro's ToolChain Working Group (IIUC, but you work
> there, so you probably know better than I do), that's the CI I was
> referring to.
> 
> I'm more concerned when I see reports of regressions *in mainline*.
> The whole point of -next is that warnings reported there get fixed
> BEFORE the merge window opens, so that we don't regress mainline.  Or
> we drop the patches in -next.

Can you tell me where I can find the commit id of the kernel
that is being built when this error is reported?  I would
like to examine things and build it myself so I can fix it.
But so far haven't found what I need to check out.

Thank you.

					-Alex
