Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8299860209
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 10:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfGEIVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 04:21:20 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39066 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbfGEIVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 04:21:20 -0400
Received: by mail-wr1-f67.google.com with SMTP id x4so8956978wrt.6
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 01:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AZ+xp1XexP5IT9024QnXjkh9NZlQyC9GI6IM2t8wHAI=;
        b=zCygwcevPqnMlXoX518iHLJ+RxFS6+s87b7/J44Gth9SDOeHSqebrk1M1Pn4kFgC/V
         jMakN82JJkcuHcfHbLCJ47F2wCRxPRTOwZIzL9nahOHOZoKwe+86Lba4DO3kERtDkF7x
         zkVmei/JDbPW65VOlCEmYZAFMUakL/3cdFFkeVbPREKGBX9XlhVhB0guS46RUs64bLhM
         oRZM6YGCxB3g7fWzCEtJhxNEDQceh6flM0mVl3hJ2qY7eCSbzpHGm4McvDLXKdnly4Wk
         4MVi4qzH5mtATQz7+4TwZwaxR1UETOs6liho+yjMCYe12/SRLZA6WWNG/SkKBQbIEwNl
         y8hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AZ+xp1XexP5IT9024QnXjkh9NZlQyC9GI6IM2t8wHAI=;
        b=Tykvw03UBUU2rJCUuXDsj6IPSf11GDDdG28pf8Sf4tSs1JXPlpOgdfP/sL6qGqucr5
         P9mjyew1y8OTp9V92m/m2NXD2exzk9Rd6Cscs0rwWFnWRMeGKk42389UHH9WkhEoXlhi
         PN0iKL2MeRAJPE8eWZIvTI8HXGrWyikbIVMvxnfSGovbaqxxwRvSs8Y4xBxeJT5iF6wo
         O7VkSpeJXLaoNp0kYbK7BB3PtQXMIgYdvos4dailQNgZWhhWxcdXkUaGSoZJX568WF5a
         RAjN/VSTiU81wNJ+TUd5d5EZQCkhWVhTrTmlksqH/esqpleJLNwjUagACJUeOBULoNWX
         jolQ==
X-Gm-Message-State: APjAAAW43fcNS2qfrR+0Z5SZOB7UbeY99rn6duwZJ2sJOKedbkV7LXs8
        2m6cZebJo7nXcyGpuSKN2FmR1A==
X-Google-Smtp-Source: APXvYqy7xwXN10UR/cnM70Na74Mq3O/S6NmBjxkFNxBUS74MU/CWppXxi4jnn7x479qMNh3W/G6VKA==
X-Received: by 2002:adf:e748:: with SMTP id c8mr2591008wrn.46.1562314877569;
        Fri, 05 Jul 2019 01:21:17 -0700 (PDT)
Received: from [192.168.1.2] ([194.53.187.142])
        by smtp.gmail.com with ESMTPSA id n14sm16401269wra.75.2019.07.05.01.21.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 01:21:17 -0700 (PDT)
Subject: Re: [PATCH bpf-next] tools: bpftool: add "prog run" subcommand to
 test-run programs
To:     Y Song <ys114321@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        oss-drivers@netronome.com
References: <20190704085646.12406-1-quentin.monnet@netronome.com>
 <CAH3MdRXuDmXobkXESZg0+VV=FrBLsiAYPC61xQsjx2smKQKUtQ@mail.gmail.com>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Message-ID: <b4bbb342-1f77-8669-ec51-8d5542f7e7b4@netronome.com>
Date:   Fri, 5 Jul 2019 09:21:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAH3MdRXuDmXobkXESZg0+VV=FrBLsiAYPC61xQsjx2smKQKUtQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-07-04 22:49 UTC-0700 ~ Y Song <ys114321@gmail.com>
> On Thu, Jul 4, 2019 at 1:58 AM Quentin Monnet
> <quentin.monnet@netronome.com> wrote:
>>
>> Add a new "bpftool prog run" subcommand to run a loaded program on input
>> data (and possibly with input context) passed by the user.
>>
>> Print output data (and output context if relevant) into a file or into
>> the console. Print return value and duration for the test run into the
>> console.
>>
>> A "repeat" argument can be passed to run the program several times in a
>> row.
>>
>> The command does not perform any kind of verification based on program
>> type (Is this program type allowed to use an input context?) or on data
>> consistency (Can I work with empty input data?), this is left to the
>> kernel.
>>
>> Example invocation:
>>
>>     # perl -e 'print "\x0" x 14' | ./bpftool prog run \
>>             pinned /sys/fs/bpf/sample_ret0 \
>>             data_in - data_out - repeat 5
>>     0000000 0000 0000 0000 0000 0000 0000 0000      | ........ ......
>>     Return value: 0, duration (average): 260ns
>>
>> When one of data_in or ctx_in is "-", bpftool reads from standard input,
>> in binary format. Other formats (JSON, hexdump) might be supported (via
>> an optional command line keyword like "data_fmt_in") in the future if
>> relevant, but this would require doing more parsing in bpftool.
>>
>> Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
>> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>> ---

