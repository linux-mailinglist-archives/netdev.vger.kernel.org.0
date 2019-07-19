Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6866D898
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 03:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbfGSBuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 21:50:06 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37967 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbfGSBuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 21:50:06 -0400
Received: by mail-wm1-f66.google.com with SMTP id s15so6056444wmj.3;
        Thu, 18 Jul 2019 18:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WDwkNs81FUZFHWGd/sO39vfFP66wdXfNWwzEjhrHbj0=;
        b=MCiBd15jvjEJxA6x34rhULLLwlTLLYgBXB+F4E6kdkulT7exik970qGy3KFN+BrIxG
         tZbn6fTjLGy8kP5z+5gGu87VsdN3pCJAeFV5kl4DAjMFIL07g+jtKuY1wJaJCxZC+UvI
         KpBqmMEkmulOtVwCTW1Pa5fd/yTOoud7D1aEk1p/dPU/wRQsaNs/IBEpalc/mtmbPBmD
         TH17O/iFCqh6MJxn4s2MvD4Ob72eD3rtN5xa4RxjpMYmyEADilsnpFWUObTViF3vHl5U
         dHzUjMboThyY73PJtRcjpCIUMGTR1oCSpbx2cwxnL9ItBBcHPznMwS5SEm8e55lcLFCc
         Wg+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WDwkNs81FUZFHWGd/sO39vfFP66wdXfNWwzEjhrHbj0=;
        b=N7dqCHgoD+YsNRqtj5SbbnZZySSwTYWSut0KWzz3QRxZTr52ZFsZhVP+hGSkZ7zEe+
         zpeBdxLeo68PaobzKyoDkrpetbYRW3aybg2Q9MvGp9laSXzc9RN2FnhgYKS1DEbwt1YV
         pP2ML9/4KHNdQ1uWUuwsOQ4/3795vbpu0U13y3hJfP96REbKtmiAlZwrqP4ULxmbeJHM
         GSP5i6G4Cdf1WGqZIssupKUqrP2i/ZAQ8asQg05Caa4ymqLRkJshRaEdi8tCe6/OwBWt
         F7jCZQ6vroT2udxRwLGJHkcEeIiDaUNq0tlV2Tdv9wKwl8CIoG/H8RCVMWzouOO1yGu6
         EEPg==
X-Gm-Message-State: APjAAAVAnUETxp6Rz7D+OqIpdoTaZVNVvCzPagEbSSIhg6y02pXm4z2u
        D5cWBylGk0fWXFwJUUXlx/p6b5WSjziF5vzpCQc=
X-Google-Smtp-Source: APXvYqwFpSPd5I8fcpSYcyID6XJJzY27kjDCAIabLWTM7Nm4GYBgCiQMRA74Jj/XtFnJSc2+Z5ynxPfRIk4fui/EmSw=
X-Received: by 2002:a1c:1b97:: with SMTP id b145mr42414616wmb.158.1563501002993;
 Thu, 18 Jul 2019 18:50:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190715082747.fdlpvekbqyhwx724@salvia> <20190716021301.27753-1-xingwu.yang@gmail.com>
 <20190718182608.apjgz5xbpsyvxfp6@salvia>
In-Reply-To: <20190718182608.apjgz5xbpsyvxfp6@salvia>
From:   yangxingwu <xingwu.yang@gmail.com>
Date:   Fri, 19 Jul 2019 09:49:51 +0800
Message-ID: <CA+7U5Jvb-ZRV3yveyDh-=-uD_aYCHBDTvdbxZ6Mrxj8Mf0oXuw@mail.gmail.com>
Subject: Re: [PATCH v2] net/netfilter: remove unnecessary spaces
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     wensong@linux-vs.org, Simon Horman <horms@verge.net.au>, ja@ssi.bg,
        kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thansk Pablo

