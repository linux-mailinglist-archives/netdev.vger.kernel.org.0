Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDEC262A6F
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 10:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbgIIIfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 04:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728709AbgIIIfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 04:35:50 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373D4C061755
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 01:35:49 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id b79so1463117wmb.4
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 01:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VZ2kWh7JwmJsgOQ0DxpOoUNqZu7b8hlqeuOdH1m8tuc=;
        b=TUnI0Z7rhCtpTEQSvdf94Tg+oft1RaPTFS/70DEXeN3wLA7CLaKmqD6prW0yikVcNO
         sPJW3Itt1fgJzyBAYzscgJ7HvoqIw0kKX6Ru2oQ+MSqLHkanrbBmX9HThpTm/LgxL8D/
         YvD9h8GowjaRNM+PQchrL0z3ZcHG2W72jEmFh3ZHxAmNLyVn9K6fQPJ6Q0+jZj/+MK6r
         /7p79fBiONyCArFkN9+8PGPqenLNvYPVFmah9rW1y/B2IJehhrg8Ge8Tr6dLJST9/xTv
         S8vjo0L+kQPjFxNWo40gYRJHgfy4TutfmZXAXsFXwC3MjUE4cyse+6jr3CEyi5oMEtAn
         D5HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VZ2kWh7JwmJsgOQ0DxpOoUNqZu7b8hlqeuOdH1m8tuc=;
        b=SG1WI7jsnisjUs+ykpDsgVNwM5gQcVW/8TwswoebmmUft6UqHvofgVKXBr3PjxlPyR
         /x9S0+J9+Aaz9jng6ZGFF3bkPi/YNv9GFXYu+X8WxXEmA/j30S8QuT6voU22PrH+gdPi
         MI9sHXRPnuzCKfgDsvKn2sSNnuT3+ORX+rFC6WURiXwb/zYVvJpwA1zBYEYwa2zD8w/f
         6MSe/kdn9oWNUcK9q3SJiiX9yirtg0FykoL66FSET+mXnIM6o9G7xfFRIEw4hBy7nHyE
         JrE4zAj6PkYALeuTczj47bHRcfZxR3ADY48DxEtbhXVQkFjYcCqWTNR9DyqiqYvOAGD6
         c8/g==
X-Gm-Message-State: AOAM532Tqr0+YydEPVBbrt5CSobbFiBBhLpqTmIAh9DAqc9XJdyMihmh
        kFr219XgpHJxl+3yTZSvrwY2dt6+7C2zCvjA1jI=
X-Google-Smtp-Source: ABdhPJzy6nXKkJlvlFD0SLGJ21dA1FRDWGZ/ehuAJps0tt+pTZeF4YwmfEiGDfK55CO3H84k3Aq1wA==
X-Received: by 2002:a1c:4c0d:: with SMTP id z13mr2310116wmf.115.1599640547012;
        Wed, 09 Sep 2020 01:35:47 -0700 (PDT)
Received: from [192.168.1.12] ([194.35.119.93])
        by smtp.gmail.com with ESMTPSA id c18sm3137346wrx.63.2020.09.09.01.35.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2020 01:35:46 -0700 (PDT)
Subject: Re: [PATCH bpf-next 1/3] tools: bpftool: print optional built-in
 features along with version
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
References: <20200904205657.27922-1-quentin@isovalent.com>
 <20200904205657.27922-2-quentin@isovalent.com>
 <CAEf4Bzbf_igYVP+NfrVV86AZGQT7+2NF1JR6GzcEOymV9_vgNA@mail.gmail.com>
 <05b0ff4c-cf69-a452-6c0e-187ec2961063@isovalent.com>
 <CAEf4BzZwFsVPjR+cwvvuuhfAMy0AW=+=oe4bF-1fH8rxsOmeBw@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <16fe069f-7e3e-70fe-11c3-6cc2147e5ce2@isovalent.com>
