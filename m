Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD8F8F98F6
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 19:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbfKLSkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 13:40:37 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:37170 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbfKLSkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 13:40:37 -0500
Received: by mail-oi1-f193.google.com with SMTP id y194so15779870oie.4
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 10:40:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rWtumuXhocaaxI92FG03XX6OsSNe4/p0v1JeGeTEFdU=;
        b=QKCYR8IQIK6/1R9zXbI5lO7+4efuJvvWVjNTUTWT7Eq1PJjGg4alVD7+vVwIaHt57j
         QVpPyxwDiLL+ISh6g0KX6vmEX7hhiE6QNRXLACV5wtSAcPtlsxnsJ9Q7aQ1rTwdtqRNx
         5v/gvowgnT7lt0BjKA5WZLMXN4vVPwyWCxQNMiQ+5Q6LatCblAd6GDqmDDgTljJ3PSWx
         C5IPV7EBwrz1p7DwqD1KS+wIOdVsdVgl/mCS1giGMBw84ZM/KYpkJDH+7SPTlXWcXvIb
         EE5MSmWVZWUjinVGJGVbUqPYk1vf+4cn6px17QRwrrPqge0hZFmKPJI4WGNAu0uAhjb4
         K7hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rWtumuXhocaaxI92FG03XX6OsSNe4/p0v1JeGeTEFdU=;
        b=LFwD0mBVbu+Z75zwV/JTIpsy+cockSwBJiOeY91DcI9lFt95yDAESX59FYD9qX5LlL
         zjjNiBZ5viIWp0ihcKBOlFFFHaNCI01xsLOPG0oNXW2G9pLRe46ay8uWIw4fYtnQh4h8
         mjNaenjL+o5Q1l/MkCqXnT+j871IsrJZcj+ZLXt1Z6s7xkGGcfFCqGXhsTr7GzzUnYqC
         W7sRd7ZUGqzwNDCBil9xEo77w+u57W43bp7/aPuYCrlFQ1JIYwDYvrhj9wj9WoHukk8y
         nuTMzPiQjXP5WiUzgJmOnsTIy4SLeQWQtoXHMiXjfq8wNYv2EdmHT8NEqEbdcJiXnqtO
         +eNQ==
X-Gm-Message-State: APjAAAXs4owsgOYc9jPkQoCuXKLMWe5h1ri+e9lndwczitYDb3oBMYjW
        swP6clzWBXoouJcqodRqInAtu3YrcBqGo6IAeIl765AfhHE=
X-Google-Smtp-Source: APXvYqxqjF5onBMtA28R69K0BJGCYv0IJZXcGKvdGE/0THu8N46nJ1nryFG/9JfvokS0ipa4nsN4HvKOGg+IqPOzpGA=
X-Received: by 2002:aca:4742:: with SMTP id u63mr306926oia.177.1573584035634;
 Tue, 12 Nov 2019 10:40:35 -0800 (PST)
MIME-Version: 1.0
References: <1573571327-6906-1-git-send-email-xiangxia.m.yue@gmail.com> <2490a542-f0fc-f0db-3494-9fdf3b8aa30b@gmail.com>
In-Reply-To: <2490a542-f0fc-f0db-3494-9fdf3b8aa30b@gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Wed, 13 Nov 2019 02:39:59 +0800
Message-ID: <CAMDZJNWE9bRKuXUmp7GuuR0Oq3o+EaDSUtj6Fcam79mvNbzXAQ@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH net-next v3] net: openvswitch: add hash info to upcall
To:     Gregory Rose <gvrose8192@gmail.com>
Cc:     Pravin Shelar <pshelar@ovn.org>, Ben Pfaff <blp@ovn.org>,
        ovs dev <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ychen <ychen103103@163.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 13, 2019 at 2:06 AM Gregory Rose <gvrose8192@gmail.com> wrote:
