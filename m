Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6455960AC2
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 19:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbfGERJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 13:09:16 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:37208 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbfGERJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 13:09:15 -0400
Received: by mail-io1-f67.google.com with SMTP id e5so16134779iok.4;
        Fri, 05 Jul 2019 10:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ibWt4DpF7SHfPabzR06+7XyS2FWOdOZ82HTF5uWzJEE=;
        b=ZxX59Xj850KlXHRL4bC3zPJ40cqjH98g8m8pi4eo5wZSOKBvY9gEsB6HFVY9iQg18/
         5tOpJwoCI6lS/gC047Zug1rnrDISfUrL7bhDZIxpb/WZjOx6ic+t/4NXwFc9ExH5t2NZ
         zzRmrvT1fuCRQnFK1xNTE54h61uot51uLLwCy24wyyojgIsS50ZQbh01GUV+bXWjQEWf
         4o1ECMOoNffA3ZTZGQ94RaxtsIrgXTNgT/Jq8tLvYXmhbrDZHKMcAW4WEmfTT7PSzAZ2
         gNfRZw74MFQr6Fns575Q7oJ5DSdprdt+tJgmUlosk9BBLf+zrWRApvHXtaMQhd8ZbB4g
         G+wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ibWt4DpF7SHfPabzR06+7XyS2FWOdOZ82HTF5uWzJEE=;
        b=D0Jn78RERLKu2Z/vjO4rcuqVskzCKttAakun6a6fq0s1b/5dOKDo1CWMb6chB295F3
         buM3lPZSUS3P4mZbW2q4RAh4cOwFavny3zV84VHVF4Lv3qmR4VrkEfAPEctr4ujFJ+6x
         /oibRILU9ncsg6vtKQBwUbbwoL3HN5OZ+v3nSMu5sBlEKu4IK+f/m1qkxepaRdq69V7p
         8vrm6loG4ydJfVManoRABxw7WHWuD8E6qvcPqbeNZzVxNB+wBslZM58pPPqTFcdX2GC7
         Oqxj9zghPFagigxjw1KS1j6H+J1Ib6n3Cnim610uegfBv22Ij9bt/m/EdMlirLpxIaSi
         ZzWg==
X-Gm-Message-State: APjAAAU/aM1lt8E15BRQOJQu8YbShpEsSDeUDBe233vMhRmhEr4sDhx6
        8c2dP7MDUpgSwM8cl3XML0xyYJZXA9+oIPSrc6I=
X-Google-Smtp-Source: APXvYqyyDImoENuticYCUr9ZBl3hbt/BvFN47Z5aUzV9Rys0/Ok1cM1L5uneWz2Jl0vXmspR2a1fWGiut5wvFVsjFac=
X-Received: by 2002:a6b:dd18:: with SMTP id f24mr3762748ioc.97.1562346554508;
 Fri, 05 Jul 2019 10:09:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190704085646.12406-1-quentin.monnet@netronome.com>
 <CAH3MdRXuDmXobkXESZg0+VV=FrBLsiAYPC61xQsjx2smKQKUtQ@mail.gmail.com>
 <b4bbb342-1f77-8669-ec51-8d5542f7e7b4@netronome.com> <CAH3MdRWcU9=YCO6WuLY2e2-kixE7E8yLBS+fJH4ASh94oHcK-A@mail.gmail.com>
 <4e7a66b8-8c4b-58cc-61a8-9ec6568d4df7@netronome.com>