Pablo Neira Ayuso <pablo@netfilter.org> =E4=BA=8E2019=E5=B9=B47=E6=9C=8819=
=E6=97=A5=E5=91=A8=E4=BA=94 =E4=B8=8A=E5=8D=882:26=E5=86=99=E9=81=93=EF=BC=
=9A
>
> Looks good, but you will have to wait until net-next reopens:
>
> http://vger.kernel.org/~davem/net-next.html
>
> Will keep this in my patchwork until that happens.
>
> Thanks.
>
> On Tue, Jul 16, 2019 at 10:13:01AM +0800, yangxingwu wrote:
> > this patch removes extra spaces
> >
> > Signed-off-by: yangxingwu <xingwu.yang@gmail.com>
> > ---
> >  net/netfilter/ipset/ip_set_hash_gen.h  | 2 +-
> >  net/netfilter/ipset/ip_set_list_set.c  | 2 +-
> >  net/netfilter/ipvs/ip_vs_core.c        | 2 +-
> >  net/netfilter/ipvs/ip_vs_mh.c          | 4 ++--
> >  net/netfilter/ipvs/ip_vs_proto_tcp.c   | 2 +-
> >  net/netfilter/nf_conntrack_ftp.c       | 2 +-
> >  net/netfilter/nf_conntrack_proto_tcp.c | 2 +-
> >  net/netfilter/nfnetlink_log.c          | 4 ++--
> >  net/netfilter/nfnetlink_queue.c        | 4 ++--
> >  net/netfilter/xt_IDLETIMER.c           | 2 +-
> >  10 files changed, 13 insertions(+), 13 deletions(-)
> >
> > diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipse=
t/ip_set_hash_gen.h
> > index 10f6196..eb907d2 100644
> > --- a/net/netfilter/ipset/ip_set_hash_gen.h
> > +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> > @@ -954,7 +954,7 @@ struct htype {
> >               mtype_data_netmask(d, NCIDR_GET(h->nets[j].cidr[0]));
> >  #endif
> >               key =3D HKEY(d, h->initval, t->htable_bits);
> > -             n =3D  rcu_dereference_bh(hbucket(t, key));
> > +             n =3D rcu_dereference_bh(hbucket(t, key));
> >               if (!n)
> >                       continue;
> >               for (i =3D 0; i < n->pos; i++) {
> > diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipse=
t/ip_set_list_set.c
> > index 8ada318..5c2be76 100644
> > --- a/net/netfilter/ipset/ip_set_list_set.c
> > +++ b/net/netfilter/ipset/ip_set_list_set.c
> > @@ -289,7 +289,7 @@ struct list_set {
> >       if (n &&
> >           !(SET_WITH_TIMEOUT(set) &&
> >             ip_set_timeout_expired(ext_timeout(n, set))))
> > -             n =3D  NULL;
> > +             n =3D NULL;
> >
> >       e =3D kzalloc(set->dsize, GFP_ATOMIC);
> >       if (!e)
> > diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs=
_core.c
> > index 7138556..6b3ae76 100644
> > --- a/net/netfilter/ipvs/ip_vs_core.c
> > +++ b/net/netfilter/ipvs/ip_vs_core.c
> > @@ -615,7 +615,7 @@ int ip_vs_leave(struct ip_vs_service *svc, struct s=
k_buff *skb,
> >               unsigned int flags =3D (svc->flags & IP_VS_SVC_F_ONEPACKE=
T &&
> >                                     iph->protocol =3D=3D IPPROTO_UDP) ?
> >                                     IP_VS_CONN_F_ONE_PACKET : 0;
> > -             union nf_inet_addr daddr =3D  { .all =3D { 0, 0, 0, 0 } }=
;
> > +             union nf_inet_addr daddr =3D { .all =3D { 0, 0, 0, 0 } };
> >
> >               /* create a new connection entry */
> >               IP_VS_DBG(6, "%s(): create a cache_bypass entry\n", __fun=
c__);
> > diff --git a/net/netfilter/ipvs/ip_vs_mh.c b/net/netfilter/ipvs/ip_vs_m=
h.c
> > index 94d9d34..da0280c 100644
> > --- a/net/netfilter/ipvs/ip_vs_mh.c
> > +++ b/net/netfilter/ipvs/ip_vs_mh.c
> > @@ -174,8 +174,8 @@ static int ip_vs_mh_populate(struct ip_vs_mh_state =
*s,
> >               return 0;
> >       }
> >
> > -     table =3D  kcalloc(BITS_TO_LONGS(IP_VS_MH_TAB_SIZE),
> > -                      sizeof(unsigned long), GFP_KERNEL);
> > +     table =3D kcalloc(BITS_TO_LONGS(IP_VS_MH_TAB_SIZE),
> > +                     sizeof(unsigned long), GFP_KERNEL);
> >       if (!table)
> >               return -ENOMEM;
> >
> > diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/=
ip_vs_proto_tcp.c
> > index 915ac82..c7b46a9 100644
> > --- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
> > +++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
> > @@ -710,7 +710,7 @@ static int __ip_vs_tcp_init(struct netns_ipvs *ipvs=
, struct ip_vs_proto_data *pd
> >                                                       sizeof(tcp_timeou=
ts));
> >       if (!pd->timeout_table)
> >               return -ENOMEM;
> > -     pd->tcp_state_table =3D  tcp_states;
> > +     pd->tcp_state_table =3D tcp_states;
> >       return 0;
> >  }
> >
> > diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntr=
ack_ftp.c
> > index 8c6c11b..26c1ff8 100644
> > --- a/net/netfilter/nf_conntrack_ftp.c
> > +++ b/net/netfilter/nf_conntrack_ftp.c
> > @@ -162,7 +162,7 @@ static int try_rfc959(const char *data, size_t dlen=
,
> >       if (length =3D=3D 0)
> >               return 0;
> >
> > -     cmd->u3.ip =3D  htonl((array[0] << 24) | (array[1] << 16) |
> > +     cmd->u3.ip =3D htonl((array[0] << 24) | (array[1] << 16) |
> >                                   (array[2] << 8) | array[3]);
> >       cmd->u.tcp.port =3D htons((array[4] << 8) | array[5]);
> >       return length;
> > diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_=
conntrack_proto_tcp.c
> > index 1e2cc83..48f3a67 100644
> > --- a/net/netfilter/nf_conntrack_proto_tcp.c
> > +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> > @@ -1225,7 +1225,7 @@ static int tcp_to_nlattr(struct sk_buff *skb, str=
uct nlattr *nla,
> >       [CTA_PROTOINFO_TCP_WSCALE_ORIGINAL] =3D { .type =3D NLA_U8 },
> >       [CTA_PROTOINFO_TCP_WSCALE_REPLY]    =3D { .type =3D NLA_U8 },
> >       [CTA_PROTOINFO_TCP_FLAGS_ORIGINAL]  =3D { .len =3D sizeof(struct =
nf_ct_tcp_flags) },
> > -     [CTA_PROTOINFO_TCP_FLAGS_REPLY]     =3D { .len =3D  sizeof(struct=
 nf_ct_tcp_flags) },
> > +     [CTA_PROTOINFO_TCP_FLAGS_REPLY]     =3D { .len =3D sizeof(struct =
nf_ct_tcp_flags) },
> >  };
> >
> >  #define TCP_NLATTR_SIZE      ( \
> > diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_lo=
g.c
> > index 6dee4f9..d69e186 100644
> > --- a/net/netfilter/nfnetlink_log.c
> > +++ b/net/netfilter/nfnetlink_log.c
> > @@ -651,7 +651,7 @@ static void nfulnl_instance_free_rcu(struct rcu_hea=
d *head)
> >       /* FIXME: do we want to make the size calculation conditional bas=
ed on
> >        * what is actually present?  way more branches and checks, but m=
ore
> >        * memory efficient... */
> > -     size =3D    nlmsg_total_size(sizeof(struct nfgenmsg))
> > +     size =3D nlmsg_total_size(sizeof(struct nfgenmsg))
> >               + nla_total_size(sizeof(struct nfulnl_msg_packet_hdr))
> >               + nla_total_size(sizeof(u_int32_t))     /* ifindex */
> >               + nla_total_size(sizeof(u_int32_t))     /* ifindex */
> > @@ -668,7 +668,7 @@ static void nfulnl_instance_free_rcu(struct rcu_hea=
d *head)
> >               + nla_total_size(sizeof(struct nfgenmsg));      /* NLMSG_=
DONE */
> >
> >       if (in && skb_mac_header_was_set(skb)) {
> > -             size +=3D   nla_total_size(skb->dev->hard_header_len)
> > +             size +=3D nla_total_size(skb->dev->hard_header_len)
> >                       + nla_total_size(sizeof(u_int16_t))     /* hwtype=
 */
> >                       + nla_total_size(sizeof(u_int16_t));    /* hwlen =
*/
> >       }
> > diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_=
queue.c
> > index 89750f7..a1ef6e3 100644
> > --- a/net/netfilter/nfnetlink_queue.c
> > +++ b/net/netfilter/nfnetlink_queue.c
> > @@ -394,7 +394,7 @@ static int nfqnl_put_bridge(struct nf_queue_entry *=
entry, struct sk_buff *skb)
> >       char *secdata =3D NULL;
> >       u32 seclen =3D 0;
> >
> > -     size =3D    nlmsg_total_size(sizeof(struct nfgenmsg))
> > +     size =3D nlmsg_total_size(sizeof(struct nfgenmsg))
> >               + nla_total_size(sizeof(struct nfqnl_msg_packet_hdr))
> >               + nla_total_size(sizeof(u_int32_t))     /* ifindex */
> >               + nla_total_size(sizeof(u_int32_t))     /* ifindex */
> > @@ -453,7 +453,7 @@ static int nfqnl_put_bridge(struct nf_queue_entry *=
entry, struct sk_buff *skb)
> >       }
> >
> >       if (queue->flags & NFQA_CFG_F_UID_GID) {
> > -             size +=3D  (nla_total_size(sizeof(u_int32_t))     /* uid =
*/
> > +             size +=3D (nla_total_size(sizeof(u_int32_t))      /* uid =
*/
> >                       + nla_total_size(sizeof(u_int32_t)));   /* gid */
> >       }
> >
> > diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.=
c
> > index 9cec9ea..f56d3ed 100644
> > --- a/net/netfilter/xt_IDLETIMER.c
> > +++ b/net/netfilter/xt_IDLETIMER.c
> > @@ -283,7 +283,7 @@ static int __init idletimer_tg_init(void)
> >
> >       idletimer_tg_kobj =3D &idletimer_tg_device->kobj;
> >
> > -     err =3D  xt_register_target(&idletimer_tg);
> > +     err =3D xt_register_target(&idletimer_tg);
> >       if (err < 0) {
> >               pr_debug("couldn't register xt target\n");
> >               goto out_dev;
> > --
> > 1.8.3.1
> >
