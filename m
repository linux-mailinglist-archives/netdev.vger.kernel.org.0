Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37F5B388170
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 22:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240387AbhERUer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 16:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236628AbhERUeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 16:34:46 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFEA4C061573;
        Tue, 18 May 2021 13:33:27 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id b9-20020a17090a9909b029015cf9effaeaso2223140pjp.5;
        Tue, 18 May 2021 13:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=GN6h5fvI363WSrqcaInFPCBwD3gDjCXT4u6SzhBf8Sg=;
        b=qotCojRtv0T+bojfNb2H2U5CLbIKwTebfLzTGiF7+FTwl1DBa+XCbQSxLlNKygPQqo
         VrAhLkGq+pIsI5fJCvLrFvvSzhRadmT8cSA5QRRlUSD7+/F80SalKVvpP0Oe8zMIgHPn
         TX4rCT2c5+KRq7vgQ+wmDJ0KT9g8Fiz7Jia6WaDoBnbn1xKtYPheUNdDHWDxB+hAU66R
         G1YsuspLMOlNhYmIit9UCfa5bVym6JQGVhrxpVilOdN5q0thWPu1B6ASZeXmXs2xKpfM
         GoC/hPrs3jxEdMkQC9E0WG50Bl/duCE9ujrTEje510XD2obDc/AjTTFqzR3dvOZmROWf
         0Kkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=GN6h5fvI363WSrqcaInFPCBwD3gDjCXT4u6SzhBf8Sg=;
        b=DUjp8R/wRXDZAP896LCIT83WYxe6sKFZDRorcANEQNgollE44Kt6UC2b6wJOS+cLxJ
         LzmN/l1bd9pM+S8sG7a61V99iH/N/97BXGv/xyuJ9JlmQ3M+8hpCO01NgZD/Wa68TVtF
         9lo+2ddFoKyMw7IrszYpZv9btJKOFT1ImDQY9CrgoXm3lIfFRys4xsPFuziSNXZvnwtI
         JaD3N3MvYd5SqMhKp7nqWd+b/t/8zutrznicpJvBBPzE/LnHDUSvpX5XpDcFJIUKK4st
         pBZK0u+vB1hjVNElHgpJIOlnJ5dIhCRZCj3qS/ZfjrColvY5jsh8GyQY2aXectgrdO/b
         ZJmA==
X-Gm-Message-State: AOAM530o9oeRDGLXPW6cwoCYqobSw3bbTebl2BnSL1QZ2HOiDQeEPzZz
        +/axedMC9/Nf/fAe6cm8PXUuACPBhAY=
X-Google-Smtp-Source: ABdhPJz9aYeB9fb300Jnk91j6iYa3CdvG4ahR73oJTvbuHkztiW4U5Op4eeONq6wJbnA92ivLTHAPg==
X-Received: by 2002:a17:902:dccc:b029:f3:fb40:8752 with SMTP id t12-20020a170902dcccb02900f3fb408752mr2018888pll.83.1621370007523;
        Tue, 18 May 2021 13:33:27 -0700 (PDT)
Received: from ?IPv6:2001:df0:0:200c:a4c8:5d58:3d8c:ad8f? ([2001:df0:0:200c:a4c8:5d58:3d8c:ad8f])
        by smtp.gmail.com with ESMTPSA id 191sm1794843pfx.121.2021.05.18.13.33.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 May 2021 13:33:26 -0700 (PDT)
Subject: Re: [PATCH 2/2] net-next: xsurf100: drop include of lib8390.c
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Networking <netdev@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        kernel@mkarcher.dialup.fu-berlin.de
References: <CAMuHMdVfjE=+YiqCrPfGObeYYkQwKGiQEWyprQr-n9z7J9-X-A@mail.gmail.com>
 <1528604559-972-3-git-send-email-schmitzmic@gmail.com>
 <CAK8P3a0pH0V_y-Ayt0rTNgZGR+Rm6tVRSzjCbo_vuA97c4shkA@mail.gmail.com>
 <83400daa-d5a4-b39d-bd05-544a29065717@gmail.com>
 <CAK8P3a3_2yN374Z6Nbybvs9noxoK9y_c=_6NHxWJU4RK4+Yyhw@mail.gmail.com>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <9a7b0375-2c3f-d1ef-7aa5-5d7fbddcd8eb@gmail.com>
Date:   Wed, 19 May 2021 08:33:21 +1200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a3_2yN374Z6Nbybvs9noxoK9y_c=_6NHxWJU4RK4+Yyhw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Arnd!

Cheers,

     Michael

On 19/05/21 1:56 am, Arnd Bergmann wrote:
> On Tue, May 18, 2021 at 10:42 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
>> Which reminds me to check how far we ever got with testing the XSurf500
>> driver that's still stuck in my tree.
>>
>>> Alternatively, I can include them in my series if you like.
>> Please do that - I haven't followed net-next for over a year and don't
>> have a current enough tree to rebase this on.
> Ok, done. I'll send the series once net-next opens for 5.14.
>
>         Arnd
