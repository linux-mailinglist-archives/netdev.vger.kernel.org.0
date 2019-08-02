Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7077EF5D
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 10:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730109AbfHBIdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 04:33:24 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:33003 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbfHBIdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 04:33:24 -0400
Received: by mail-yb1-f193.google.com with SMTP id c202so25273035ybf.0
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 01:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gaAt2HptpH3VfHFvLYjQ2ED1AHfEfrz+iVdJJCg06kQ=;
        b=FLjLIhp+Sh+DBvUtl1o5kwxGNSaqiY0XFo4WRsdlwHquu76LlbwVEBz3m2LF/hgxp8
         NFjMoCCUPsndVJyf56PX2D7t6jna7Ws7gc/v/3XdEpEWRTmh8wJ75He2qk/bBaaZGewH
         m+7krkHy/WGW0Rixn4A8f1sVKNbL7HaioCqvqitsChZ7P7vQB7UvuPZW/4E1BcS2CqoS
         k+Wfi93oj/OcbKD6jaJ232Jh64qbzLU6xS6BARI6UkGVfmOGZPsAySXvHvOZs9q/Zln/
         qfoAPBZbM7IOtx297iRMSohHKRu0POcIBi3KteeVfmpFgpDj/dKWLTXGbTtToPJQLD8q
         gR/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gaAt2HptpH3VfHFvLYjQ2ED1AHfEfrz+iVdJJCg06kQ=;
        b=JOI87UnmdUfpDwwtgMi3cexF3ifQIYxoHalZIMUIH1sBV9jHuEYNqACW/Zgev70L77
         nT2UDJUfm4UrA7jfH+1PjXQActu8/iOgUtrVGCFMarGVcn/bJJ8ajKCCcTgL59Fqo1a+
         bT/dJKzp9YdjsxdXbrP7KpRXVjr8kSDoxWfOi1cZzTFSo6Ku66pGzWgCxcf0WUOFq3cr
         6OXf6GC2bcLEusH6ZvmdSJZOGXfvkI2RWd7ZUAp1ddpg6Ctz27Hv4Yl9PX082Q88mE24
         gQe7np6rayveL73A2aCi8K11GuBesJaQTX6WjFa55usLi+8ehbeFAaW8y5lWYe1GTDYV
         wHAA==
X-Gm-Message-State: APjAAAWj4Q38AXKuQIrKAtGfDlZBuJJC39mp9B0N5wQb5B5AKoXzq/jO
        qlOpyHbER9l39Yo3OmUHY3e25UuD+IMWu68AGQ==
X-Google-Smtp-Source: APXvYqzDdM7h+rO+lQdxMvL+GCXWQKpDPpNPF7WinWZ2cC/kxG5yTEl3FGACQ1acStCgy6hzvLEIiGG8QohvEYQrUyo=
X-Received: by 2002:a25:3b85:: with SMTP id i127mr45127391yba.164.1564734802825;
 Fri, 02 Aug 2019 01:33:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190801081133.13200-1-danieltimlee@gmail.com>
 <20190801081133.13200-3-danieltimlee@gmail.com> <CAH3MdRX_OCnN82GESHBD+-wZvZqo7fba0ExDyqTh_3_tfRR1Nw@mail.gmail.com>
