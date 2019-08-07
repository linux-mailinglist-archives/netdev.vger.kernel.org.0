Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5A18548E
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 22:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388857AbfHGUkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 16:40:35 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41908 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388428AbfHGUkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 16:40:35 -0400
Received: by mail-pl1-f193.google.com with SMTP id m9so42352223pls.8
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 13:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7BKNEE72UxSnSKIw4VcoHbrzoR4aXi5X2Q2IPkzNqYw=;
        b=PXR3WCs/a5E92zqc/8umH0P82lEJWKrMS+zDXt5OGC6d6g/BTcYHVcJCrdVKIlw8y7
         TAx59XFIAWWlJwNf7B7gP9m4+Qvjsvfd7Is4VqJ7IvfoTj7w87ymSTaBrAdk22lvb62T
         MQ+cdoIEz4qw5Mh4+QMh9SKepIQ006uef6kWStVsSkXtR9I5tjTjvnNqGv+5vhgk6OAz
         UFuYmGyhzW84/HpfuL/ZarBVZpwaCfARFuM/p4CcSo0iaK2kffe0z06vd6i9P4TPe4b3
         AdXkHlR05jnNv3z9Lr4IriGJPWUQhacvRxL5kJtgL3+kGre8H4QtOtHUNL0APJKTs9EY
         oTDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7BKNEE72UxSnSKIw4VcoHbrzoR4aXi5X2Q2IPkzNqYw=;
        b=FVQFbm7wv6UKnafs1kfUNb1Kk6E4aZqX/j2rqAmf/Q+4q6U2lp/VJgalrZ2bGhXfD5
         j5Cp1jeYnCpALL1lrTiKeWsLlpGojmcmH+a1ibHtyjJqWMy5HJ0hzZOer4uG8f0QqCCf
         xraJsVY1tiwnh3y00PL85bTgEz8gU8CzDLvZYxSIkMMWpQ1CbYEl6V8+41uSNFTOxJDo
         r3oLBNKwbKE+0ik1f6xWI4lVlduajzH+oGzpGRA5qrDFrhFDJVV5PrzH3HAF/kf/dNDy
         WnF8cWnNFp4ZO746pJOs6P4CQFYqNHb30sQaJWERoG495byOq5/z6i7nS1S4DPqnvsDU
         87wQ==
X-Gm-Message-State: APjAAAWaxPewQw/WsNKekktaaPNrANshmaxDgDXikhgQyOqxnGsQFgm+
        UfOAPrkAvM2sMz2qH9iyYvjQ32hLrLw=
X-Google-Smtp-Source: APXvYqx+GJocQ0pLALyh6i9ljtL+bB+4xbWH811HBDFtTDdGWmWw86WIG499PQ0cGOn/IBhwMIjm+w==
X-Received: by 2002:a63:8f55:: with SMTP id r21mr9276754pgn.318.1565210434394;
        Wed, 07 Aug 2019 13:40:34 -0700 (PDT)
Received: from localhost ([192.55.54.42])
        by smtp.gmail.com with ESMTPSA id cx22sm77856pjb.25.2019.08.07.13.40.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 07 Aug 2019 13:40:34 -0700 (PDT)
Date:   Wed, 7 Aug 2019 22:40:18 +0200
From:   Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
To:     Y Song <ys114321@gmail.com>
Cc:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>, jakub.kicinski@netronome.com
Subject: Re: [v3,2/4] tools: bpftool: add net detach command to detach XDP
 on interface
Message-ID: <20190807223807.00002740@gmail.com>
In-Reply-To: <CAH3MdRX2SYj+79+L_FJtxMQZfPQDtYDFEbgH6VGAKMYnBXU4Vw@mail.gmail.com>
References: <20190807022509.4214-1-danieltimlee@gmail.com>
        <20190807022509.4214-3-danieltimlee@gmail.com>
        <CAH3MdRW4LgdLoqSpLsWUOwjnNhJA1sodHqSD2Z14JY6aHMaKxg@mail.gmail.com>
        <20190807203041.000020a8@gmail.com>
        <CAH3MdRX2SYj+79+L_FJtxMQZfPQDtYDFEbgH6VGAKMYnBXU4Vw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Aug 2019 13:12:17 -0700
Y Song <ys114321@gmail.com> wrote:

