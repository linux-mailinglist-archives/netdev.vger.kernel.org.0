Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4898960980
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 17:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbfGEPnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 11:43:16 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:42041 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfGEPnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 11:43:16 -0400
Received: by mail-io1-f66.google.com with SMTP id u19so19971267ior.9;
        Fri, 05 Jul 2019 08:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CBcQOnMbxUrpRaW6VcyeK1/UzStLryrgI/bXrNFSZpQ=;
        b=Z2sxhVbly0j2eXI7y8Y/lK+Jds2xwyX2tvj+M0XwcXqKXQnkQLmJzRtSqDugCPD/Q5
         wtX5mRorYO9U09Z6bnhX7TUlHzQmxPxz38THgbXnJuO/fWrE+6YtidDU4VKGvDAcorpR
         DC+eRyNV5V9zH4/ucLo0WidhdLOmYyYW7DKeh+DerT766L+rn9hck678w4Jp2TEcyjjX
         AjN0bw7bsdA3yMKoEOVOYvz7fTxR1DAumf+/nY1CxuWtElDADDhfWHRE755UiXjq9/mV
         2w8VD/XoOtSStJlayCQ2HyujcqPHRJhEWSQTvqqWYocguWS+OKWaumQcbl1TSlQd6YI4
         KhUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CBcQOnMbxUrpRaW6VcyeK1/UzStLryrgI/bXrNFSZpQ=;
        b=X5Msqrlvh+z31EeDlGkSKmXCJAmr8s5mN+hLGtcy0BLySOCw96vrFsQD+4bC2GJLLi
         lNkun9lvznlmzRdTC6ScR9qEMYwFvxe0JDWTZ38DFPXpr2tSIKx84me6jQbuGY3kIF6H
         8V9Bnk/guty9DqUJ7gQ53FTUbhtu+UEctstrQf1xWVZE4ROnuOdQ25cF2sTEeuz0tAyu
         G1CH0GnmmuZbDrGMwhSxkPGtEPW/bRzOqQTNr6LnLhoWQ2ARJUbMrmPdJ2A25wiJqYUL
         Fx5BW+vi1wluZSm1jUjWZxm3mvK8OdbKQtwuBnesf1/WHw7hvr6lLEoUMbAsrRO1C7yx
         5xIg==
X-Gm-Message-State: APjAAAWdyCjfvJmyzP2Db0gY4rZBWG7ve/HGsKd5ONwsUsgykp0VCuQM
        mhj/zL7oYMzdtXsAu9F8AFHEs0LeRAfoOI9GVRtuOx6+
X-Google-Smtp-Source: APXvYqyDW/AHi468Lg14t2D1w+TobrUFN8Zi+MKP+blcaG1NVJfFsVz000GyIfkLGfPaLTme7tsOBwcBDUgkY2g8ezY=
X-Received: by 2002:a5e:8704:: with SMTP id y4mr4830713ioj.135.1562341394708;
 Fri, 05 Jul 2019 08:43:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190704085646.12406-1-quentin.monnet@netronome.com>
 <CAH3MdRXuDmXobkXESZg0+VV=FrBLsiAYPC61xQsjx2smKQKUtQ@mail.gmail.com> <b4bbb342-1f77-8669-ec51-8d5542f7e7b4@netronome.com>
In-Reply-To: <b4bbb342-1f77-8669-ec51-8d5542f7e7b4@netronome.com>
From:   Y Song <ys114321@gmail.com>
Date:   Fri, 5 Jul 2019 08:42:38 -0700
Message-ID: <CAH3MdRWcU9=YCO6WuLY2e2-kixE7E8yLBS+fJH4ASh94oHcK-A@mail.gmail.com>
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