Date:   Wed, 9 Sep 2020 09:35:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZwFsVPjR+cwvvuuhfAMy0AW=+=oe4bF-1fH8rxsOmeBw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/09/2020 00:20, Andrii Nakryiko wrote:
> On Mon, Sep 7, 2020 at 7:50 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>
>> On 04/09/2020 22:45, Andrii Nakryiko wrote:
>>> On Fri, Sep 4, 2020 at 1:57 PM Quentin Monnet <quentin@isovalent.com> wrote:
>>>>
>>>> Bpftool has a number of features that can be included or left aside
>>>> during compilation. This includes:
>>>>
>>>> - Support for libbfd, providing the disassembler for JIT-compiled
>>>>   programs.
>>>> - Support for BPF skeletons, used for profiling programs or iterating on
>>>>   the PIDs of processes associated with BPF objects.
>>>>
>>>> In order to make it easy for users to understand what features were
>>>> compiled for a given bpftool binary, print the status of the two
>>>> features above when showing the version number for bpftool ("bpftool -V"
>>>> or "bpftool version"). Document this in the main manual page. Example
>>>> invocation:
>>>>
>>>>     $ bpftool -p version
>>>>     {
>>>>         "version": "5.9.0-rc1",
>>>>         "features": [
>>>>             "libbfd": true,
>>>>             "skeletons": true
>>>>         ]
>>>
>>> Is this a valid JSON? array of key/value pairs?
>>
>> No it's not, silly me :'(. I'll fix that, thanks for spotting it.
>>
>>>>     }
>>>>
>>>> Some other parameters are optional at compilation
>>>> ("DISASM_FOUR_ARGS_SIGNATURE", LIBCAP support) but they do not impact
>>>> significantly bpftool's behaviour from a user's point of view, so their
>>>> status is not reported.
>>>>
>>>> Available commands and supported program types depend on the version
>>>> number, and are therefore not reported either. Note that they are
>>>> already available, albeit without JSON, via bpftool's help messages.
>>>>
>>>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
>>>> ---
>>>>  tools/bpf/bpftool/Documentation/bpftool.rst |  8 +++++++-
>>>>  tools/bpf/bpftool/main.c                    | 22 +++++++++++++++++++++
>>>>  2 files changed, 29 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/tools/bpf/bpftool/Documentation/bpftool.rst b/tools/bpf/bpftool/Documentation/bpftool.rst
>>>> index 420d4d5df8b6..a3629a3f1175 100644
>>>> --- a/tools/bpf/bpftool/Documentation/bpftool.rst
>>>> +++ b/tools/bpf/bpftool/Documentation/bpftool.rst
>>>> @@ -50,7 +50,13 @@ OPTIONS
>>>>                   Print short help message (similar to **bpftool help**).
>>>>
>>>>         -V, --version
>>>> -                 Print version number (similar to **bpftool version**).
>>>> +                 Print version number (similar to **bpftool version**), and
>>>> +                 optional features that were included when bpftool was
>>>> +                 compiled. Optional features include linking against libbfd to
>>>> +                 provide the disassembler for JIT-ted programs (**bpftool prog
>>>> +                 dump jited**) and usage of BPF skeletons (some features like
>>>> +                 **bpftool prog profile** or showing pids associated to BPF
>>>> +                 objects may rely on it).
>>>
>>> nit: I'd emit it as a list, easier to see list of features visually
>>>
>>>>
>>>>         -j, --json
>>>>                   Generate JSON output. For commands that cannot produce JSON, this
>>>> diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
>>>> index 4a191fcbeb82..2ae8c0d82030 100644
>>>> --- a/tools/bpf/bpftool/main.c
>>>> +++ b/tools/bpf/bpftool/main.c
>>>> @@ -70,13 +70,35 @@ static int do_help(int argc, char **argv)
>>>>
>>>>  static int do_version(int argc, char **argv)
>>>>  {
>>>> +#ifdef HAVE_LIBBFD_SUPPORT
>>>> +       const bool has_libbfd = true;
>>>> +#else
>>>> +       const bool has_libbfd = false;
>>>> +#endif
>>>> +#ifdef BPFTOOL_WITHOUT_SKELETONS
>>>> +       const bool has_skeletons = false;
>>>> +#else
>>>> +       const bool has_skeletons = true;
>>>> +#endif
>>>> +
>>>>         if (json_output) {
>>>>                 jsonw_start_object(json_wtr);
>>>> +
>>>>                 jsonw_name(json_wtr, "version");
>>>>                 jsonw_printf(json_wtr, "\"%s\"", BPFTOOL_VERSION);
>>>> +
>>>> +               jsonw_name(json_wtr, "features");
>>>> +               jsonw_start_array(json_wtr);
>>>> +               jsonw_bool_field(json_wtr, "libbfd", has_libbfd);
>>>> +               jsonw_bool_field(json_wtr, "skeletons", has_skeletons);
>>>> +               jsonw_end_array(json_wtr);
>>>> +
>>>>                 jsonw_end_object(json_wtr);
>>>>         } else {
>>>>                 printf("%s v%s\n", bin_name, BPFTOOL_VERSION);
>>>> +               printf("features: libbfd=%s, skeletons=%s\n",
>>>> +                      has_libbfd ? "true" : "false",
>>>> +                      has_skeletons ? "true" : "false");
>>>
>>> now imagine parsing this with CLI text tools, you'll have to find
>>> "skeletons=(false|true)" and then parse "true" to know skeletons are
>>> supported. Why not just print out features that are supported?
>>
>> You could just grep for "skeletons=true" (not too hard) (And generally
>> speaking I'd recommend against parsing bpftool's plain output, JSON is
>> more stable - Once you're parsing the JSON, checking the feature is
>> present or checking whether it's at "true" does not make a great
>> difference).
>>
>> Anyway, the reason I have those booleans is that if you just list the
>> features and run "bpftool version | grep libbpfd" and get no result, you
>> cannot tell if the binary has been compiled without the disassembler or
>> if you are running an older version of bpftool that does not list
>> built-in features. You could then parse the version number and double
>> check, but you need to find in what version the change has been added.
>> Besides libbfd and skeletons, this could happen again for future
>> optional features if we add them to bpftool but forget to immediately
>> add the related check for "bpftool version".
> 
> Now you are making this into a list of potential features that could
> be supported if only they were built with proper dependencies, don't
> you think?

(That will be the case for new versions of bpftool that will be able to
dump their features, won't it? Anyway.)

> 
> I thought the idea is to detect if a given bpftool that you have
> supports, say, skeleton feature. Whether it's too old to support it or
> it doesn't support because it wasn't built with necessary dependencies
> is immaterial -- it doesn't support the feature, if there is no
> "skeleton" in a list of features.

I agree the reason does not matter, if the feature is not available then
we cannot use it, period. The concern I have is false negatives. If a
script does "bpftool version | grep libbfd" and gets no output, then it
may skip dumping the JITed instructions, although bpftool might simply
be too old to dump the feature.

> 
> Continuing your logic -- parse JSON if you want to know this. In JSON
> having {"skeleton": false, "libbfd": true"} feels natural. In
> human-oriented plain text output seeing "features: libbpf=false,
> skeleton=true" looks weird, instead of just "features: skeleton", IMO.

Ok, so we agree we can have the booleans in JSON to have a way to avoid
the "false negative" issue. In that case I'm fine with having a simpler
list for plain output, this will make a small difference in the info
provided between plain output and JSON but it seems acceptable. I'll
send a new version with that change soon.

Thanks,
Quentin
