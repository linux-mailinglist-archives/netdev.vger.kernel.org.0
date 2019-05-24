Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB2DE29F3E
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 21:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391679AbfEXTmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 15:42:36 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39116 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732067AbfEXTmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 15:42:35 -0400
Received: by mail-wm1-f65.google.com with SMTP id z23so6226446wma.4
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 12:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7ZKt4HzYFcDf2yg0C4VsBGkjfbaFkQ+RxR3Cl/S0XJM=;
        b=ihHpz+z+2EcA1lvk37jbs8+ZrRj7t6Sse5ogGJnDSKSrAZvyvHRdR/p3klDA1nr1yy
         +eijUO+X0sT1b5Dk2RKvCub6IdzdUdp9XMmIqcwkrCDAvJ3rcVS4210Kg/KHASnvsNy/
         uNT9JxFwxPsj9COCHuRm5cvnmGZjzW9vFVRpzGgpNIrdMnEyiCdL3AhVPMuIqUV1Vlgm
         V9O45Mz1ogF8xexcSZXfCOUVOZ6pWrUusmu+f9ZXakESC5vjCigJqWQVcRNOSedCbD80
         xOrh/TAEywkPNyrQUuhpVYn525PMgmiq8+ZZxcNkanGSaGSUBhqA8W2FYSgb5BteYScv
         2N4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7ZKt4HzYFcDf2yg0C4VsBGkjfbaFkQ+RxR3Cl/S0XJM=;
        b=DERmrD9fcirz2sAF0V7WBtHQTli4lxIXNNg6kCRq53F+OmXMrD6bFSgqFX4Zo0ZCsZ
         HfQ3I7E72u+UCJuvnWR0JpkZEUNEiDZN9EVWbSxup0oIVdz6/kvk7slteyLbtRu0/cdk
         pWfFGwS33qONcwMn8jOlAeG7IyCQ5rFi4p5//WOUw59j8bETae1PhE/XSshvzs2EK+Wz
         MXbn7DdMjCiezX9rVjzR+mrf6zW4yS4eRgH6sEWc0oGA16SPeP9zcqM1Hvd9cARvdgJX
         5e3cZ/iOxHYbW2UwCqw4IksvEtNXuqGO6LcbvQfU6KizB6TLZ2eORXgYJl0nuwMplsPa
         P/og==
X-Gm-Message-State: APjAAAWPZ+yIGMYdnCy4ULgWKzYJURzCyaQDmGsK0nzXXJ0JJ2odNryt
        sccvPzHbss4CEn+lDfzkPDF5xA==
X-Google-Smtp-Source: APXvYqytqzpEeh9HMsa4eid45vx8maUunn69paHPzme9mNdlNdPLTfi8GSYg0HicmWsj1+XJ3cUoYA==
X-Received: by 2002:a05:600c:21d7:: with SMTP id x23mr17616241wmj.105.1558726952904;
        Fri, 24 May 2019 12:42:32 -0700 (PDT)
Received: from [192.168.1.2] ([194.53.186.20])
        by smtp.gmail.com with ESMTPSA id f10sm5086745wrg.24.2019.05.24.12.42.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 12:42:32 -0700 (PDT)
Subject: Re: [PATCH v2 bpf-next 11/12] bpftool/docs: add description of btf
 dump C option
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20190523204222.3998365-1-andriin@fb.com>
 <20190523204222.3998365-12-andriin@fb.com>
 <062aa21a-f14a-faf7-adf1-cd2e5023fc90@netronome.com>
 <CAEf4BzZSLSDv-Hr47HrrboDAscW166JCERGs6eRPijkCqzzb7g@mail.gmail.com>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Message-ID: <017b901f-f942-77dd-4d85-b8a7f9ee79a6@netronome.com>
Date:   Fri, 24 May 2019 20:42:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZSLSDv-Hr47HrrboDAscW166JCERGs6eRPijkCqzzb7g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-05-24 10:25 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> On Fri, May 24, 2019 at 2:14 AM Quentin Monnet
> <quentin.monnet@netronome.com> wrote:
>>
>> 2019-05-23 13:42 UTC-0700 ~ Andrii Nakryiko <andriin@fb.com>
>>> Document optional **c** option for btf dump subcommand.
>>>
>>> Cc: Quentin Monnet <quentin.monnet@netronome.com>
>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>> ---
>>>  tools/bpf/bpftool/Documentation/bpftool-btf.rst | 7 ++++++-
>>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/tools/bpf/bpftool/Documentation/bpftool-btf.rst b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
>>> index 2dbc1413fabd..1aec7dc039e9 100644
>>> --- a/tools/bpf/bpftool/Documentation/bpftool-btf.rst
>>> +++ b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
>>> @@ -19,10 +19,11 @@ SYNOPSIS
>>>  BTF COMMANDS
>>>  =============
>>>
>>> -|    **bpftool** **btf dump** *BTF_SRC*
>>> +|    **bpftool** **btf dump** *BTF_SRC* [**format** *FORMAT*]
>>>  |    **bpftool** **btf help**
>>>  |
>>>  |    *BTF_SRC* := { **id** *BTF_ID* | **prog** *PROG* | **map** *MAP* [{**key** | **value** | **kv** | **all**}] | **file** *FILE* }
>>> +|       *FORMAT* := { **raw** | **c** }
>>
>> Nit: This line should use a tab for indent (Do not respin just for that,
>> though!).
> 
> Oh, I didn't notice that. My vim setup very aggressively refuses to
> insert tabs, so I had to literaly copy/paste pieces of tabulations :)
> Fixed it.

I can relate :). On my (vim) setup, I can usually hit Ctrl+V then <Tab>
to insert tabulations in that case.

> 
>>
>>>  |    *MAP* := { **id** *MAP_ID* | **pinned** *FILE* }
>>>  |    *PROG* := { **id** *PROG_ID* | **pinned** *FILE* | **tag** *PROG_TAG* }
>>>
>>> @@ -49,6 +50,10 @@ DESCRIPTION
>>>                    .BTF section with well-defined BTF binary format data,
>>>                    typically produced by clang or pahole.
>>>
>>> +                  **format** option can be used to override default (raw)
>>> +                  output format. Raw (**raw**) or C-syntax (**c**) output
>>> +                  formats are supported.
>>> +
>>
>> Other files use tabs here as well, but most of the description here
>> already uses spaces, so ok.
> 
> Yeah, thanks for pointing out, fixed everything to tabs + 2 spaces, as
> in other files (unclear why we have extra 2 spaces, but not going to
> change that).

Thanks!

> 
>>
>>>       **bpftool btf help**
>>>                 Print short help message.
>>>
>>>
>>

