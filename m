Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 608913395D8
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 19:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbhCLSHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 13:07:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbhCLSHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 13:07:13 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E967C061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 10:07:13 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id p8so55016718ejb.10
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 10:07:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AOWDVraelT3q2iJa2o1XiejflpUA+riSmnoD1zMFlMA=;
        b=yPluzX314PIS3cxGWuVurfUFLcsmNiSRPKx378NxBWHOYob2ugJbu45pwhCEMExt+4
         z6cLhtr3jEH+wjJIlJSM/eOuU6/AxYw7sSFmonUGThSw6XCunbBZliX4l0P6nq4YOHlS
         tS6Pjr1+33NGSxdP5gdlfojgsSxpw6JsBxTkJ/vNiupOy1Dd0fqmYSR1a05n6gApu4nS
         yWM7czZf3jHS/oOEcwBQoJz5swOCqGAUxLAMlY/26HrsFapcZJMJYZgGK/tEuToHLnXQ
         vtbxcnuLgnijVU9rgYtOTA7XlmZVZGFQgeBBwtghvVZIPbQ5LfwnvE0z60XSXyZ4Plp1
         8Ziw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AOWDVraelT3q2iJa2o1XiejflpUA+riSmnoD1zMFlMA=;
        b=i+InL1d9tjkOyJW57uh+7dkBUt+BTERYlwJLaNg/roWDVISkNh00NSNyCaxo5folRo
         guF5ssV9aXu8IB8hJRWQQFLO3DaaSQ90opjQBwzpxPkTRh3aCmbROSu8nST4PmFFhISB
         biPDBkRmnmk5i84op2TrtZ8nvG07Z8PzO+w2eMT0/fprj0n+wO3loSPAGKO4XD+qlHmb
         pulgn5Zc2CN1/huyYteHXn2D1DAY8aeMb0Zl8zD04EbNtzWnBR/4GUK+kQhWB3f+r5s3
         PxUow2PTdw/l4n6x6R8drVlQQ2deLZxGd8JT6jqmPoP+TKEH3+1V3COTGvKlYnZZ+zRN
         /WiA==
X-Gm-Message-State: AOAM5335/h23npJnR6Z5wcv14w9z07XRXj4yCq1odd3gK6d1ZUKTHphP
        H7WXRiiP4uEph2oUQwvus8I0reLJ9/CTU0DjJ00=
X-Google-Smtp-Source: ABdhPJxljWO20JrlmCvTaWaOt3XIObOTPxfArQVQhLoUvfNNmkXrUgWKJRx5k9xRlPLeM0KUq1vuGQ==
X-Received: by 2002:a17:906:da0e:: with SMTP id fi14mr10278257ejb.188.1615572432194;
        Fri, 12 Mar 2021 10:07:12 -0800 (PST)
Received: from [192.168.1.8] ([194.35.119.67])
        by smtp.gmail.com with ESMTPSA id s18sm3038742ejc.79.2021.03.12.10.07.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 10:07:11 -0800 (PST)
Subject: Re: [PATCH bpf-next 07/10] bpftool: add `gen bpfo` command to perform
 BPF static linking
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20210310040431.916483-1-andrii@kernel.org>
 <20210310040431.916483-8-andrii@kernel.org>
 <9f44eedf-79a3-0025-0f31-ee70f2f7d98b@isovalent.com>
 <CAEf4BzZKFKQQSQmNPkoSW8b3NEvRXirkqx-Hewt1cmRE9tPmHw@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <7c78ba67-03ff-fd84-339e-08628716abdf@isovalent.com>
