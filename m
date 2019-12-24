Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA59129F43
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 09:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbfLXImE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 03:42:04 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:43483 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbfLXImE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 03:42:04 -0500
Received: by mail-lf1-f65.google.com with SMTP id 9so14581826lfq.10;
        Tue, 24 Dec 2019 00:42:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BUrzHnGWsCvRbYqfGz7mzn9PEmCOLtCvRNjYsu70LCU=;
        b=TjcNAuSz8FRQTvnBNT4Mi9cXoiQFY24AK+G4GnqivWsBRc+hcAcjF0A3IfXuDEqY35
         NtSqIgKijH1yptSgKocyiQCokDpDd5N/TYH/Gtvf+Aw5L+2O2oN5CZo49aWTilo5Oz2Q
         Pvmwue3yAnnujo0yC0u15A/1edzSiKDILNElGoHUG3niV0glvN7vlz/oxpLQ2iHP8lma
         gOmohbFb4z/e6AAmLqNt6umtLb1RbfWoshLT7EOK6T68f9XlEx2c4X01/dYCx8kmp/x6
         fMaWPVQLQob5SYiXl+xSdF6ZNnAatcs2y00iJEuHOXLNwHX3KdZksHi5x3Yyl+NdiwvY
         emyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BUrzHnGWsCvRbYqfGz7mzn9PEmCOLtCvRNjYsu70LCU=;
        b=th5H6H4orsxMLMyPrV5NXFm19rC+i4COiKvg0nUODEkSovWb34cm76VANJecnefGnK
         Vv/vua41aLyt2OHTAWSNXJdYJE+jEDTjEkpKKH64/Dqbsz9RbPBN49PiSX5ltb6LdQlF
         VSTmoUXCe6ERC71jh0aHVGA8lVlmqjCF0yV8X2S7qiKIwiS0A2g6xgGr0ufOiOXajfPH
         rTJCjtPDHDxSClIjG5zoW+/ifBYN2uwsFhCpUKBfUO9ASC158jR7o+wiu5PqgFqYDkOh
         BGBvSC7HFgQYzN+JZYjLVX/8MzFL/uMkSavwFxkA0dXieUG2nRcPROlhkPLOI8OaxhZl
         boog==
X-Gm-Message-State: APjAAAWbU8beCDTVJV9Vx/rx5kemolExt1hTGZJD7i6zXx5daFZISePH
        bi20S7L1S54TFMvWwEs3EYrxXhUmxerAKWC25qw=
X-Google-Smtp-Source: APXvYqwoEbinn89EIGoO3O5nrw330HICfs0OCkkHCQfpLzwsU20wYK120bA2s6sO6pnLIsha9ci8sXVRs9LNfi8JS7E=
X-Received: by 2002:ac2:47e6:: with SMTP id b6mr18967553lfp.96.1577176921418;
 Tue, 24 Dec 2019 00:42:01 -0800 (PST)
MIME-Version: 1.0
References: <20191217155102.46039-1-mcroce@redhat.com> <cf5b01f8-b4e4-90da-0ee7-b1d81ee6d342@cumulusnetworks.com>
 <CAGnkfhxaT9_WL4UR8qurjBTkkdkuZFbfTQucLjoKOP-1eDEoTw@mail.gmail.com>
In-Reply-To: <CAGnkfhxaT9_WL4UR8qurjBTkkdkuZFbfTQucLjoKOP-1eDEoTw@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 24 Dec 2019 16:41:25 +0800
Message-ID: <CAMDZJNUQHR2zJwzbqKJWqMEYSKpz3-VHu4LTUzWKX94rQgMzxw@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH net-next v2] openvswitch: add TTL decrement action
To:     Matteo Croce <mcroce@redhat.com>
Cc:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        ovs dev <dev@openvswitch.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bindiya Kurle <bindiyakurle@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Matteo,
Did you have plan to implement the TTL decrement action in userspace
datapath(with dpdk),
I am doing some research offloading about TTL decrement action, and
may sent patch TTL decrement offload action,
using dpdk rte_flow.