[...]

>> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
>> index 9b0db5d14e31..8dcbaa0a8ab1 100644
>> --- a/tools/bpf/bpftool/prog.c
>> +++ b/tools/bpf/bpftool/prog.c
>> @@ -15,6 +15,7 @@
>>  #include <sys/stat.h>
>>
>>  #include <linux/err.h>
>> +#include <linux/sizes.h>
>>
>>  #include <bpf.h>
>>  #include <btf.h>
>> @@ -748,6 +749,344 @@ static int do_detach(int argc, char **argv)
>>         return 0;
>>  }
>>
>> +static int check_single_stdin(char *file_in, char *other_file_in)
>> +{
>> +       if (file_in && other_file_in &&
>> +           !strcmp(file_in, "-") && !strcmp(other_file_in, "-")) {
>> +               p_err("cannot use standard input for both data_in and ctx_in");
> 
> The error message says data_in and ctx_in.
> Maybe the input parameter should be file_data_in and file_ctx_in?


Hi Yonghong,

It's true those parameters should be file names. But having
"file_data_in", "file_data_out", "file_ctx_in" and "file_ctx_out" on a
command line seems a bit heavy to me? (And relying on keyword prefixing
for typing the command won't help much.)

My opinion is that it should be clear from the man page or the "help"
command that the parameters are file names. What do you think? I can
prefix all four arguments with "file_" if you believe this is better.

[...]

>> +static int do_run(int argc, char **argv)
>> +{
>> +       char *data_fname_in = NULL, *data_fname_out = NULL;
>> +       char *ctx_fname_in = NULL, *ctx_fname_out = NULL;
>> +       struct bpf_prog_test_run_attr test_attr = {0};
>> +       const unsigned int default_size = SZ_32K;
>> +       void *data_in = NULL, *data_out = NULL;
>> +       void *ctx_in = NULL, *ctx_out = NULL;
>> +       unsigned int repeat = 1;
>> +       int fd, err;
>> +
>> +       if (!REQ_ARGS(4))
>> +               return -1;
>> +
>> +       fd = prog_parse_fd(&argc, &argv);
>> +       if (fd < 0)
>> +               return -1;
>> +
>> +       while (argc) {
>> +               if (detect_common_prefix(*argv, "data_in", "data_out",
>> +                                        "data_size_out", NULL))
>> +                       return -1;
>> +               if (detect_common_prefix(*argv, "ctx_in", "ctx_out",
>> +                                        "ctx_size_out", NULL))
>> +                       return -1;
>> +
>> +               if (is_prefix(*argv, "data_in")) {
>> +                       NEXT_ARG();
>> +                       if (!REQ_ARGS(1))
>> +                               return -1;
>> +
>> +                       data_fname_in = GET_ARG();
>> +                       if (check_single_stdin(data_fname_in, ctx_fname_in))
>> +                               return -1;
>> +               } else if (is_prefix(*argv, "data_out")) {
> 
> Here, we all use is_prefix() to match "data_in", "data_out",
> "data_size_out" etc.
> That means users can use "data_i" instead of "data_in" as below
>    ... | ./bpftool prog run id 283 data_i - data_out - repeat 5
> is this expected?
Yes, this is expected. We use prefix matching as we do pretty much
everywhere else in bpftool. It's not as useful here because most of the
strings for the names are similar. I agree that typing "data_i" instead
of "data_in" brings little advantage, but I see no reason why we should
reject prefixing for those keywords. And we accept "data_s" instead of
"data_size_out", which is still shorter to type than the complete keyword.

Thanks for the review!
Quentin