On Fri, Jul 5, 2019 at 1:21 AM Quentin Monnet
<quentin.monnet@netronome.com> wrote:
>
> 2019-07-04 22:49 UTC-0700 ~ Y Song <ys114321@gmail.com>
> > On Thu, Jul 4, 2019 at 1:58 AM Quentin Monnet
> > <quentin.monnet@netronome.com> wrote:
> >>
> >> Add a new "bpftool prog run" subcommand to run a loaded program on input
> >> data (and possibly with input context) passed by the user.
> >>
> >> Print output data (and output context if relevant) into a file or into
> >> the console. Print return value and duration for the test run into the
> >> console.
> >>
> >> A "repeat" argument can be passed to run the program several times in a
> >> row.
> >>
> >> The command does not perform any kind of verification based on program
> >> type (Is this program type allowed to use an input context?) or on data
> >> consistency (Can I work with empty input data?), this is left to the
> >> kernel.
> >>
> >> Example invocation:
> >>
> >>     # perl -e 'print "\x0" x 14' | ./bpftool prog run \
> >>             pinned /sys/fs/bpf/sample_ret0 \
> >>             data_in - data_out - repeat 5
> >>     0000000 0000 0000 0000 0000 0000 0000 0000      | ........ ......
> >>     Return value: 0, duration (average): 260ns
> >>
> >> When one of data_in or ctx_in is "-", bpftool reads from standard input,
> >> in binary format. Other formats (JSON, hexdump) might be supported (via
> >> an optional command line keyword like "data_fmt_in") in the future if
> >> relevant, but this would require doing more parsing in bpftool.
> >>
> >> Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
> >> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> >> ---
>
> [...]
>
> >> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> >> index 9b0db5d14e31..8dcbaa0a8ab1 100644
> >> --- a/tools/bpf/bpftool/prog.c
> >> +++ b/tools/bpf/bpftool/prog.c
> >> @@ -15,6 +15,7 @@
> >>  #include <sys/stat.h>
> >>
> >>  #include <linux/err.h>
> >> +#include <linux/sizes.h>
> >>
> >>  #include <bpf.h>
> >>  #include <btf.h>
> >> @@ -748,6 +749,344 @@ static int do_detach(int argc, char **argv)
> >>         return 0;
> >>  }
> >>
> >> +static int check_single_stdin(char *file_in, char *other_file_in)
> >> +{
> >> +       if (file_in && other_file_in &&
> >> +           !strcmp(file_in, "-") && !strcmp(other_file_in, "-")) {
> >> +               p_err("cannot use standard input for both data_in and ctx_in");
> >
> > The error message says data_in and ctx_in.
> > Maybe the input parameter should be file_data_in and file_ctx_in?
>
>
> Hi Yonghong,
>
> It's true those parameters should be file names. But having
> "file_data_in", "file_data_out", "file_ctx_in" and "file_ctx_out" on a
> command line seems a bit heavy to me? (And relying on keyword prefixing
> for typing the command won't help much.)
>
> My opinion is that it should be clear from the man page or the "help"
> command that the parameters are file names. What do you think? I can
> prefix all four arguments with "file_" if you believe this is better.

I think you misunderstood my question above. The command line
parameters are fine.
I am talking about the function parameter names. Since in the error message,
the input parameters are referred for data_in and ctx_in
   p_err("cannot use standard input for both data_in and ctx_in")
maybe the function signature should be
  static int check_single_stdin(char *file_data_in, char *file_ctx_in)

If you are worried that later on the same function can be used in different
contexts, then alternatively, you can have signature like
  static int check_single_stdin(char *file_in, char *other_file_in,
const char *file_in_arg, const char *other_file_in_arg)
where file_in_arg will be passed in as "data_in" and other_file_in_arg
as "ctx_in".
I think we could delay this until it is really needed.

>
> [...]
>
> >> +static int do_run(int argc, char **argv)
> >> +{
> >> +       char *data_fname_in = NULL, *data_fname_out = NULL;
> >> +       char *ctx_fname_in = NULL, *ctx_fname_out = NULL;
> >> +       struct bpf_prog_test_run_attr test_attr = {0};
> >> +       const unsigned int default_size = SZ_32K;
> >> +       void *data_in = NULL, *data_out = NULL;
> >> +       void *ctx_in = NULL, *ctx_out = NULL;
> >> +       unsigned int repeat = 1;
> >> +       int fd, err;
> >> +
> >> +       if (!REQ_ARGS(4))
> >> +               return -1;
> >> +
> >> +       fd = prog_parse_fd(&argc, &argv);
> >> +       if (fd < 0)
> >> +               return -1;
> >> +
> >> +       while (argc) {
> >> +               if (detect_common_prefix(*argv, "data_in", "data_out",
> >> +                                        "data_size_out", NULL))
> >> +                       return -1;
> >> +               if (detect_common_prefix(*argv, "ctx_in", "ctx_out",
> >> +                                        "ctx_size_out", NULL))
> >> +                       return -1;
> >> +
> >> +               if (is_prefix(*argv, "data_in")) {
> >> +                       NEXT_ARG();
> >> +                       if (!REQ_ARGS(1))
> >> +                               return -1;
> >> +
> >> +                       data_fname_in = GET_ARG();
> >> +                       if (check_single_stdin(data_fname_in, ctx_fname_in))
> >> +                               return -1;
> >> +               } else if (is_prefix(*argv, "data_out")) {
> >
> > Here, we all use is_prefix() to match "data_in", "data_out",
> > "data_size_out" etc.
> > That means users can use "data_i" instead of "data_in" as below
> >    ... | ./bpftool prog run id 283 data_i - data_out - repeat 5
> > is this expected?
> Yes, this is expected. We use prefix matching as we do pretty much
> everywhere else in bpftool. It's not as useful here because most of the
> strings for the names are similar. I agree that typing "data_i" instead
> of "data_in" brings little advantage, but I see no reason why we should
> reject prefixing for those keywords. And we accept "data_s" instead of
> "data_size_out", which is still shorter to type than the complete keyword.

This makes sense. Thanks for explanation.

Another question. Currently, you are proposing "./bpftool prog run ...",
but actually it is just a test_run. Do you think we should rename it
to "./bpftool prog test_run ..." to make it clear for its intention?

>
> Thanks for the review!
> Quentin
