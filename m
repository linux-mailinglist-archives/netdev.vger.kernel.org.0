Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCCE8852FB
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 20:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389232AbfHGSav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 14:30:51 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44963 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388428AbfHGSau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 14:30:50 -0400
Received: by mail-pl1-f194.google.com with SMTP id t14so42016966plr.11
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 11:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GwDwoFXpYOVfqW6O5/krm4x8AMkajjrtYZGGkANZ+Ng=;
        b=R88YDq571WPLh0mYvbk87Lm8oRKzamAqKsI613U8gtd+jg/8t8NRpyiPL5Tt9tHGBb
         1UqrIzbFe40aOADs/2vD1RQOoMkmtzq552mpGHqGo5B6qW7YkCqyvmiLbCiNgC1Y8CyQ
         MWq7GlkaZOH+VNRVshVdVvok+slVsyVyLfL+k6J/6pS0KCvqcb/Eriv9C5sezoLB2PqO
         bpwD9oCtrod2aHlaWfHxiXJKwaMmlq17yfucSYJSVPSEqQEglp9qnvkfUXaVJkbNyv3i
         ai9R+4n6/4mINlEnGmExsbJeADvwzWV2B8hRsNMXvkkV3d9IcMaTLeQb3ug7COOcBAe5
         j2pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GwDwoFXpYOVfqW6O5/krm4x8AMkajjrtYZGGkANZ+Ng=;
        b=oIENy4xIxwIlC/SuPIuNVWFv9xNh1WSjsUXLt9Dzm1Pjwan47Xl63/GbUlnkwLy+ib
         GmYi9QyctDXf71Oprikq7/g4B2NL0P0R/9f5mtZ2J4VoTruGSAyy2nAlymnxzWXz2TOv
         /DeA9AEnWy7azb2xERIZjJKvXcJjwjPK9gjajoB/dJf0B65dFXbsgeUFSSRVXy2dy2cv
         dxq8w8LzC0GZUbL90oyet98GoaiVdDKSqpL0+sHG+VQgiuN2GHMGHHjiGMCvFatyJ60G
         l5c055Rq5ucOU9RB1v3nmcqz1nHZLQydhxoA3ZRs6J1dk9qxAgRqk7W+GjgWY/n7l1V5
         FNHA==
X-Gm-Message-State: APjAAAVYHoFI1/DATtDfs+1zBsZpxO+ubZpqmji+x8+aLqB3FXjc9lVg
        0OdU9vQSfvwDjevDHkWr0vg=
X-Google-Smtp-Source: APXvYqzhkOZ3vx5zo+nkkwjlPcs9aF49jxsPzUngQOMtH02Ajw5yer7uh9K4sr0zR1xzn+25vVg6Bw==
X-Received: by 2002:a17:90a:9505:: with SMTP id t5mr1226264pjo.96.1565202649687;
        Wed, 07 Aug 2019 11:30:49 -0700 (PDT)
Received: from localhost (fmdmzpr04-ext.fm.intel.com. [192.55.54.39])
        by smtp.gmail.com with ESMTPSA id b24sm19956135pgw.66.2019.08.07.11.30.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 07 Aug 2019 11:30:49 -0700 (PDT)
Date:   Wed, 7 Aug 2019 20:30:41 +0200
From:   Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
To:     Y Song <ys114321@gmail.com>
Cc:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [v3,2/4] tools: bpftool: add net detach command to detach XDP
 on interface
Message-ID: <20190807203041.000020a8@gmail.com>
In-Reply-To: <CAH3MdRW4LgdLoqSpLsWUOwjnNhJA1sodHqSD2Z14JY6aHMaKxg@mail.gmail.com>
References: <20190807022509.4214-1-danieltimlee@gmail.com>
        <20190807022509.4214-3-danieltimlee@gmail.com>
        <CAH3MdRW4LgdLoqSpLsWUOwjnNhJA1sodHqSD2Z14JY6aHMaKxg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Aug 2019 10:02:04 -0700
Y Song <ys114321@gmail.com> wrote:

> On Tue, Aug 6, 2019 at 7:25 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > By this commit, using `bpftool net detach`, the attached XDP prog can
> > be detached. Detaching the BPF prog will be done through libbpf
> > 'bpf_set_link_xdp_fd' with the progfd set to -1.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
> >  tools/bpf/bpftool/net.c | 42 ++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 41 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
> > index c05a3fac5cac..7be96acb08e0 100644
> > --- a/tools/bpf/bpftool/net.c
> > +++ b/tools/bpf/bpftool/net.c
> > @@ -343,6 +343,43 @@ static int do_attach(int argc, char **argv)
> >         return 0;
> >  }
> >
> > +static int do_detach(int argc, char **argv)
> > +{
> > +       enum net_attach_type attach_type;
> > +       int progfd, ifindex, err = 0;
> > +
> > +       /* parse detach args */
> > +       if (!REQ_ARGS(3))
> > +               return -EINVAL;
> > +
> > +       attach_type = parse_attach_type(*argv);
> > +       if (attach_type == max_net_attach_type) {
> > +               p_err("invalid net attach/detach type");
> > +               return -EINVAL;
> > +       }
> > +
> > +       NEXT_ARG();
> > +       ifindex = net_parse_dev(&argc, &argv);
> > +       if (ifindex < 1)
> > +               return -EINVAL;
> > +
> > +       /* detach xdp prog */
> > +       progfd = -1;
> > +       if (is_prefix("xdp", attach_type_strings[attach_type]))
> > +               err = do_attach_detach_xdp(progfd, attach_type, ifindex, NULL);  
> 
> I found an issue here. This is probably related to do_attach_detach_xdp.
> 
> -bash-4.4$ sudo ./bpftool net attach x pinned /sys/fs/bpf/xdp_example dev v1
> -bash-4.4$ sudo ./bpftool net
> xdp:
> v1(4) driver id 1172
> 
> tc:
> eth0(2) clsact/ingress fbflow_icmp id 29 act []
> eth0(2) clsact/egress cls_fg_dscp_section id 27 act []
> eth0(2) clsact/egress fbflow_egress id 28
> eth0(2) clsact/egress fbflow_sslwall_egress id 35
> 
> flow_dissector:
> 
> -bash-4.4$ sudo ./bpftool net detach x dev v2

Shouldn't this be v1 as dev?

> -bash-4.4$ sudo ./bpftool net
> xdp:
> v1(4) driver id 1172
> 
> tc:
> eth0(2) clsact/ingress fbflow_icmp id 29 act []
> eth0(2) clsact/egress cls_fg_dscp_section id 27 act []
> eth0(2) clsact/egress fbflow_egress id 28
> eth0(2) clsact/egress fbflow_sslwall_egress id 35
> 
> flow_dissector:
> 
> -bash-4.4$
> 
> Basically detaching may fail due to wrong dev name or wrong type, etc.
> But the tool did not return an error. Is this expected?
> This may be related to this funciton "bpf_set_link_xdp_fd()".
> So this patch itself should be okay.
> 
> > +
> > +       if (err < 0) {
> > +               p_err("interface %s detach failed",
> > +                     attach_type_strings[attach_type]);
> > +               return err;
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
> > @@ -419,6 +456,7 @@ static int do_help(int argc, char **argv)
> >         fprintf(stderr,
> >                 "Usage: %s %s { show | list } [dev <devname>]\n"
> >                 "       %s %s attach ATTACH_TYPE PROG dev <devname> [ overwrite ]\n"
> > +               "       %s %s detach ATTACH_TYPE dev <devname>\n"
> >                 "       %s %s help\n"
> >                 "\n"
> >                 "       " HELP_SPEC_PROGRAM "\n"
> > @@ -429,7 +467,8 @@ static int do_help(int argc, char **argv)
> >                 "      to dump program attachments. For program types\n"
> >                 "      sk_{filter,skb,msg,reuseport} and lwt/seg6, please\n"
> >                 "      consult iproute2.\n",
> > -               bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2]);
> > +               bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
> > +               bin_name, argv[-2]);
> >
> >         return 0;
> >  }
> > @@ -438,6 +477,7 @@ static const struct cmd cmds[] = {
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

