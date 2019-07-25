Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F21A97450B
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 07:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403930AbfGYFgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 01:36:36 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41575 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390589AbfGYFgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 01:36:35 -0400
Received: by mail-qt1-f193.google.com with SMTP id d17so47838435qtj.8;
        Wed, 24 Jul 2019 22:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cit/uEEj5zGRVU08n3pEs9ORmGfaUtgK6Q2DtGqIsC0=;
        b=o8f5v4EJIvCqOz8lPbvo6c6wgGt2p9wwkhplvGtC/hii6Ts78bDRKmMIHiL670/UH6
         uRC/EU02He971Y/jx/PN4v02DFEgwZryIyE2rWhyXzn6a/ZMalXNHUqVEk43WUpQNy70
         HLU0b9TFRaDzEwhAklPaGpYGxWxaX5djfC7qkqY0PI6jGfAoTYMCuvRI/VQpFzg0+whd
         1RWK0IV25Ej7tRRmavK7dDOgYqIzwoEi6GdozCiIF8C4IWd9TXEYu13EKrAPViGfkwQ2
         5eIhaO6513g7v9kNf9tM+rtYsnLefV3zYRYr+gbiHtQiRLIxpjcve/KYP4oPdh5+K2N6
         52Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cit/uEEj5zGRVU08n3pEs9ORmGfaUtgK6Q2DtGqIsC0=;
        b=Ueis6ikWruoB7gv/mDsdBfuYnjRv1zK68QUt0XVVOgllTQnk60I1qDoG2Ev6geNTk6
         omvyCAS3ZZVlGNFsKsDdCjEva9HW+DdXj+eCkFQnIpiNwVPB/JTwMVEqiAGbh7iXMFaE
         Wa+W4oLdR3pTBj0MbiKmdv0myYR+SR8agBKd05gk5DD89aP4u/b88yDYl9Xs5WLMLGU9
         fWnHNq4x0Xy2xfsHXbV8314lfKDI5JxaqMIr81J+GU71fDSEE0GtnqsWrzRYHXYbehJz
         7npf95CoGyvj4Yh+q22EQhOLW0UmEOdPD2E0Tlv/0vScNGBOqNn3wk84oJgTnWmjYJns
         8DFw==
X-Gm-Message-State: APjAAAUSuxQR7ayXQhgRkC7B2Tk24LH63/XsU9lGZZXbJZ+4HJG38Oys
        X/VXHa1jWU/gHLpIAV1YZsG8V1srL0uP/6yDezo=
X-Google-Smtp-Source: APXvYqyUzBKkJrng1tUlk3fsq66kk4GEK+lk1TQzlOtY8gMm3IxY+8S6DWOcnPbRgFhH/NYHHVISheno726TI4tjAUk=
X-Received: by 2002:ac8:6a17:: with SMTP id t23mr58843171qtr.183.1564032994412;
 Wed, 24 Jul 2019 22:36:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190724170018.96659-1-sdf@google.com> <20190724170018.96659-6-sdf@google.com>
 <CAPhsuW6Z2Bx66ZDOV-9jW+hsxKbZJxY-YFgP0rL_4QipAuptQA@mail.gmail.com> <20190724235254.GB3500@mini-arch>
