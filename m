Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83A01AC36F
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 01:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393250AbfIFXwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 19:52:13 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36342 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732440AbfIFXwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 19:52:13 -0400
Received: by mail-lj1-f194.google.com with SMTP id l20so7523888ljj.3
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 16:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7gt+dprtIaWWWiehpVBpT9gjTU5sJKWHbohiXhkeDVw=;
        b=N8apvxEuyAMDm7IdWzHrNax6Ft6Lvj8/T5bGsnuBYBtBJ5220TDZcpKa/hGVGfOAHk
         oloaJcf7HJINFllAa8ld9Vm/vwaHXJCNdjdU3jX3LY2J83sYJMHZLqDnN/LzOpY1Wqf4
         gXWFd7YiKBxu+RyqKpqecrgh2H0RVgIVuybb9Jg2GV6XXGaYImkOrd6BhLOiByqE+pYS
         3i2TeTS9cvlSA1odIj+9mEqPiVH/fuRdT2gy+pCu4aA1pWyjAwZw+4I3F4wNPeLxZfX2
         QqmHBqKAV3MpPRe2IeOcum5xzZmiAxpUX/8nMZfJeNXM2p0zHBpMMa96l7uVfATdoEuo
         83bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=7gt+dprtIaWWWiehpVBpT9gjTU5sJKWHbohiXhkeDVw=;
        b=d05UAlGKd8IRPFowR5oiPnK00M2bLbFJ9sOD5gDd6+oHUGhhdl2WRffBopj90LV1D7
         bRiUqiif3SG2qUOE8uxs2Mx5UAVJlNr1TpHT/EBoHuiSsX+XUidKTPpjQjUsdhuSnptg
         6eQb7nhDNDUB4hQJfkodq7J/1McCXZbFoctS3kgd39oWl8zik+xvTwCpIvPJ1FcgXXXl
         3gyD05HV7jPAFvG8jAGVr06+ohdc8Jq19NEnkRfachX/IOvY5s1JbR/XXYXcVAvqIn3t
         rj8KK6LFUYEFq+6QuKeBGV0buWh9qDx81D5sAoqMswTc8U4jwwoEfk+1d7upM2VAtlvz
         W4Tg==
X-Gm-Message-State: APjAAAXHpmb8/YthnxZlhOXZ3LY0A4FBMJKUHA2HpNN2cKyVnrswd7q2
        4V+N133tT6EJl7SSsYm0GWpR4g==
X-Google-Smtp-Source: APXvYqzks9jN+Vc+WCVfIT3Izxu7CuU+7cTYAXJzMrP6IaIIHCaeKcyAscaFaspGG5UANI+GaQJ7fg==
X-Received: by 2002:a2e:b4db:: with SMTP id r27mr7238028ljm.110.1567813931698;
        Fri, 06 Sep 2019 16:52:11 -0700 (PDT)
Received: from khorivan (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id t5sm1408113lfl.91.2019.09.06.16.52.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 06 Sep 2019 16:52:11 -0700 (PDT)
Date:   Sat, 7 Sep 2019 02:52:08 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH bpf-next 2/8] samples: bpf: Makefile: remove target for
 native build
Message-ID: <20190906235207.GA3053@khorivan>
Mail-Followup-To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com
References: <20190904212212.13052-1-ivan.khoronzhuk@linaro.org>
 <20190904212212.13052-3-ivan.khoronzhuk@linaro.org>
 <20190906233138.4d4fqdnlbikemhau@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190906233138.4d4fqdnlbikemhau@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 06, 2019 at 04:31:39PM -0700, Alexei Starovoitov wrote:
>On Thu, Sep 05, 2019 at 12:22:06AM +0300, Ivan Khoronzhuk wrote:
>> No need to set --target for native build, at least for arm, the
>> default target will be used anyway. In case of arm, for at least
>> clang 5 - 10 it causes error like:
>>
>> clang: warning: unknown platform, assuming -mfloat-abi=soft
>> LLVM ERROR: Unsupported calling convention
>> make[2]: *** [/home/root/snapshot/samples/bpf/Makefile:299:
>> /home/root/snapshot/samples/bpf/sockex1_kern.o] Error 1
>>
>> Only set to real triple helps: --target=arm-linux-gnueabihf
>> or just drop the target key to use default one. Decision to just
>> drop it and thus default target will be used (wich is native),
>> looks better.
>>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>> ---
>>  samples/bpf/Makefile | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
>> index 61b7394b811e..a2953357927e 100644
>> --- a/samples/bpf/Makefile
>> +++ b/samples/bpf/Makefile
>> @@ -197,8 +197,6 @@ BTF_PAHOLE ?= pahole
>>  ifdef CROSS_COMPILE
>>  HOSTCC = $(CROSS_COMPILE)gcc
>>  CLANG_ARCH_ARGS = --target=$(notdir $(CROSS_COMPILE:%-=%))
>> -else
>> -CLANG_ARCH_ARGS = -target $(ARCH)
>>  endif
>
>I don't follow here.
>Didn't you introduce this bug in patch 1 and now fixing it in patch 2?
>

It looks like but that's not true.
Previous patch adds target only for cross compiling,
before the patch the target was used for both, cross compiling and w/o cc.

This patch removes target only for native build (it's not cross compiling).

By fact, it's two separate significant changes.

-- 
Regards,
Ivan Khoronzhuk