Date:   Fri, 12 Mar 2021 18:07:10 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZKFKQQSQmNPkoSW8b3NEvRXirkqx-Hewt1cmRE9tPmHw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-03-11 10:45 UTC-0800 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> On Thu, Mar 11, 2021 at 3:31 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>
>> 2021-03-09 20:04 UTC-0800 ~ Andrii Nakryiko <andrii@kernel.org>
>>> Add `bpftool gen bpfo <output-file> <input_file>...` command to statically
>>> link multiple BPF object files into a single output BPF object file.
>>>
>>> Similarly to existing '*.o' convention, bpftool is establishing a '*.bpfo'
>>> convention for statically-linked BPF object files. Both .o and .bpfo suffixes
>>> will be stripped out during BPF skeleton generation to infer BPF object name.
>>>
>>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>>> ---
>>>  tools/bpf/bpftool/gen.c | 46 ++++++++++++++++++++++++++++++++++++++++-
>>>  1 file changed, 45 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
>>> index 4033c46d83e7..8b1ed6c0a62f 100644
>>> --- a/tools/bpf/bpftool/gen.c
>>> +++ b/tools/bpf/bpftool/gen.c
>>> +static int do_bpfo(int argc, char **argv)
>>
>>> +{
>>> +     struct bpf_linker *linker;
>>> +     const char *output_file, *file;
>>> +     int err;
>>> +
>>> +     if (!REQ_ARGS(2)) {
>>> +             usage();
>>> +             return -1;
>>> +     }
>>> +
>>> +     output_file = GET_ARG();
>>> +
>>> +     linker = bpf_linker__new(output_file, NULL);
>>> +     if (!linker) {
>>> +             p_err("failed to create BPF linker instance");
>>> +             return -1;
>>> +     }
>>> +
>>> +     while (argc) {
>>> +             file = GET_ARG();
>>> +
>>> +             err = bpf_linker__add_file(linker, file);
>>> +             if (err) {
>>> +                     p_err("failed to link '%s': %d", file, err);
>>
>> I think you mentioned before that your preference was for having just
>> the error code instead of using strerror(), but I think it would be more
>> user-friendly for the majority of users who don't know the error codes
>> if we had something more verbose? How about having both strerror()
>> output and the error code?
> 
> Sure, I'll add strerror(). My earlier point was that those messages
> are more often misleading (e.g., "file not found" for ENOENT or
> something similar) than helpful. I should check if bpftool is passing
> through warn-level messages from libbpf. Those are going to be very
> helpful, if anything goes wrong. --verbose should pass through all of
> libbpf messages, if it's not already the case.

Thanks. Yes, --verbose should do it, but it's worth a double-check.

>>> +                     goto err_out;
>>> +             }
>>> +     }
>>> +
>>> +     err = bpf_linker__finalize(linker);
>>> +     if (err) {
>>> +             p_err("failed to finalize ELF file: %d", err);
>>> +             goto err_out;
>>> +     }
>>> +
>>> +     return 0;
>>> +err_out:
>>> +     bpf_linker__free(linker);
>>> +     return -1;
>>
>> Should you call bpf_linker__free() even on success? I see that
>> bpf_linker__finalize() frees some of the resources, but it seems that
>> bpf_linker__free() does a more thorough job?
> 
> yep, it should really be just
> 
> err_out:
>     bpf_linker__free(linker);
>     return err;
> 
> 
>>
>>> +}
>>> +
>>>  static int do_help(int argc, char **argv)
>>>  {
>>>       if (json_output) {
>>> @@ -611,6 +654,7 @@ static int do_help(int argc, char **argv)
>>>
>>>  static const struct cmd cmds[] = {
>>>       { "skeleton",   do_skeleton },
>>> +     { "bpfo",       do_bpfo },
>>>       { "help",       do_help },
>>>       { 0 }
>>>  };
>>>
>>
>> Please update the usage help message, man page, and bash completion,
>> thanks. Especially because what "bpftool gen bpfo" does is not intuitive
>> (but I don't have a better name suggestion at the moment).
> 
> Yeah, forgot about manpage and bash completions, as usual.
> 
> re: "gen bpfo". I don't have much better naming as well. `bpftool
> link` is already taken for bpf_link-related commands. It felt like
> keeping this under "gen" command makes sense. But maybe `bpftool
> linker link <out> <in1> <in2> ...` would be a bit less confusing
> convention?

"bpftool linker" would have been nice, but having "bpftool link", I
think it would be even more confusing. We can pass commands by their
prefixes, so is "bpftool link" the command "link" or a prefix for
"linker"? (I know it would be easy to sort out from our point of view,
but for regular users I'm sure that would be confusing).

I don't mind leaving it under "bpftool gen", it's probably the most
relevant command we have. As for replacing the "bpfo" keyword, I've
thought of "combined", "static_linked", "archive", "concat". I write
them in case it's any inspiration, but I find none of them ideal :/.

Quentin
