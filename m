Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3DF45804D
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 21:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbhKTU1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 15:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhKTU1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 15:27:39 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E29C061574
        for <netdev@vger.kernel.org>; Sat, 20 Nov 2021 12:24:35 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id bi37so60188943lfb.5
        for <netdev@vger.kernel.org>; Sat, 20 Nov 2021 12:24:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Df3LOuh6MHrKPYh3o8WBZaAZwF8NVwbkkuqGYj/XP3o=;
        b=dijW72jwWHrz+IdSgHorq8NUX3a/nzZVP0XgEQpFUvCi2sRrcLX3/pd4PJqr/lax/c
         Zt451jGzF5lSukNK8Z6se+bNdOqLMbfMNd8oyjSPq7CJ655HaiAXY0FkyVWULqTArc47
         19jNTtTqmpcuzscHQACrtXmSgslTID6b0SKbEgTf/iVa9+NBn3JoEro88I2myhWHJpgY
         Ic37/OhV8QiMhNTPasaG5FSA6rwRxZXh8EJT1HLwGjkjLZqbX/NFhslINt7Il4deYTUP
         aBb7QFgOMVnm4JPFNteKgqCtN5G9/ks3RGKYZACwIKzKrhHdtbXboMESYHukSoY6LBKN
         qfpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Df3LOuh6MHrKPYh3o8WBZaAZwF8NVwbkkuqGYj/XP3o=;
        b=SwDo8DZSjK6vkbG0Ea9FXuf4YnapyKlbZa9g1Kk92ko8bLlvJbNQeMOSR1A3uRsHDl
         vc4WRtdD0o1bwQP5mNhEEkczEBO3CrpLEAx3aYAK/rVj2eSiDM8fmidZjatNGE4jhO6K
         7D4oDo+Fvoca2QMDmmArZYVkCz7raNQPVH3+DocQF1HN8bvH6lj9GrX268Y/vDPa/WTK
         ORiBvBDLUBzzKAoB++TsVEnM+VrB3BZGMXFkMvxrnoiqUvQT1i+k2ehh0ggihI2fdZ74
         MBf4s+KtZR1qZzthv16tNIz2SvVdWqe9rbkywkPv4UHNFtB1Ty0PoQ4gnpEvmaTiE806
         mtZg==
X-Gm-Message-State: AOAM5320OVUSx9vcFEXJt1MbfBJeNzifFHCUNP4uyspfcck69WhJgKRa
        EX8+3bl5dFMg45PNHsOI8A4yjagjt/4=
X-Google-Smtp-Source: ABdhPJxcLwAylnvNITyWBPRXbM2iNol/+34VmNov+xPbnZCNDfJ0HrEkwO844KXusWE+2sG3h5uCJQ==
X-Received: by 2002:a05:6512:21cb:: with SMTP id d11mr42184355lft.579.1637439873817;
        Sat, 20 Nov 2021 12:24:33 -0800 (PST)
Received: from [192.168.42.14] ([176.59.10.41])
        by smtp.gmail.com with ESMTPSA id p3sm431289lfg.273.2021.11.20.12.24.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Nov 2021 12:24:33 -0800 (PST)
Subject: Re: [PATCH iproute2] Add missing headers to the project
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
References: <a8892441-c0a7-68b2-169e-ae76af0027ad@gmail.com>
 <20211120092637.1e21418a@hermes.local>
From:   Maxim Petrov <mmrmaximuzz@gmail.com>
Message-ID: <aae5da96-556f-a333-87b1-d6a90a827665@gmail.com>
Date:   Sat, 20 Nov 2021 23:24:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211120092637.1e21418a@hermes.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Stephen!

On 11/20/21 8:26 PM, Stephen Hemminger wrote:
> Would be better to do this with an existing tool like IncludeWhatYouUse
> Is this what you did?

This is my fault, I didn't even think about searching for any existing tools for
this task. :)

I just wrote a stupid loop over the header files like this:

```bash
for hdr in $(find . -name *.h)
do
	printf '#include "%s"' $hdr > headertest.c
	gcc headertest.c -c -I ./include -I ./include/uapi
done
```

and then manually patched the files until there are no compilation errors.

It seems like I reinvented the wheel and did it not so good. I targeted only
header files and fixed only compilation errors, possibly keeping some transitive
includes. IWYU looks much better as it targets usage, not just compilation
errors. If you can run this tool and fix the whole project automagically, then
it is better to ignore my patch. Anyway, thank you for the information, I will
definitely try IWYU soon.

Max