>
>
> On 11/12/2019 7:08 AM, xiangxia.m.yue@gmail.com wrote:
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > When using the kernel datapath, the upcall don't
> > include skb hash info relatived. That will introduce
> > some problem, because the hash of skb is important
> > in kernel stack. For example, VXLAN module uses
> > it to select UDP src port. The tx queue selection
> > may also use the hash in stack.
> >
> > Hash is computed in different ways. Hash is random
> > for a TCP socket, and hash may be computed in hardware,
> > or software stack. Recalculation hash is not easy.
> >
> > Hash of TCP socket is computed:
> >    tcp_v4_connect
> >      -> sk_set_txhash (is random)
> >
> >    __tcp_transmit_skb
> >      -> skb_set_hash_from_sk
> >
> > There will be one upcall, without information of skb
> > hash, to ovs-vswitchd, for the first packet of a TCP
> > session. The rest packets will be processed in Open vSwitch
> > modules, hash kept. If this tcp session is forward to
> > VXLAN module, then the UDP src port of first tcp packet
> > is different from rest packets.
> >
> > TCP packets may come from the host or dockers, to Open vSwitch.
> > To fix it, we store the hash info to upcall, and restore hash
> > when packets sent back.
> >
> > +---------------+          +-------------------------+
> > |   Docker/VMs  |          |     ovs-vswitchd        |
> > +----+----------+          +-+--------------------+--+
> >       |                       ^                    |
> >       |                       |                    |
> >       |                       |  upcall            v restore packet hash (not recalculate)
> >       |                     +-+--------------------+--+
> >       |  tap netdev         |                         |   vxlan module
> >       +--------------->     +-->  Open vSwitch ko     +-->
> >         or internal type    |                         |
> >                             +-------------------------+
> >
> > Reported-at: https://mail.openvswitch.org/pipermail/ovs-dev/2019-October/364062.html
> > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > ---
> > v3:
> > * add enum ovs_pkt_hash_types
> > * avoid duplicate call the skb_get_hash_raw.
> > * explain why we should fix this problem.
> > ---
> >   include/uapi/linux/openvswitch.h |  2 ++
> >   net/openvswitch/datapath.c       | 30 +++++++++++++++++++++++++++++-
> >   net/openvswitch/datapath.h       | 12 ++++++++++++
> >   3 files changed, 43 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> > index 1887a451c388..e65407c1f366 100644
> > --- a/include/uapi/linux/openvswitch.h
> > +++ b/include/uapi/linux/openvswitch.h
> > @@ -170,6 +170,7 @@ enum ovs_packet_cmd {
> >    * output port is actually a tunnel port. Contains the output tunnel key
> >    * extracted from the packet as nested %OVS_TUNNEL_KEY_ATTR_* attributes.
> >    * @OVS_PACKET_ATTR_MRU: Present for an %OVS_PACKET_CMD_ACTION and
> > + * @OVS_PACKET_ATTR_HASH: Packet hash info (e.g. hash, sw_hash and l4_hash in skb).
> >    * @OVS_PACKET_ATTR_LEN: Packet size before truncation.
> >    * %OVS_PACKET_ATTR_USERSPACE action specify the Maximum received fragment
> >    * size.
> > @@ -190,6 +191,7 @@ enum ovs_packet_attr {
> >       OVS_PACKET_ATTR_PROBE,      /* Packet operation is a feature probe,
> >                                      error logging should be suppressed. */
> >       OVS_PACKET_ATTR_MRU,        /* Maximum received IP fragment size. */
> > +     OVS_PACKET_ATTR_HASH,       /* Packet hash. */
> >       OVS_PACKET_ATTR_LEN,            /* Packet size before truncation. */
> >       __OVS_PACKET_ATTR_MAX
> >   };
>
> Why do you add the new enum before the last entry OVS_PACKET_ATTR_LEN
> instead of
> just adding it to the end of the list?
Should be at end of the list, but I run the "make check" without patch
for ovs-vswitchd,
There is not error. There is not a OVS_PACKET_ATTR_LEN test case ?
I will change the order of enum in next version, thanks.
> Just curious.
>
> - Greg
>
> > diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> > index 2088619c03f0..b556cf62b77c 100644
> > --- a/net/openvswitch/datapath.c
> > +++ b/net/openvswitch/datapath.c
> > @@ -350,7 +350,8 @@ static size_t upcall_msg_size(const struct dp_upcall_info *upcall_info,
> >       size_t size = NLMSG_ALIGN(sizeof(struct ovs_header))
> >               + nla_total_size(hdrlen) /* OVS_PACKET_ATTR_PACKET */
> >               + nla_total_size(ovs_key_attr_size()) /* OVS_PACKET_ATTR_KEY */
> > -             + nla_total_size(sizeof(unsigned int)); /* OVS_PACKET_ATTR_LEN */
> > +             + nla_total_size(sizeof(unsigned int)) /* OVS_PACKET_ATTR_LEN */
> > +             + nla_total_size(sizeof(u64)); /* OVS_PACKET_ATTR_HASH */
> >
> >       /* OVS_PACKET_ATTR_USERDATA */
> >       if (upcall_info->userdata)
> > @@ -393,6 +394,7 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
> >       size_t len;
> >       unsigned int hlen;
> >       int err, dp_ifindex;
> > +     u64 hash;
> >
> >       dp_ifindex = get_dpifindex(dp);
> >       if (!dp_ifindex)
> > @@ -504,6 +506,23 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
> >               pad_packet(dp, user_skb);
> >       }
> >
> > +     hash = skb_get_hash_raw(skb);
> > +     if (hash) {
> > +             if (skb->sw_hash)
> > +                     hash |= OVS_PACKET_HASH_SW_BIT;
> > +
> > +             if (skb->l4_hash)
> > +                     hash |= OVS_PACKET_HASH_L4_BIT;
> > +
> > +             if (nla_put(user_skb, OVS_PACKET_ATTR_HASH,
> > +                         sizeof (u64), &hash)) {
> > +                     err = -ENOBUFS;
> > +                     goto out;
> > +             }
> > +
> > +             pad_packet(dp, user_skb);
> > +     }
> > +
> >       /* Only reserve room for attribute header, packet data is added
> >        * in skb_zerocopy() */
> >       if (!(nla = nla_reserve(user_skb, OVS_PACKET_ATTR_PACKET, 0))) {
> > @@ -543,6 +562,7 @@ static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
> >       struct datapath *dp;
> >       struct vport *input_vport;
> >       u16 mru = 0;
> > +     u64 hash;
> >       int len;
> >       int err;
> >       bool log = !a[OVS_PACKET_ATTR_PROBE];
> > @@ -568,6 +588,14 @@ static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
> >       }
> >       OVS_CB(packet)->mru = mru;
> >
> > +     if (a[OVS_PACKET_ATTR_HASH]) {
> > +             hash = nla_get_u64(a[OVS_PACKET_ATTR_HASH]);
> > +
> > +             __skb_set_hash(packet, hash & 0xFFFFFFFFULL,
> > +                            !!(hash & OVS_PACKET_HASH_SW_BIT),
> > +                            !!(hash & OVS_PACKET_HASH_L4_BIT));
> > +     }
> > +
> >       /* Build an sw_flow for sending this packet. */
> >       flow = ovs_flow_alloc();
> >       err = PTR_ERR(flow);
> > diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
> > index 81e85dde8217..e239a46c2f94 100644
> > --- a/net/openvswitch/datapath.h
> > +++ b/net/openvswitch/datapath.h
> > @@ -139,6 +139,18 @@ struct ovs_net {
> >       bool xt_label;
> >   };
> >
> > +/**
> > + * enum ovs_pkt_hash_types - hash info to include with a packet
> > + * to send to userspace.
> > + * @OVS_PACKET_HASH_SW_BIT: indicates hash was computed in software stack.
> > + * @OVS_PACKET_HASH_L4_BIT: indicates hash is a canonical 4-tuple hash
> > + * over transport ports.
> > + */
> > +enum ovs_pkt_hash_types {
> > +     OVS_PACKET_HASH_SW_BIT = (1ULL << 32),
> > +     OVS_PACKET_HASH_L4_BIT = (1ULL << 33),
> > +};
> > +
> >   extern unsigned int ovs_net_id;
> >   void ovs_lock(void);
> >   void ovs_unlock(void);
>
