Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 272F186AD3
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 21:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404065AbfHHTwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 15:52:49 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:37749 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729925AbfHHTwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 15:52:49 -0400
Received: by mail-ot1-f68.google.com with SMTP id s20so57983735otp.4
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 12:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dCvqLNFOk4lg/MRBd6wu4rgIRCqaPxyObdf8nc1oudU=;
        b=eP0udEy2rWvw55GX8A5uQNl1rKN9sP+kGDS4R7z6VW9kML44ybWft/+y4Wo/iXnSpu
         h/KfHhs3AuodQG/CQb0LaHXee8CpkAI1KhVI8quz74A8S/aAFvNxTN+bWMI608/nW+KL
         AAC/TBBnQ8Q1zC7NPvKrMLPvGUFGGJcqUvGshqYEQrLlyS+YNgwbEltxpR+a3T3ZKzlx
         NwWQJsD/nth+4NLXH1w8nyd1FvkKgLp67MkIOLScRIl5vzySnQAhW2yzncJoCY3N0yRB
         FtAdLl+0Wc/IUHg9Gv1YNK0JKsnW/IrBOM655VibyjQ4304c/QjBjKKr+BIFBw6Ev9B6
         7Giw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dCvqLNFOk4lg/MRBd6wu4rgIRCqaPxyObdf8nc1oudU=;
        b=BRKaK7ySfE988De+5RLWsBGcKvrykkZjwX/ZMexjWI/b55cwefUwdf4P+I/wPa+MRS
         8ZYGsgRhT402djzZ+zGAD0uHhS/2ibLYYGV4EoDHYnyl22a7qrLtfdLco2SyhE00UxO1
         6DxTP34uKrlRr37u6Ck76a0fljgszgSXK1UgyEJFMhMciLInWw81hls7Im+Zaxg1o5NF
         ZUNKLJzu47OBwL9yKTDYJxfQAa6XEqZn5SNL9WMEjaJ5LBvBnQu96sDm+tOgAR+b72/Z
         WJroSU6rZigTDv5cDEZYj2X3THHHP80HMe9HrTi/UdIi1jfAM+6dPRlQeQ0Yjnjxa8pw
         c69Q==
X-Gm-Message-State: APjAAAWa/eYJ60A/1B4wzQocFrib45TjoMQmRsvwmIMHdqW5dAAIK2Rj
        LSJqtZqU4mfDgsnjITluj67FkLG1VQfXEDCXvRY=
X-Google-Smtp-Source: APXvYqypMsgjc2EQAxbTTgLM7gyG8f62bLx5ly88q0GNEWIgrWn/mCNfJkQcqvs9QS97MjoDNG1lLyeH4G29xI7L1xE=
X-Received: by 2002:a5d:9448:: with SMTP id x8mr18292149ior.102.1565293967945;
 Thu, 08 Aug 2019 12:52:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190807022509.4214-1-danieltimlee@gmail.com> <20190807022509.4214-3-danieltimlee@gmail.com>
 <CAH3MdRW4LgdLoqSpLsWUOwjnNhJA1sodHqSD2Z14JY6aHMaKxg@mail.gmail.com>
 <20190807203041.000020a8@gmail.com> <CAH3MdRX2SYj+79+L_FJtxMQZfPQDtYDFEbgH6VGAKMYnBXU4Vw@mail.gmail.com>
 <20190807223807.00002740@gmail.com>
