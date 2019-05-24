Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE72329F39
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 21:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732098AbfEXTmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 15:42:05 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52569 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729597AbfEXTmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 15:42:04 -0400
Received: by mail-wm1-f66.google.com with SMTP id y3so10498729wmm.2
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 12:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bOyztbvPs1WDB8t01stjKvIzsOPGX3DvWoR6Ee1uwQc=;
        b=B/YigiU7lOIbxbI+oZjq3PrdVGG18kK7A4KCC4bIP9MMpaiYgNrOQhFQPkBmGjRokW
         3X6BykKbYYahsAI5plZs/KFictnM2XH2RsXR9h+2V7P0p0IEj5pepeNYx1Univ3YEWBh
         aI4YQxRwpI67f4dqP8N/fVVmWwW9OnpOrVODDhFhA0xTYVFjM5m9jVPS43jmMPNHF7GK
         LXtzAl1mRNmhsWihINUQ99cS1cP6k5LaXbvgH6QhXFDEIUO17EccD11Ty6cns3RWEGOv
         /+26chX/ckWuBDuifApu8obtZfqoa43wL/A2l9eV8VHBAPe/JEDm219pzZUqjTXMUAJx
         cCgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bOyztbvPs1WDB8t01stjKvIzsOPGX3DvWoR6Ee1uwQc=;
        b=U6kvSdzZtwBKienCGuBbwbGRru/xbFnq34sPx49Uy1wAn2aNgUNuRSCUDhuHCViwOZ
         IMiJAZfOGgRquWG11Y3cnZ8y8+r9DvaZNWhLKE8vw36me21gDrUL0EhhLgBnMCDaXqPP
         fBOtHRm9yQ3vSb/9PFW0/bHw3KWn12WejnEkRo1Yi7/T/hGsGSnd+6vpFT7DRce9F1c8
         lH3LgdIN+9Cse5nZSyCIIwu1xdM1krCOl2kAq4OJ+cxjRvIX2UcePke3tyVRe2Kn+dNU
         Ukm+ueX5B1FEjwKuvRjxBEQzbqCvxP5bNqgcmf3u1GOUoYs/GQpGqlrVKXdc/xJQGv+a
         ZP/g==
X-Gm-Message-State: APjAAAX8mjjsSRgmmHLrdIpA22UM2EcctdYbX8g/fZlw7PmIgRI/rPw/
        iymSUgEhhab6Ll43v2gmTKx9yg==
X-Google-Smtp-Source: APXvYqxGUcuSuIClvixbgN9gLXOTvyO3R0mzzD6sgGP6Q3xuNSaSO2BKh070XvCt1tlB0INxrIp12g==
X-Received: by 2002:a7b:cb85:: with SMTP id m5mr1000010wmi.85.1558726922720;
        Fri, 24 May 2019 12:42:02 -0700 (PDT)
Received: from [192.168.1.2] ([194.53.186.20])
        by smtp.gmail.com with ESMTPSA id h8sm7297149wmf.5.2019.05.24.12.42.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 12:42:02 -0700 (PDT)
Subject: Re: [PATCH v2 bpf-next 10/12] bpftool: add C output format option to
 btf dump subcommand
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20190523204222.3998365-1-andriin@fb.com>
 <20190523204222.3998365-11-andriin@fb.com>
 <eb690c2d-14d4-9c6f-2138-44f8cd027860@netronome.com>
 <CAEf4Bza9ikV+SnBOE-h8J7ggw--1M3L8ak-VQ6-RxO71x0YUhw@mail.gmail.com>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Message-ID: <72fbdb59-4b3b-0e7f-20e1-2ced103fdc46@netronome.com>
Date:   Fri, 24 May 2019 20:42:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAEf4Bza9ikV+SnBOE-h8J7ggw--1M3L8ak-VQ6-RxO71x0YUhw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-05-24 10:14 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> On Fri, May 24, 2019 at 2:14 AM Quentin Monnet
> <quentin.monnet@netronome.com> wrote:
>>
>> Hi Andrii,
>>
>> Some nits inline, nothing blocking though.
>>
>> 2019-05-23 13:42 UTC-0700 ~ Andrii Nakryiko <andriin@fb.com>
>>> Utilize new libbpf's btf_dump API to emit BTF as a C definitions.
>>>
>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>> ---
>>>  tools/bpf/bpftool/btf.c | 74 +++++++++++++++++++++++++++++++++++++++--
>>>  1 file changed, 72 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
>>> index a22ef6587ebe..1cdbfad42b38 100644
>>> --- a/tools/bpf/bpftool/btf.c
>>> +++ b/tools/bpf/bpftool/btf.c
>>> @@ -340,11 +340,48 @@ static int dump_btf_raw(const struct btf *btf,
>>>       return 0;
>>>  }
>>>
>>> +static void btf_dump_printf(void *ctx, const char *fmt, va_list args)
>>
>> Nit: This function could have a printf attribute ("__printf(2, 0)").
> 
> added, though I don't think it matters as it's only used as a callback function.

Thanks. Yes, true... But the attribute does not hurt, and we have it
case it changes in the future and the function is reused. Ok, unlikely,
but...

> 
>>
>>> +{
>>> +     vfprintf(stdout, fmt, args);
>>> +}
>>> +


>>> @@ -431,6 +468,29 @@ static int do_dump(int argc, char **argv)
>>>               goto done;
>>>       }
>>>
>>> +     while (argc) {
>>> +             if (is_prefix(*argv, "format")) {
>>> +                     NEXT_ARG();
>>> +                     if (argc < 1) {
>>> +                             p_err("expecting value for 'format' option\n");
>>> +                             goto done;
>>> +                     }
>>> +                     if (strcmp(*argv, "c") == 0) {
>>> +                             dump_c = true;
>>> +                     } else if (strcmp(*argv, "raw") == 0) {
>>
>> Do you think we could use is_prefix() instead of strcmp() here?
> 
> So I considered it, and then decided against it, though I can still be
> convinced otherwise. Right now we have raw and c, but let's say we add
> rust as an option. r will become ambiguous, but actually will be
> resolved to whatever we check first: either raw or rust, which is not
> great. So given that those format specifiers will tend to be short, I
> decided it's ok to require to specify them fully. Does it make sense?

It does make sense. I thought about that too. I think I would add prefix
handling anyway, especially because "raw" is the default so it makes
sense defaulting to it in case there is a collision in the future. This
is what happens already between "bpftool prog" and "bpftool perf". But I
don't really mind, so ok, let's keep the full keyword for now if you prefer.

> 
>>
>>> +                             dump_c = false;
>>> +                     } else {
>>> +                             p_err("unrecognized format specifier: '%s'",
>>> +                                   *argv);
>>
>> Would it be worth reminding the user about the valid specifiers in that
>> message? (But then we already have it in do_help(), so maybe not.)
> 
> Added possible options to the message.

Cool, thanks!
