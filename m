Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5132585458
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 22:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389087AbfHGUMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 16:12:55 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:38605 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388370AbfHGUMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 16:12:55 -0400
Received: by mail-ot1-f68.google.com with SMTP id d17so109490275oth.5
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 13:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1oh5bsfFCVZb5kY/dpDe0n4LD02f+YqbQLYWBHioF7I=;
        b=Grwq428wcA4tv+/x4dhF82O2She4sPriL/938qboKQ3icCm0C9JTXD4QEo+eE6TtVH
         hObvRcxWcjRPixYTTz2iOBpuRPJJj60LcSFlcaWgDNQYdjKvVJ2Q3062N9W1qjZxH7KK
         mEvEOWaUE79/IY2gIsHBsUyF/69Xywh7hssafdzJfbqaGUdTxIlmCvchycAj7qpf/H8d
         zYBQlJq+c8qDIQTPfPXU5TV5veiw+TNkGyktL+exKTiu3t5XcLzOEafmU7byuFIktRGG
         Dt8eJx13OcOUpuH7HghjjFBJO0FOCSZ0Dj8ClMCeh7Es1TXHvt9+Z/Ax0hHLDKj+DzMX
         /wFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1oh5bsfFCVZb5kY/dpDe0n4LD02f+YqbQLYWBHioF7I=;
        b=EvUmu65VBXgCWyS5tnozyWQuFG11VrA0VijfX785v0nBhXp6TWAUhqK+fAtToxwlbG
         Lj9UsqeSWnyJhV3D5mZ8Ybfg83m1amDPKU201Y20bTTMDaHeaRFhWMR6ylFty6CD6ckN
         5xlH6V+n54ak7kdYaVJtiGuZ+ASHXEA/gkxD5tyCytdB1CH4xY48KrlC+9a01EHNQZ9l
         CI6mXZwIvNeI9I1tiWh3oVIlYCT7Ue1CZ4JA6aPG8Apw17+K52xLS18JAHPp/t2c1wti
         P9BhNk2dGv+q2fnPK901afz2NwLCuR8oAgzFAgXe9LKc2sHoF6HVaLyy4UKidsYckR9y
         RbSw==
X-Gm-Message-State: APjAAAV/QXpaAnjnQQc7HmrrEDL8a1Z6cHN7DTunV/PSOSV+kB4wVsoL
        TyuH5UIRCC/GlD82Qh61Fr753RDnRlrlZQELxl1Tfnqt
X-Google-Smtp-Source: APXvYqyja2M/YSWcHViFZOjudDurPb1adi83fRdeorlNFoYRhGFwhzg1kpU2dsl/RSHJnX7wbbHunZJLu1LW/i2HEnQ=
X-Received: by 2002:a05:6602:24d2:: with SMTP id h18mr5286229ioe.221.1565208773924;
 Wed, 07 Aug 2019 13:12:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190807022509.4214-1-danieltimlee@gmail.com> <20190807022509.4214-3-danieltimlee@gmail.com>
 <CAH3MdRW4LgdLoqSpLsWUOwjnNhJA1sodHqSD2Z14JY6aHMaKxg@mail.gmail.com> <20190807203041.000020a8@gmail.com>