> On Wed, Aug 7, 2019 at 11:30 AM Maciej Fijalkowski
> <maciejromanfijalkowski@gmail.com> wrote:
> >
> > On Wed, 7 Aug 2019 10:02:04 -0700
> > Y Song <ys114321@gmail.com> wrote:
> >  
> > > On Tue, Aug 6, 2019 at 7:25 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:  
> > > >
> > > > By this commit, using `bpftool net detach`, the attached XDP prog can
> > > > be detached. Detaching the BPF prog will be done through libbpf
> > > > 'bpf_set_link_xdp_fd' with the progfd set to -1.
> > > >
> > > > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > > > ---
> > > >  tools/bpf/bpftool/net.c | 42 ++++++++++++++++++++++++++++++++++++++++-
> > > >  1 file changed, 41 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
> > > > index c05a3fac5cac..7be96acb08e0 100644
> > > > --- a/tools/bpf/bpftool/net.c
> > > > +++ b/tools/bpf/bpftool/net.c
> > > > @@ -343,6 +343,43 @@ static int do_attach(int argc, char **argv)
> > > >         return 0;
> > > >  }
> > > >
> > > > +static int do_detach(int argc, char **argv)
> > > > +{
> > > > +       enum net_attach_type attach_type;
> > > > +       int progfd, ifindex, err = 0;
> > > > +
> > > > +       /* parse detach args */
> > > > +       if (!REQ_ARGS(3))
> > > > +               return -EINVAL;
> > > > +
> > > > +       attach_type = parse_attach_type(*argv);
> > > > +       if (attach_type == max_net_attach_type) {
> > > > +               p_err("invalid net attach/detach type");
> > > > +               return -EINVAL;
> > > > +       }
> > > > +
> > > > +       NEXT_ARG();
> > > > +       ifindex = net_parse_dev(&argc, &argv);
> > > > +       if (ifindex < 1)
> > > > +               return -EINVAL;
> > > > +
> > > > +       /* detach xdp prog */
> > > > +       progfd = -1;
> > > > +       if (is_prefix("xdp", attach_type_strings[attach_type]))
> > > > +               err = do_attach_detach_xdp(progfd, attach_type, ifindex, NULL);  
> > >
> > > I found an issue here. This is probably related to do_attach_detach_xdp.
> > >
> > > -bash-4.4$ sudo ./bpftool net attach x pinned /sys/fs/bpf/xdp_example dev v1
> > > -bash-4.4$ sudo ./bpftool net
> > > xdp:
> > > v1(4) driver id 1172
> > >
> > > tc:
> > > eth0(2) clsact/ingress fbflow_icmp id 29 act []
> > > eth0(2) clsact/egress cls_fg_dscp_section id 27 act []
> > > eth0(2) clsact/egress fbflow_egress id 28
> > > eth0(2) clsact/egress fbflow_sslwall_egress id 35
> > >
> > > flow_dissector:
> > >
> > > -bash-4.4$ sudo ./bpftool net detach x dev v2  
> >
> > Shouldn't this be v1 as dev?  
> 
> I am testing a scenario where with wrong devname
> we did not return an error.

Ah ok. In this scenario if driver has a native xdp support we would be invoking
its ndo_bpf even if there's no prog currently attached and it wouldn't return
error value.

Looking at dev_xdp_uninstall, setting driver's prog to NULL is being done only
when prog is attached. Maybe we should consider querying the driver in
dev_change_xdp_fd regardless of passed fd value? E.g. don't query only when
prog >= 0.

I don't recall whether this was brought up previously.

CCing Jakub so we have one thread.

Maciej

> 
> Yes, if dev "v1", it works as expected.
> 
> >  
> > > -bash-4.4$ sudo ./bpftool net
> > > xdp:
> > > v1(4) driver id 1172
> > >
> > > tc:
> > > eth0(2) clsact/ingress fbflow_icmp id 29 act []
> > > eth0(2) clsact/egress cls_fg_dscp_section id 27 act []
> > > eth0(2) clsact/egress fbflow_egress id 28
> > > eth0(2) clsact/egress fbflow_sslwall_egress id 35
> > >
> > > flow_dissector:
> > >
> > > -bash-4.4$
> > >
> > > Basically detaching may fail due to wrong dev name or wrong type, etc.
> > > But the tool did not return an error. Is this expected?
> > > This may be related to this funciton "bpf_set_link_xdp_fd()".
> > > So this patch itself should be okay.
> > >  
> > > > +
> > > > +       if (err < 0) {
> > > > +               p_err("interface %s detach failed",
> > > > +                     attach_type_strings[attach_type]);
> > > > +               return err;
> > > > +       }
> > > > +
> > > > +       if (json_output)
> > > > +               jsonw_null(json_wtr);
> > > > +
> > > > +       return 0;
> > > > +}
> > > > +
> > > >  static int do_show(int argc, char **argv)
> > > >  {
> > > >         struct bpf_attach_info attach_info = {};
> > > > @@ -419,6 +456,7 @@ static int do_help(int argc, char **argv)
> > > >         fprintf(stderr,
> > > >                 "Usage: %s %s { show | list } [dev <devname>]\n"
> > > >                 "       %s %s attach ATTACH_TYPE PROG dev <devname> [ overwrite ]\n"
> > > > +               "       %s %s detach ATTACH_TYPE dev <devname>\n"
> > > >                 "       %s %s help\n"
> > > >                 "\n"
> > > >                 "       " HELP_SPEC_PROGRAM "\n"
> > > > @@ -429,7 +467,8 @@ static int do_help(int argc, char **argv)
> > > >                 "      to dump program attachments. For program types\n"
> > > >                 "      sk_{filter,skb,msg,reuseport} and lwt/seg6, please\n"
> > > >                 "      consult iproute2.\n",
> > > > -               bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2]);
> > > > +               bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
> > > > +               bin_name, argv[-2]);
> > > >
> > > >         return 0;
> > > >  }
> > > > @@ -438,6 +477,7 @@ static const struct cmd cmds[] = {
> > > >         { "show",       do_show },
> > > >         { "list",       do_show },
> > > >         { "attach",     do_attach },
> > > > +       { "detach",     do_detach },
> > > >         { "help",       do_help },
> > > >         { 0 }
> > > >  };
> > > > --
> > > > 2.20.1
> > > >  
> >  