In-Reply-To: <4e7a66b8-8c4b-58cc-61a8-9ec6568d4df7@netronome.com>
From:   Y Song <ys114321@gmail.com>
Date:   Fri, 5 Jul 2019 10:08:38 -0700
Message-ID: <CAH3MdRX3LLjcwi72tW_5TEj9sHvVqVE88xqX5Ud6MOZf83jUmw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] tools: bpftool: add "prog run" subcommand to
 test-run programs
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 5, 2019 at 9:03 AM Quentin Monnet
<quentin.monnet@netronome.com> wrote:
>
> 2019-07-05 08:42 UTC-0700 ~ Y Song <ys114321@gmail.com>
> > On Fri, Jul 5, 2019 at 1:21 AM Quentin Monnet
> > <quentin.monnet@netronome.com> wrote:
> >>
> >> 2019-07-04 22:49 UTC-0700 ~ Y Song <ys114321@gmail.com>
> >>> On Thu, Jul 4, 2019 at 1:58 AM Quentin Monnet
> >>> <quentin.monnet@netronome.com> wrote:
> >>>>
> >>>> Add a new "bpftool prog run" subcommand to run a loaded program on input
> >>>> data (and possibly with input context) passed by the user.
> >>>>
> >>>> Print output data (and output context if relevant) into a file or into
> >>>> the console. Print return value and duration for the test run into the
> >>>> console.
> >>>>
> >>>> A "repeat" argument can be passed to run the program several times in a
> >>>> row.
> >>>>
> >>>> The command does not perform any kind of verification based on program
> >>>> type (Is this program type allowed to use an input context?) or on data
> >>>> consistency (Can I work with empty input data?), this is left to the
> >>>> kernel.
> >>>>
> >>>> Example invocation:
> >>>>
> >>>>     # perl -e 'print "\x0" x 14' | ./bpftool prog run \
> >>>>             pinned /sys/fs/bpf/sample_ret0 \
> >>>>             data_in - data_out - repeat 5
> >>>>     0000000 0000 0000 0000 0000 0000 0000 0000      | ........ ......
> >>>>     Return value: 0, duration (average): 260ns
> >>>>
> >>>> When one of data_in or ctx_in is "-", bpftool reads from standard input,
> >>>> in binary format. Other formats (JSON, hexdump) might be supported (via
> >>>> an optional command line keyword like "data_fmt_in") in the future if
> >>>> relevant, but this would require doing more parsing in bpftool.
> >>>>
> >>>> Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
> >>>> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> >>>> ---
> >>
> >> [...]
> >>
> >>>> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> >>>> index 9b0db5d14e31..8dcbaa0a8ab1 100644
> >>>> --- a/tools/bpf/bpftool/prog.c
> >>>> +++ b/tools/bpf/bpftool/prog.c
> >>>> @@ -15,6 +15,7 @@
> >>>>  #include <sys/stat.h>
> >>>>
> >>>>  #include <linux/err.h>
> >>>> +#include <linux/sizes.h>
> >>>>
> >>>>  #include <bpf.h>
> >>>>  #include <btf.h>
> >>>> @@ -748,6 +749,344 @@ static int do_detach(int argc, char **argv)
> >>>>         return 0;
> >>>>  }
> >>>>
> >>>> +static int check_single_stdin(char *file_in, char *other_file_in)
> >>>> +{
> >>>> +       if (file_in && other_file_in &&
> >>>> +           !strcmp(file_in, "-") && !strcmp(other_file_in, "-")) {
> >>>> +               p_err("cannot use standard input for both data_in and ctx_in");
> >>>
> >>> The error message says data_in and ctx_in.
> >>> Maybe the input parameter should be file_data_in and file_ctx_in?
> >>
> >>
> >> Hi Yonghong,
> >>
> >> It's true those parameters should be file names. But having
> >> "file_data_in", "file_data_out", "file_ctx_in" and "file_ctx_out" on a
> >> command line seems a bit heavy to me? (And relying on keyword prefixing
> >> for typing the command won't help much.)
> >>
> >> My opinion is that it should be clear from the man page or the "help"
> >> command that the parameters are file names. What do you think? I can
> >> prefix all four arguments with "file_" if you believe this is better.
> >
> > I think you misunderstood my question above.
>
> Totally did, sorry :/.
>
> > The command line parameters are fine.
> > I am talking about the function parameter names. Since in the error message,
> > the input parameters are referred for data_in and ctx_in
> >    p_err("cannot use standard input for both data_in and ctx_in")
> > maybe the function signature should be
> >   static int check_single_stdin(char *file_data_in, char *file_ctx_in)
> >
> > If you are worried that later on the same function can be used in different
> > contexts, then alternatively, you can have signature like
> >   static int check_single_stdin(char *file_in, char *other_file_in,
> > const char *file_in_arg, const char *other_file_in_arg)
> > where file_in_arg will be passed in as "data_in" and other_file_in_arg
> > as "ctx_in".
> > I think we could delay this until it is really needed.
>
> As a matter of fact, the opposite thing happened. I first used the
> function for data_in/ctx_in, and also for data_out/ctx_out. But I
> changed my mind eventually because there is no real reason not to print
> both data_out and ctx_out to stdout if we want to do so. So I updated
> the name of the parameters in the error messages, but forgot to change
> the arguments for the function. Silly me.
>
> So I totally agree, I'll respin and change the argument names for the
> function. And yes, we could also pass the names to print in the error
> message, but I agree that this is not needed, and not helpful at the moment.
>
> Thanks for catching this!
>
> >>
> >> [...]
> >>
> >>>> +static int do_run(int argc, char **argv)
> >>>> +{
> >>>> +       char *data_fname_in = NULL, *data_fname_out = NULL;
> >>>> +       char *ctx_fname_in = NULL, *ctx_fname_out = NULL;
> >>>> +       struct bpf_prog_test_run_attr test_attr = {0};
> >>>> +       const unsigned int default_size = SZ_32K;
> >>>> +       void *data_in = NULL, *data_out = NULL;
> >>>> +       void *ctx_in = NULL, *ctx_out = NULL;
> >>>> +       unsigned int repeat = 1;
> >>>> +       int fd, err;
> >>>> +
> >>>> +       if (!REQ_ARGS(4))
> >>>> +               return -1;
> >>>> +
> >>>> +       fd = prog_parse_fd(&argc, &argv);
> >>>> +       if (fd < 0)
> >>>> +               return -1;
> >>>> +
> >>>> +       while (argc) {
> >>>> +               if (detect_common_prefix(*argv, "data_in", "data_out",
> >>>> +                                        "data_size_out", NULL))
> >>>> +                       return -1;
> >>>> +               if (detect_common_prefix(*argv, "ctx_in", "ctx_out",
> >>>> +                                        "ctx_size_out", NULL))
> >>>> +                       return -1;
> >>>> +
> >>>> +               if (is_prefix(*argv, "data_in")) {
> >>>> +                       NEXT_ARG();
> >>>> +                       if (!REQ_ARGS(1))
> >>>> +                               return -1;
> >>>> +
> >>>> +                       data_fname_in = GET_ARG();
> >>>> +                       if (check_single_stdin(data_fname_in, ctx_fname_in))
> >>>> +                               return -1;
> >>>> +               } else if (is_prefix(*argv, "data_out")) {
> >>>
> >>> Here, we all use is_prefix() to match "data_in", "data_out",
> >>> "data_size_out" etc.
> >>> That means users can use "data_i" instead of "data_in" as below
> >>>    ... | ./bpftool prog run id 283 data_i - data_out - repeat 5
> >>> is this expected?
> >> Yes, this is expected. We use prefix matching as we do pretty much
> >> everywhere else in bpftool. It's not as useful here because most of the
> >> strings for the names are similar. I agree that typing "data_i" instead
> >> of "data_in" brings little advantage, but I see no reason why we should
> >> reject prefixing for those keywords. And we accept "data_s" instead of
> >> "data_size_out", which is still shorter to type than the complete keyword.
> >
> > This makes sense. Thanks for explanation.
> >
> > Another question. Currently, you are proposing "./bpftool prog run ...",
> > but actually it is just a test_run. Do you think we should rename it
> > to "./bpftool prog test_run ..." to make it clear for its intention?
>
> Good question. Hmm. It would make it more explicit that we use the
> BPF_PROG_TEST_RUN command, but at the same time, from the point of view
> of the user, there is nothing in particular that makes it a test run, is
> it? I mean, you provide input data, you get output data and return
> value, that makes it a real BPF run somehow, except that it's not on a
> packet or anything. Do you think it is ambiguous and people may confuse
> it with something like "attach"?

I am more thinking about whether we could have a real "bpftool prog run ..."
in the future which could really run the program in some kind of production
environment...

But I could be wrong since after "bpf prog attach" it may already just start
to run in production, so "bpf prog run ..." not really needed for it.

So "bpf prog run ..." is probably fine.

>
> Thanks,
> Quentin