In-Reply-To: <20190807203041.000020a8@gmail.com>
From:   Y Song <ys114321@gmail.com>
Date:   Wed, 7 Aug 2019 13:12:17 -0700
Message-ID: <CAH3MdRX2SYj+79+L_FJtxMQZfPQDtYDFEbgH6VGAKMYnBXU4Vw@mail.gmail.com>
Subject: Re: [v3,2/4] tools: bpftool: add net detach command to detach XDP on interface
To:     Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Cc:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 7, 2019 at 11:30 AM Maciej Fijalkowski
<maciejromanfijalkowski@gmail.com> wrote:
>
> On Wed, 7 Aug 2019 10:02:04 -0700
> Y Song <ys114321@gmail.com> wrote:
>
> > On Tue, Aug 6, 2019 at 7:25 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> > >
> > > By this commit, using `bpftool net detach`, the attached XDP prog can
> > > be detached. Detaching the BPF prog will be done through libbpf
> > > 'bpf_set_link_xdp_fd' with the progfd set to -1.
> > >
> > > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > > ---
> > >  tools/bpf/bpftool/net.c | 42 ++++++++++++++++++++++++++++++++++++++++-
> > >  1 file changed, 41 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
> > > index c05a3fac5cac..7be96acb08e0 100644
> > > --- a/tools/bpf/bpftool/net.c
> > > +++ b/tools/bpf/bpftool/net.c
> > > @@ -343,6 +343,43 @@ static int do_attach(int argc, char **argv)
> > >         return 0;
> > >  }
> > >
> > > +static int do_detach(int argc, char **argv)
> > > +{
> > > +       enum net_attach_type attach_type;
> > > +       int progfd, ifindex, err = 0;
> > > +
> > > +       /* parse detach args */
> > > +       if (!REQ_ARGS(3))
> > > +               return -EINVAL;
> > > +
> > > +       attach_type = parse_attach_type(*argv);
> > > +       if (attach_type == max_net_attach_type) {
> > > +               p_err("invalid net attach/detach type");
> > > +               return -EINVAL;
> > > +       }
> > > +
> > > +       NEXT_ARG();
> > > +       ifindex = net_parse_dev(&argc, &argv);
> > > +       if (ifindex < 1)
> > > +               return -EINVAL;
> > > +
> > > +       /* detach xdp prog */
> > > +       progfd = -1;
> > > +       if (is_prefix("xdp", attach_type_strings[attach_type]))
> > > +               err = do_attach_detach_xdp(progfd, attach_type, ifindex, NULL);
> >
> > I found an issue here. This is probably related to do_attach_detach_xdp.
> >
> > -bash-4.4$ sudo ./bpftool net attach x pinned /sys/fs/bpf/xdp_example dev v1
> > -bash-4.4$ sudo ./bpftool net
> > xdp:
> > v1(4) driver id 1172
> >
> > tc:
> > eth0(2) clsact/ingress fbflow_icmp id 29 act []
> > eth0(2) clsact/egress cls_fg_dscp_section id 27 act []
> > eth0(2) clsact/egress fbflow_egress id 28
> > eth0(2) clsact/egress fbflow_sslwall_egress id 35
> >
> > flow_dissector:
> >
> > -bash-4.4$ sudo ./bpftool net detach x dev v2
>
> Shouldn't this be v1 as dev?

I am testing a scenario where with wrong devname
we did not return an error.

Yes, if dev "v1", it works as expected.

>
> > -bash-4.4$ sudo ./bpftool net
> > xdp:
> > v1(4) driver id 1172
> >
> > tc:
> > eth0(2) clsact/ingress fbflow_icmp id 29 act []
> > eth0(2) clsact/egress cls_fg_dscp_section id 27 act []
> > eth0(2) clsact/egress fbflow_egress id 28
> > eth0(2) clsact/egress fbflow_sslwall_egress id 35
> >
> > flow_dissector:
> >
> > -bash-4.4$
> >
> > Basically detaching may fail due to wrong dev name or wrong type, etc.
> > But the tool did not return an error. Is this expected?
> > This may be related to this funciton "bpf_set_link_xdp_fd()".
> > So this patch itself should be okay.
> >
> > > +
> > > +       if (err < 0) {
> > > +               p_err("interface %s detach failed",
> > > +                     attach_type_strings[attach_type]);
> > > +               return err;
> > > +       }
> > > +
> > > +       if (json_output)
> > > +               jsonw_null(json_wtr);
> > > +
> > > +       return 0;
> > > +}
> > > +
> > >  static int do_show(int argc, char **argv)
> > >  {
> > >         struct bpf_attach_info attach_info = {};
> > > @@ -419,6 +456,7 @@ static int do_help(int argc, char **argv)
> > >         fprintf(stderr,
> > >                 "Usage: %s %s { show | list } [dev <devname>]\n"
> > >                 "       %s %s attach ATTACH_TYPE PROG dev <devname> [ overwrite ]\n"
> > > +               "       %s %s detach ATTACH_TYPE dev <devname>\n"
> > >                 "       %s %s help\n"
> > >                 "\n"
> > >                 "       " HELP_SPEC_PROGRAM "\n"
> > > @@ -429,7 +467,8 @@ static int do_help(int argc, char **argv)
> > >                 "      to dump program attachments. For program types\n"
> > >                 "      sk_{filter,skb,msg,reuseport} and lwt/seg6, please\n"
> > >                 "      consult iproute2.\n",
> > > -               bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2]);
> > > +               bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
> > > +               bin_name, argv[-2]);
> > >
> > >         return 0;
> > >  }
> > > @@ -438,6 +477,7 @@ static const struct cmd cmds[] = {
> > >         { "show",       do_show },
> > >         { "list",       do_show },
> > >         { "attach",     do_attach },
> > > +       { "detach",     do_detach },
> > >         { "help",       do_help },
> > >         { 0 }
> > >  };
> > > --
> > > 2.20.1
> > >
>