In-Reply-To: <CAH3MdRX_OCnN82GESHBD+-wZvZqo7fba0ExDyqTh_3_tfRR1Nw@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Fri, 2 Aug 2019 17:33:11 +0900
Message-ID: <CAEKGpzhojaGucesAGJzQg9e_pwZR6Mg22y_6_jHOQeWer3_AFA@mail.gmail.com>
Subject: Re: [v2,2/2] tools: bpftool: add net detach command to detach XDP on interface
To:     Y Song <ys114321@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 2, 2019 at 3:26 PM Y Song <ys114321@gmail.com> wrote:
>
> On Thu, Aug 1, 2019 at 2:04 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > By this commit, using `bpftool net detach`, the attached XDP prog can
> > be detached. Detaching the BPF prog will be done through libbpf
> > 'bpf_set_link_xdp_fd' with the progfd set to -1.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
> > Changes in v2:
> >   - command 'unload' changed to 'detach' for the consistency
> >
> >  tools/bpf/bpftool/net.c | 55 ++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 54 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
> > index f3b57660b303..2ae9a613b05c 100644
> > --- a/tools/bpf/bpftool/net.c
> > +++ b/tools/bpf/bpftool/net.c
> > @@ -281,6 +281,31 @@ static int parse_attach_args(int argc, char **argv, int *progfd,
> >         return 0;
> >  }
> >
> > +static int parse_detach_args(int argc, char **argv,
> > +                            enum net_attach_type *attach_type, int *ifindex)
> > +{
> > +       if (!REQ_ARGS(2))
> > +               return -EINVAL;
> > +
> > +       *attach_type = parse_attach_type(*argv);
> > +       if (*attach_type == __MAX_NET_ATTACH_TYPE) {
> > +               p_err("invalid net attach/detach type");
> > +               return -EINVAL;
> > +       }
> > +
> > +       NEXT_ARG();
> > +       if (!REQ_ARGS(1))
> > +               return -EINVAL;
> > +
> > +       *ifindex = if_nametoindex(*argv);
> > +       if (!*ifindex) {
> > +               p_err("Invalid ifname");
> > +               return -EINVAL;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> >  static int do_attach_detach_xdp(int *progfd, enum net_attach_type *attach_type,
> >                                 int *ifindex)
> >  {
> > @@ -323,6 +348,31 @@ static int do_attach(int argc, char **argv)
> >         return 0;
> >  }
> >
> > +static int do_detach(int argc, char **argv)
> > +{
> > +       enum net_attach_type attach_type;
> > +       int err, progfd, ifindex;
> > +
> > +       err = parse_detach_args(argc, argv, &attach_type, &ifindex);
> > +       if (err)
> > +               return err;
> > +
> > +       /* to detach xdp prog */
> > +       progfd = -1;
> > +       if (is_prefix("xdp", attach_type_strings[attach_type]))
> > +               err = do_attach_detach_xdp(&progfd, &attach_type, &ifindex);
>
> Similar to previous patch, parameters no need to be pointer.
>

I will change the parameter as pass by value.

> > +
> > +       if (err < 0) {
> > +               p_err("link set %s failed", attach_type_strings[attach_type]);
> > +               return -1;
>
> Maybe "return err"?
>

Hadn't thought of that.
I will change to it!

> > +       }
> > +
> > +       if (json_output)
> > +               jsonw_null(json_wtr);
> > +
> > +       return 0;
> > +}
> > +
> >  static int do_show(int argc, char **argv)
> >  {
> >         struct bpf_attach_info attach_info = {};
> > @@ -406,6 +456,7 @@ static int do_help(int argc, char **argv)
> >         fprintf(stderr,
> >                 "Usage: %s %s { show | list } [dev <devname>]\n"
> >                 "       %s %s attach PROG LOAD_TYPE <devname>\n"
> > +               "       %s %s detach LOAD_TYPE <devname>\n"
> >                 "       %s %s help\n"
> >                 "\n"
> >                 "       " HELP_SPEC_PROGRAM "\n"
> > @@ -415,7 +466,8 @@ static int do_help(int argc, char **argv)
> >                 "      to dump program attachments. For program types\n"
> >                 "      sk_{filter,skb,msg,reuseport} and lwt/seg6, please\n"
> >                 "      consult iproute2.\n",
> > -               bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2]);
> > +               bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
> > +               bin_name, argv[-2]);
> >
> >         return 0;
> >  }
> > @@ -424,6 +476,7 @@ static const struct cmd cmds[] = {
> >         { "show",       do_show },
> >         { "list",       do_show },
> >         { "attach",     do_attach },
> > +       { "detach",     do_detach },
> >         { "help",       do_help },
> >         { 0 }
> >  };
> > --
> > 2.20.1
> >

Thanks for the review!
