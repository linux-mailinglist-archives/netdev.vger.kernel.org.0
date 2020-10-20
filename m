Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32B72937F9
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 11:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392785AbgJTJ1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 05:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391615AbgJTJ1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 05:27:48 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8C3C061755
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 02:27:47 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id e22so1665537ejr.4
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 02:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PxgZngH4K0i7hap3s+j68QYGxBsMIhq98RbhJPg+MGo=;
        b=qVggNb8CLSe0frJzMo5t1fAFp3ZBNqZHuhhjOA/MppoyHTRTbX9wb3lI02LuUx8TYz
         IBOFzGHCeQUmRdJLeOOE6saF6YYwM/t2ssRb7QGfnKxz7riQ1i02EqErOiQpnjjyE20T
         Vb5nXJRny78jlp5LxblGWXEOF0vAr2LoQOzObvNBAr/oU3C2fKEMiTv/GDtLncTjx/tD
         uLN2OHmOu+UJ/RweBA/F+6IlDIM2vMrIe/Wc4cohASrWtlhn56md6840WV709sFlsDlv
         XpaV57/ySsHqu0hJDnXVD/Mnxc2+iH50zwy2H+1LRksp+EA5hIywOI0IvhFmMCSK01ij
         V49g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PxgZngH4K0i7hap3s+j68QYGxBsMIhq98RbhJPg+MGo=;
        b=hVeXISYUwL/CCoPUaGmZi+LGHzKk42REoDf1gD2idSpfE3h5cJJ6/ilzd0GYyCGJBC
         WXsIfXPkfOYSe1pPwJe6xFo1M/+DhopJw6wmN6D7LZPIBWZJppFg7mnmVQDSzaFqbizz
         J14z29nEAJmKso4NrmuCWg+5/ZIh9m64Z0TNgGIu+XGJkhdgWplkZNiH52QfPKymygCA
         DUPawgqw1WRpBpz//efE3cc2jpsjiNZJOEqrUGB3Dx5loc1FlG2iLOgTgqjZilKCFlPz
         AmEGwuhOEUAmjJMlaweuVwa6L33Sjo3Jp1vVIDGQ157sCUgIDd7cdquhVL0FfogCvDWO
         wuqA==
X-Gm-Message-State: AOAM533JbfVslQ+Vnzkp0svv09hc/+miACFaCi2dRj3Sv0C+NPO3ZL/P
        BAyQme80p4XIvObByuI5wRUtmA==
X-Google-Smtp-Source: ABdhPJw0f/EKrjwZ1Ry+hSjxOriWoaKlahve1JDK7I9GpKxwxutt6/lLzYczBqJQAYlpyr4BWC0R/A==
X-Received: by 2002:a17:906:660f:: with SMTP id b15mr2296323ejp.333.1603186066538;
        Tue, 20 Oct 2020 02:27:46 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([2a02:578:85b0:e00:53fa:8da9:45da:8127])
        by smtp.gmail.com with ESMTPSA id js16sm1864960ejb.91.2020.10.20.02.27.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2020 02:27:45 -0700 (PDT)
Subject: Re: [PATCH] mptcp: MPTCP_KUNIT_TESTS should depend on MPTCP instead
 of selecting it
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, mptcp@lists.01.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20201019113240.11516-1-geert@linux-m68k.org>
 <1968b7a6-a553-c882-c386-4b4fde2d7a87@tessares.net>
 <CAMuHMdUDpVVejmrr3ayxnN=tgHrgDmUCVMG0VJht1Y-FUUv42Q@mail.gmail.com>
 <CAMuHMdWEKszUOA6Q9Y+vpLdRnq3wstCj1ubV=8iUKZAQkew_wg@mail.gmail.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <2945fd68-6323-30f1-db6b-9ed1dba582a6@tessares.net>
Date:   Tue, 20 Oct 2020 11:27:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <CAMuHMdWEKszUOA6Q9Y+vpLdRnq3wstCj1ubV=8iUKZAQkew_wg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

On 20/10/2020 09:40, Geert Uytterhoeven wrote:
> On Mon, Oct 19, 2020 at 10:38 PM Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> On Mon, Oct 19, 2020 at 5:47 PM Matthieu Baerts
>> <matthieu.baerts@tessares.net> wrote:
>>> On 19/10/2020 13:32, Geert Uytterhoeven wrote:
>>>> MPTCP_KUNIT_TESTS selects MPTCP, thus enabling an optional feature the
>>>> user may not want to enable.  Fix this by making the test depend on
>>>> MPTCP instead.
>>>
>>> I think the initial intension was to select MPTCP to have an easy way to
>>> enable all KUnit tests. We imitated what was and is still done in
>>> fs/ext4/Kconfig.
>>>
>>> But it probably makes sense to depend on MPTCP instead of selecting it.
>>> So that's fine for me. But then please also send a patch to ext4
>>> maintainer to do the same there.
>>
>> Thanks, good point.  I didn't notice, as I did have ext4 enabled anyway.
>> Will send a patch for ext4.  Looks like ext4 and MPTCP where the only
>> test modules selecting their dependencies.
> 
> FTR, "[PATCH] ext: EXT4_KUNIT_TESTS should depend on EXT4_FS instead
> of  selecting it"
> https://lore.kernel.org/lkml/20201020073740.29081-1-geert@linux-m68k.org/

Thank you for having sent this other patch and shared the link here!

Groetjes,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