On Fri, Dec 20, 2019 at 8:37 PM Matteo Croce <mcroce@redhat.com> wrote:
>
> On Tue, Dec 17, 2019 at 5:30 PM Nikolay Aleksandrov
> <nikolay@cumulusnetworks.com> wrote:
> >
> > On 17/12/2019 17:51, Matteo Croce wrote:
> > > New action to decrement TTL instead of setting it to a fixed value.
> > > This action will decrement the TTL and, in case of expired TTL, drop it
> > > or execute an action passed via a nested attribute.
> > > The default TTL expired action is to drop the packet.
> > >
> > > Supports both IPv4 and IPv6 via the ttl and hop_limit fields, respectively.
> > >
> > > Tested with a corresponding change in the userspace:
> > >
> > >     # ovs-dpctl dump-flows
> > >     in_port(2),eth(),eth_type(0x0800), packets:0, bytes:0, used:never, actions:dec_ttl{ttl<=1 action:(drop)},1,1
> > >     in_port(1),eth(),eth_type(0x0800), packets:0, bytes:0, used:never, actions:dec_ttl{ttl<=1 action:(drop)},1,2
> > >     in_port(1),eth(),eth_type(0x0806), packets:0, bytes:0, used:never, actions:2
> > >     in_port(2),eth(),eth_type(0x0806), packets:0, bytes:0, used:never, actions:1
> > >
> > >     # ping -c1 192.168.0.2 -t 42
> > >     IP (tos 0x0, ttl 41, id 61647, offset 0, flags [DF], proto ICMP (1), length 84)
> > >         192.168.0.1 > 192.168.0.2: ICMP echo request, id 386, seq 1, length 64
> > >     # ping -c1 192.168.0.2 -t 120
> > >     IP (tos 0x0, ttl 119, id 62070, offset 0, flags [DF], proto ICMP (1), length 84)
> > >         192.168.0.1 > 192.168.0.2: ICMP echo request, id 388, seq 1, length 64
> > >     # ping -c1 192.168.0.2 -t 1
> > >     #
> > >
> > > Co-authored-by: Bindiya Kurle <bindiyakurle@gmail.com>
> > > Signed-off-by: Bindiya Kurle <bindiyakurle@gmail.com>
> > > Signed-off-by: Matteo Croce <mcroce@redhat.com>
> > > ---
> > >  include/uapi/linux/openvswitch.h |  22 +++++++
> > >  net/openvswitch/actions.c        |  71 +++++++++++++++++++++
> > >  net/openvswitch/flow_netlink.c   | 105 +++++++++++++++++++++++++++++++
> > >  3 files changed, 198 insertions(+)
> > >
> >
> > Hi Matteo,
> >
> > [snip]
> > > +}
> > > +
> > >  /* When 'last' is true, sample() should always consume the 'skb'.
> > >   * Otherwise, sample() should keep 'skb' intact regardless what
> > >   * actions are executed within sample().
> > > @@ -1176,6 +1201,44 @@ static int execute_check_pkt_len(struct datapath *dp, struct sk_buff *skb,
> > >                            nla_len(actions), last, clone_flow_key);
> > >  }
> > >
> > > +static int execute_dec_ttl(struct sk_buff *skb, struct sw_flow_key *key)
> > > +{
> > > +     int err;
> > > +
> > > +     if (skb->protocol == htons(ETH_P_IPV6)) {
> > > +             struct ipv6hdr *nh = ipv6_hdr(skb);
> > > +
> > > +             err = skb_ensure_writable(skb, skb_network_offset(skb) +
> > > +                                       sizeof(*nh));
> >
> > skb_ensure_writable() calls pskb_may_pull() which may reallocate so nh might become invalid.
> > It seems the IPv4 version below is ok as the ptr is reloaded.
> >
>
> Right
>
> > One q as I don't know ovs that much - can this action be called only with
> > skb->protocol ==  ETH_P_IP/IPV6 ? I.e. Are we sure that if it's not v6, then it must be v4 ?
> >
>
> I'm adding a check in validate_and_copy_dec_ttl() so only ipv4/ipv6
> packet will pass.
>
> Thanks,
>
> --
> Matteo Croce
> per aspera ad upstream
>
> _______________________________________________
> dev mailing list
> dev@openvswitch.org
> https://mail.openvswitch.org/mailman/listinfo/ovs-dev