In-Reply-To: <20190724235254.GB3500@mini-arch>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Wed, 24 Jul 2019 22:36:23 -0700
Message-ID: <CAPhsuW6cNxQb_manSbaOqUfW_xCoPpCsdBwCDwweyjO=CGsi=w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/7] sefltests/bpf: support FLOW_DISSECTOR_F_PARSE_1ST_FRAG
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 4:52 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 07/24, Song Liu wrote:
> > On Wed, Jul 24, 2019 at 10:11 AM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > bpf_flow.c: exit early unless FLOW_DISSECTOR_F_PARSE_1ST_FRAG is passed
> > > in flags. Also, set ip_proto earlier, this makes sure we have correct
> > > value with fragmented packets.
> > >
> > > Add selftest cases to test ipv4/ipv6 fragments and skip eth_get_headlen
> > > tests that don't have FLOW_DISSECTOR_F_PARSE_1ST_FRAG flag.
> > >
> > > eth_get_headlen calls flow dissector with
> > > FLOW_DISSECTOR_F_PARSE_1ST_FRAG flag so we can't run tests that
> > > have different set of input flags against it.
> > >
> > > Cc: Willem de Bruijn <willemb@google.com>
> > > Cc: Petar Penkov <ppenkov@google.com>
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  .../selftests/bpf/prog_tests/flow_dissector.c | 129 ++++++++++++++++++
> > >  tools/testing/selftests/bpf/progs/bpf_flow.c  |  28 +++-
> > >  2 files changed, 151 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
> > > index c938283ac232..966cb3b06870 100644
> > > --- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
> > > +++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
> > > @@ -5,6 +5,10 @@
> > >  #include <linux/if_tun.h>
> > >  #include <sys/uio.h>
> > >
> > > +#ifndef IP_MF
> > > +#define IP_MF 0x2000
> > > +#endif
> > > +
> > >  #define CHECK_FLOW_KEYS(desc, got, expected)                           \
> > >         CHECK_ATTR(memcmp(&got, &expected, sizeof(got)) != 0,           \
> > >               desc,                                                     \
> > > @@ -49,6 +53,18 @@ struct ipv6_pkt {
> > >         struct tcphdr tcp;
> > >  } __packed;
> > >
> > > +struct ipv6_frag_pkt {
> > > +       struct ethhdr eth;
> > > +       struct ipv6hdr iph;
> > > +       struct frag_hdr {
> > > +               __u8 nexthdr;
> > > +               __u8 reserved;
> > > +               __be16 frag_off;
> > > +               __be32 identification;
> > > +       } ipf;
> > > +       struct tcphdr tcp;
> > > +} __packed;
> > > +
> > >  struct dvlan_ipv6_pkt {
> > >         struct ethhdr eth;
> > >         __u16 vlan_tci;
> > > @@ -65,9 +81,11 @@ struct test {
> > >                 struct ipv4_pkt ipv4;
> > >                 struct svlan_ipv4_pkt svlan_ipv4;
> > >                 struct ipv6_pkt ipv6;
> > > +               struct ipv6_frag_pkt ipv6_frag;
> > >                 struct dvlan_ipv6_pkt dvlan_ipv6;
> > >         } pkt;
> > >         struct bpf_flow_keys keys;
> > > +       __u32 flags;
> > >  };
> > >
> > >  #define VLAN_HLEN      4
> > > @@ -143,6 +161,102 @@ struct test tests[] = {
> > >                         .n_proto = __bpf_constant_htons(ETH_P_IPV6),
> > >                 },
> > >         },
> > > +       {
> > > +               .name = "ipv4-frag",
> > > +               .pkt.ipv4 = {
> > > +                       .eth.h_proto = __bpf_constant_htons(ETH_P_IP),
> > > +                       .iph.ihl = 5,
> > > +                       .iph.protocol = IPPROTO_TCP,
> > > +                       .iph.tot_len = __bpf_constant_htons(MAGIC_BYTES),
> > > +                       .iph.frag_off = __bpf_constant_htons(IP_MF),
> > > +                       .tcp.doff = 5,
> > > +                       .tcp.source = 80,
> > > +                       .tcp.dest = 8080,
> > > +               },
> > > +               .keys = {
> > > +                       .flags = FLOW_DISSECTOR_F_PARSE_1ST_FRAG,
> > > +                       .nhoff = ETH_HLEN,
> > > +                       .thoff = ETH_HLEN + sizeof(struct iphdr),
> > > +                       .addr_proto = ETH_P_IP,
> > > +                       .ip_proto = IPPROTO_TCP,
> > > +                       .n_proto = __bpf_constant_htons(ETH_P_IP),
> > > +                       .is_frag = true,
> > > +                       .is_first_frag = true,
> > > +                       .sport = 80,
> > > +                       .dport = 8080,
> > > +               },
> > > +               .flags = FLOW_DISSECTOR_F_PARSE_1ST_FRAG,
> > > +       },
> > > +       {
> > > +               .name = "ipv4-no-frag",
> > > +               .pkt.ipv4 = {
> > > +                       .eth.h_proto = __bpf_constant_htons(ETH_P_IP),
> > > +                       .iph.ihl = 5,
> > > +                       .iph.protocol = IPPROTO_TCP,
> > > +                       .iph.tot_len = __bpf_constant_htons(MAGIC_BYTES),
> > > +                       .iph.frag_off = __bpf_constant_htons(IP_MF),
> > > +                       .tcp.doff = 5,
> > > +                       .tcp.source = 80,
> > > +                       .tcp.dest = 8080,
> > > +               },
> > > +               .keys = {
> > > +                       .nhoff = ETH_HLEN,
> > > +                       .thoff = ETH_HLEN + sizeof(struct iphdr),
> > > +                       .addr_proto = ETH_P_IP,
> > > +                       .ip_proto = IPPROTO_TCP,
> > > +                       .n_proto = __bpf_constant_htons(ETH_P_IP),
> > > +                       .is_frag = true,
> > > +                       .is_first_frag = true,
> > > +               },
> > > +       },
> > > +       {
> > > +               .name = "ipv6-frag",
> > > +               .pkt.ipv6_frag = {
> > > +                       .eth.h_proto = __bpf_constant_htons(ETH_P_IPV6),
> > > +                       .iph.nexthdr = IPPROTO_FRAGMENT,
> > > +                       .iph.payload_len = __bpf_constant_htons(MAGIC_BYTES),
> > > +                       .ipf.nexthdr = IPPROTO_TCP,
> > > +                       .tcp.doff = 5,
> > > +                       .tcp.source = 80,
> > > +                       .tcp.dest = 8080,
> > > +               },
> > > +               .keys = {
> > > +                       .flags = FLOW_DISSECTOR_F_PARSE_1ST_FRAG,
> > > +                       .nhoff = ETH_HLEN,
> > > +                       .thoff = ETH_HLEN + sizeof(struct ipv6hdr) +
> > > +                               sizeof(struct frag_hdr),
> > > +                       .addr_proto = ETH_P_IPV6,
> > > +                       .ip_proto = IPPROTO_TCP,
> > > +                       .n_proto = __bpf_constant_htons(ETH_P_IPV6),
> > > +                       .is_frag = true,
> > > +                       .is_first_frag = true,
> > > +                       .sport = 80,
> > > +                       .dport = 8080,
> > > +               },
> > > +               .flags = FLOW_DISSECTOR_F_PARSE_1ST_FRAG,
> > > +       },
> > > +       {
> > > +               .name = "ipv6-no-frag",
> > > +               .pkt.ipv6_frag = {
> > > +                       .eth.h_proto = __bpf_constant_htons(ETH_P_IPV6),
> > > +                       .iph.nexthdr = IPPROTO_FRAGMENT,
> > > +                       .iph.payload_len = __bpf_constant_htons(MAGIC_BYTES),
> > > +                       .ipf.nexthdr = IPPROTO_TCP,
> > > +                       .tcp.doff = 5,
> > > +                       .tcp.source = 80,
> > > +                       .tcp.dest = 8080,
> > > +               },
> > > +               .keys = {
> > > +                       .nhoff = ETH_HLEN,
> > > +                       .thoff = ETH_HLEN + sizeof(struct ipv6hdr) +
> > > +                               sizeof(struct frag_hdr),
> > > +                       .addr_proto = ETH_P_IPV6,
> > > +                       .ip_proto = IPPROTO_TCP,
> > > +                       .n_proto = __bpf_constant_htons(ETH_P_IPV6),
> > > +                       .is_frag = true,
> > > +                       .is_first_frag = true,
> > > +               },
> > > +       },
> > >  };
> > >
> > >  static int create_tap(const char *ifname)
> > > @@ -225,6 +339,13 @@ void test_flow_dissector(void)
> > >                         .data_size_in = sizeof(tests[i].pkt),
> > >                         .data_out = &flow_keys,
> > >                 };
> > > +               static struct bpf_flow_keys ctx = {};
> > > +
> > > +               if (tests[i].flags) {
> > > +                       tattr.ctx_in = &ctx;
> > > +                       tattr.ctx_size_in = sizeof(ctx);
> > > +                       ctx.flags = tests[i].flags;
> > > +               }
> > >
> > >                 err = bpf_prog_test_run_xattr(&tattr);
> > >                 CHECK_ATTR(tattr.data_size_out != sizeof(flow_keys) ||
> > > @@ -255,6 +376,14 @@ void test_flow_dissector(void)
> > >                 struct bpf_prog_test_run_attr tattr = {};
> > >                 __u32 key = 0;
> > >
> > > +               /* Don't run tests that are not marked as
> > > +                * FLOW_DISSECTOR_F_PARSE_1ST_FRAG; eth_get_headlen
> > > +                * sets this flag.
> > > +                */
> > > +
> > > +               if (tests[i].flags != FLOW_DISSECTOR_F_PARSE_1ST_FRAG)
> > > +                       continue;
> >
> > Maybe test flags & FLOW_DISSECTOR_F_PARSE_1ST_FRAG == 0 instead?
> > It is not necessary now, but might be useful in the future.
> I'm not sure about this one. We want flags here to match flags
> from eth_get_headlen:
>
>         const unsigned int flags = FLOW_DISSECTOR_F_PARSE_1ST_FRAG;
>         ...
>         if (!skb_flow_dissect_flow_keys_basic(..., flags))
>
> Otherwise the test might break unexpectedly. So I'd rather manually
> adjust a test here if eth_get_headlen flags change.

Could we have

  flags ==  FLOW_DISSECTOR_F_PARSE_1ST_FRAG | some_other_flag

in the future? This flag is not equal to FLOW_DISSECTOR_F_PARSE_1ST_FRAG.

>
> Maybe I should clarify the comment to signify that dependency? Because
> currently it might be read as if we only care about
> FLOW_DISSECTOR_F_PARSE_1ST_FRAG, but we really care about all flags
> in eth_get_headlen; it just happens that it only has one right now.

Some clarification will be great.

Thanks,
Song