In-Reply-To: <20190807223807.00002740@gmail.com>
From:   Y Song <ys114321@gmail.com>
Date:   Thu, 8 Aug 2019 12:52:11 -0700
Message-ID: <CAH3MdRWeD+9Lmz+mJt3EnNkX8kbcyCW4sNgRindCiObnzAj-yQ@mail.gmail.com>
Subject: Re: [v3,2/4] tools: bpftool: add net detach command to detach XDP on interface
To:     Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Cc:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 7, 2019 at 1:40 PM Maciej Fijalkowski
<maciejromanfijalkowski@gmail.com> wrote:
>
> On Wed, 7 Aug 2019 13:12:17 -0700
> Y Song <ys114321@gmail.com> wrote:
>
> > On Wed, Aug 7, 2019 at 11:30 AM Maciej Fijalkowski
> > <maciejromanfijalkowski@gmail.com> wrote:
> > >
> > > On Wed, 7 Aug 2019 10:02:04 -0700
> > > Y Song <ys114321@gmail.com> wrote:
> > >
> > > > On Tue, Aug 6, 2019 at 7:25 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> > > > >
> > > > > By this commit, using `bpftool net detach`, the attached XDP prog can
> > > > > be detached. Detaching the BPF prog will be done through libbpf
> > > > > 'bpf_set_link_xdp_fd' with the progfd set to -1.
> > > > >
> > > > > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > > > > ---
> > > > >  tools/bpf/bpftool/net.c | 42 ++++++++++++++++++++++++++++++++++++++++-
> > > > >  1 file changed, 41 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
> > > > > index c05a3fac5cac..7be96acb08e0 100644
> > > > > --- a/tools/bpf/bpftool/net.c
> > > > > +++ b/tools/bpf/bpftool/net.c
> > > > > @@ -343,6 +343,43 @@ static int do_attach(int argc, char **argv)
> > > > >         return 0;
> > > > >  }
> > > > >
> > > > > +static int do_detach(int argc, char **argv)
> > > > > +{
> > > > > +       enum net_attach_type attach_type;
> > > > > +       int progfd, ifindex, err = 0;
> > > > > +
> > > > > +       /* parse detach args */
> > > > > +       if (!REQ_ARGS(3))
> > > > > +               return -EINVAL;
> > > > > +
> > > > > +       attach_type = parse_attach_type(*argv);
> > > > > +       if (attach_type == max_net_attach_type) {
> > > > > +               p_err("invalid net attach/detach type");
> > > > > +               return -EINVAL;
> > > > > +       }
> > > > > +
> > > > > +       NEXT_ARG();
> > > > > +       ifindex = net_parse_dev(&argc, &argv);
> > > > > +       if (ifindex < 1)
> > > > > +               return -EINVAL;
> > > > > +
> > > > > +       /* detach xdp prog */
> > > > > +       progfd = -1;
> > > > > +       if (is_prefix("xdp", attach_type_strings[attach_type]))
> > > > > +               err = do_attach_detach_xdp(progfd, attach_type, ifindex, NULL);
> > > >
> > > > I found an issue here. This is probably related to do_attach_detach_xdp.
> > > >
> > > > -bash-4.4$ sudo ./bpftool net attach x pinned /sys/fs/bpf/xdp_example dev v1
> > > > -bash-4.4$ sudo ./bpftool net
> > > > xdp:
> > > > v1(4) driver id 1172
> > > >
> > > > tc:
> > > > eth0(2) clsact/ingress fbflow_icmp id 29 act []
> > > > eth0(2) clsact/egress cls_fg_dscp_section id 27 act []
> > > > eth0(2) clsact/egress fbflow_egress id 28
> > > > eth0(2) clsact/egress fbflow_sslwall_egress id 35
> > > >
> > > > flow_dissector:
> > > >
> > > > -bash-4.4$ sudo ./bpftool net detach x dev v2
> > >
> > > Shouldn't this be v1 as dev?
> >
> > I am testing a scenario where with wrong devname
> > we did not return an error.
>
> Ah ok. In this scenario if driver has a native xdp support we would be invoking
> its ndo_bpf even if there's no prog currently attached and it wouldn't return
> error value.
>
> Looking at dev_xdp_uninstall, setting driver's prog to NULL is being done only
> when prog is attached. Maybe we should consider querying the driver in
> dev_change_xdp_fd regardless of passed fd value? E.g. don't query only when
> prog >= 0.
>
> I don't recall whether this was brought up previously.

Thanks for explanation. I think return an error is better in
such error cases. Otherwise, people mistakenly write wrong
device name and they may think xdp is detached and it is
actually not.

But this probably should not prevent
this patch as it is more like a kernel issue.

>
> CCing Jakub so we have one thread.
>
> Maciej
>
> >
> > Yes, if dev "v1", it works as expected.
> >
> > >
> > > > -bash-4.4$ sudo ./bpftool net
> > > > xdp:
> > > > v1(4) driver id 1172
> > > >
> > > > tc:
> > > > eth0(2) clsact/ingress fbflow_icmp id 29 act []
> > > > eth0(2) clsact/egress cls_fg_dscp_section id 27 act []
> > > > eth0(2) clsact/egress fbflow_egress id 28
> > > > eth0(2) clsact/egress fbflow_sslwall_egress id 35
> > > >
> > > > flow_dissector:
> > > >
> > > > -bash-4.4$
> > > >
> > > > Basically detaching may fail due to wrong dev name or wrong type, etc.
> > > > But the tool did not return an error. Is this expected?
> > > > This may be related to this funciton "bpf_set_link_xdp_fd()".
> > > > So this patch itself should be okay.
> > > >
> > > > > +
> > > > > +       if (err < 0) {
> > > > > +               p_err("interface %s detach failed",
> > > > > +                     attach_type_strings[attach_type]);
> > > > > +               return err;
> > > > > +       }
> > > > > +
> > > > > +       if (json_output)
> > > > > +               jsonw_null(json_wtr);
> > > > > +
> > > > > +       return 0;
> > > > > +}
> > > > > +
> > > > >  static int do_show(int argc, char **argv)
> > > > >  {
> > > > >         struct bpf_attach_info attach_info = {};
> > > > > @@ -419,6 +456,7 @@ static int do_help(int argc, char **argv)
> > > > >         fprintf(stderr,
> > > > >                 "Usage: %s %s { show | list } [dev <devname>]\n"
> > > > >                 "       %s %s attach ATTACH_TYPE PROG dev <devname> [ overwrite ]\n"
> > > > > +               "       %s %s detach ATTACH_TYPE dev <devname>\n"
> > > > >                 "       %s %s help\n"
> > > > >                 "\n"
> > > > >                 "       " HELP_SPEC_PROGRAM "\n"
> > > > > @@ -429,7 +467,8 @@ static int do_help(int argc, char **argv)
> > > > >                 "      to dump program attachments. For program types\n"
> > > > >                 "      sk_{filter,skb,msg,reuseport} and lwt/seg6, please\n"
> > > > >                 "      consult iproute2.\n",
> > > > > -               bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2]);
> > > > > +               bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
> > > > > +               bin_name, argv[-2]);
> > > > >
> > > > >         return 0;
> > > > >  }
> > > > > @@ -438,6 +477,7 @@ static const struct cmd cmds[] = {
> > > > >         { "show",       do_show },
> > > > >         { "list",       do_show },
> > > > >         { "attach",     do_attach },
> > > > > +       { "detach",     do_detach },
> > > > >         { "help",       do_help },
> > > > >         { 0 }
> > > > >  };
> > > > > --
> > > > > 2.20.1
> > > > >
> > >
>
