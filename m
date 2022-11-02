Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5F32616E30
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 21:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbiKBUBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 16:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbiKBUBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 16:01:35 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E171F6
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 13:01:34 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-13be3ef361dso21460439fac.12
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 13:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=G7frePhVMpSHekwnUP8Dhk+DEuV7z9o13HcXqfk5mOk=;
        b=feU+JDh68j1H5jkd3Z6yi8SgAsgBg/FNuM7yw8QnjxPj6zYafwNhCL0JFX48DV+cBs
         fhLtu2zu4Wi+uSSEH9rMAt4+xMQerHDPupxETn4I+PuwE7eVLzsd+j2d6GB+ojtdBH/r
         au8j6C2Dkeb1UMmO2YMWQ4WHbonyaeHaqgho1SxYGOaGuWDSpdc/K2/bY7k6Px9jFeDZ
         qVEAgO8cN5G2IR62+aiABcnVhMKYS7gfADPb7K/+StjGzlGsEQ3wexMakXilzmoBUV9W
         kWWj00FShs733LidjW67bRiZC6zfUgAbsuABXC37QhEUBhIhrySKL1mVDyfV4kLEZpSV
         c79A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G7frePhVMpSHekwnUP8Dhk+DEuV7z9o13HcXqfk5mOk=;
        b=EefGOSTVGRmyLoNlaUorF0XZ+TP4K1xNF3+2cYTYxQMFY92pNA94d+Us0QssnpGoza
         wHwTopTzjrHBBnyTV437KGcncfEEDxA6x+qzz9lK8cdh/Z+DpstORRsPX0MGCPZb9JNg
         0+sfPrSo3X8RgMjFkyqPYGGu+fuO2F8FtNFTWgU2Pb+zRWRXbRchysKucoMkR3z+fOLJ
         vDnnzIGPj/t6E5t/v8ExuXWUTwe3hcCi5D6n7L4L3YGdY/nnW7hc3QCBWWV8XCk6omhh
         0Bckd5cngSFoG6UfePhnflIRGWUj+8ReXzAoNKZrD+yINHljB96+fV8w20ke7+LZY9I7
         lZeg==
X-Gm-Message-State: ACrzQf1g6E7ZBmyiq2H36idDL9+V/nKatB3zhggpv2T3JyZ/PvbxRE6j
        mjjAGI1lhLfPDgHpI3edhgP/7puGhbR84I4m9VTXNHeHDio=
X-Google-Smtp-Source: AMsMyM5BKgcGhACF0rj2vyn4Q5GOilWhYDgLc9NmJmKyLh4jQSxuSnvzIGJu4FkKHzs9pGHSCCRnEHBZPX5W42GiufI=
X-Received: by 2002:a05:6870:523:b0:131:2d50:e09c with SMTP id
 j35-20020a056870052300b001312d50e09cmr25996649oao.129.1667419293581; Wed, 02
 Nov 2022 13:01:33 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1667230381.git.lucien.xin@gmail.com> <77bf40ce177056d460cc7ed32ef4d19d1f7b5290.1667230381.git.lucien.xin@gmail.com>
 <f7ttu3hf9hk.fsf@redhat.com>
In-Reply-To: <f7ttu3hf9hk.fsf@redhat.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 2 Nov 2022 16:01:09 -0400
Message-ID: <CADvbK_d6zmbBQH_+1hK2EX9L1MW=RFUbT8j8NQkK10cXMDJ2bg@mail.gmail.com>
Subject: Re: [PATCHv3 net-next 1/4] net: move the ct helper function to
 nf_conntrack_helper for ovs and tc
To:     Aaron Conole <aconole@redhat.com>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        ovs-dev@openvswitch.org, davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 2, 2022 at 3:21 PM Aaron Conole <aconole@redhat.com> wrote:
>
> Xin Long <lucien.xin@gmail.com> writes:
>
> > Move ovs_ct_helper from openvswitch to nf_conntrack_helper and rename
> > as nf_ct_helper so that it can be used in TC act_ct in the next patch.
> > Note that it also adds the checks for the family and proto, as in TC
> > act_ct, the packets with correct family and proto are not guaranteed.
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
>
> Hi Xin,
>
> >  include/net/netfilter/nf_conntrack_helper.h |  2 +
> >  net/netfilter/nf_conntrack_helper.c         | 71 +++++++++++++++++++++
> >  net/openvswitch/conntrack.c                 | 61 +-----------------
> >  3 files changed, 74 insertions(+), 60 deletions(-)
> >
> > diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
> > index 9939c366f720..6c32e59fc16f 100644
> > --- a/include/net/netfilter/nf_conntrack_helper.h
> > +++ b/include/net/netfilter/nf_conntrack_helper.h
> > @@ -115,6 +115,8 @@ struct nf_conn_help *nf_ct_helper_ext_add(struct nf_conn *ct, gfp_t gfp);
> >  int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
> >                             gfp_t flags);
> >
> > +int nf_ct_helper(struct sk_buff *skb, u16 proto);
> > +
> >  void nf_ct_helper_destroy(struct nf_conn *ct);
> >
> >  static inline struct nf_conn_help *nfct_help(const struct nf_conn *ct)
> > diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
> > index ff737a76052e..83615e479f87 100644
> > --- a/net/netfilter/nf_conntrack_helper.c
> > +++ b/net/netfilter/nf_conntrack_helper.c
> > @@ -26,7 +26,9 @@
> >  #include <net/netfilter/nf_conntrack_extend.h>
> >  #include <net/netfilter/nf_conntrack_helper.h>
> >  #include <net/netfilter/nf_conntrack_l4proto.h>
> > +#include <net/netfilter/nf_conntrack_seqadj.h>
> >  #include <net/netfilter/nf_log.h>
> > +#include <net/ip.h>
> >
> >  static DEFINE_MUTEX(nf_ct_helper_mutex);
> >  struct hlist_head *nf_ct_helper_hash __read_mostly;
> > @@ -240,6 +242,75 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
> >  }
> >  EXPORT_SYMBOL_GPL(__nf_ct_try_assign_helper);
> >
> > +/* 'skb' should already be pulled to nh_ofs. */
> > +int nf_ct_helper(struct sk_buff *skb, u16 proto)
>
> AFAICT, in all the places we call this we will have the nf_conn and
> ip_conntrack_info already.  Maybe it makes sense to pass them here
> rather than looking up again?  Originally, that information wasn't
> available in the calling function - over time this has been added so we
> might as well reduce the amount of "extra lookups" performed.
I just tried to keep nf_ct_helper() as similar as possible
to the original ovs_ct_helper().

But sure, we can also pass ct and ctinfo as the arguments,
like some other functions where it passes all of skb, ct and ctinfo.

Thanks.

>
> > +{
> > +     const struct nf_conntrack_helper *helper;
> > +     const struct nf_conn_help *help;
> > +     enum ip_conntrack_info ctinfo;
> > +     unsigned int protoff;
> > +     struct nf_conn *ct;
> > +     int err;
> > +
> > +     ct = nf_ct_get(skb, &ctinfo);
> > +     if (!ct || ctinfo == IP_CT_RELATED_REPLY)
> > +             return NF_ACCEPT;
> > +
> > +     help = nfct_help(ct);
> > +     if (!help)
> > +             return NF_ACCEPT;
> > +
> > +     helper = rcu_dereference(help->helper);
> > +     if (!helper)
> > +             return NF_ACCEPT;
> > +
> > +     if (helper->tuple.src.l3num != NFPROTO_UNSPEC &&
> > +         helper->tuple.src.l3num != proto)
> > +             return NF_ACCEPT;
> > +
> > +     switch (proto) {
> > +     case NFPROTO_IPV4:
> > +             protoff = ip_hdrlen(skb);
> > +             proto = ip_hdr(skb)->protocol;
> > +             break;
> > +     case NFPROTO_IPV6: {
> > +             u8 nexthdr = ipv6_hdr(skb)->nexthdr;
> > +             __be16 frag_off;
> > +             int ofs;
> > +
> > +             ofs = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr,
> > +                                    &frag_off);
> > +             if (ofs < 0 || (frag_off & htons(~0x7)) != 0) {
> > +                     pr_debug("proto header not found\n");
> > +                     return NF_ACCEPT;
> > +             }
> > +             protoff = ofs;
> > +             proto = nexthdr;
> > +             break;
> > +     }
> > +     default:
> > +             WARN_ONCE(1, "helper invoked on non-IP family!");
> > +             return NF_DROP;
> > +     }
> > +
> > +     if (helper->tuple.dst.protonum != proto)
> > +             return NF_ACCEPT;
> > +
> > +     err = helper->help(skb, protoff, ct, ctinfo);
> > +     if (err != NF_ACCEPT)
> > +             return err;
> > +
> > +     /* Adjust seqs after helper.  This is needed due to some helpers (e.g.,
> > +      * FTP with NAT) adusting the TCP payload size when mangling IP
> > +      * addresses and/or port numbers in the text-based control connection.
> > +      */
> > +     if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
> > +         !nf_ct_seq_adjust(skb, ct, ctinfo, protoff))
> > +             return NF_DROP;
> > +     return NF_ACCEPT;
> > +}
> > +EXPORT_SYMBOL_GPL(nf_ct_helper);
> > +
> >  /* appropriate ct lock protecting must be taken by caller */
> >  static int unhelp(struct nf_conn *ct, void *me)
> >  {
> > diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
> > index c7b10234cf7c..19b5c54615c8 100644
> > --- a/net/openvswitch/conntrack.c
> > +++ b/net/openvswitch/conntrack.c
> > @@ -434,65 +434,6 @@ static int ovs_ct_set_labels(struct nf_conn *ct, struct sw_flow_key *key,
> >       return 0;
> >  }
> >
> > -/* 'skb' should already be pulled to nh_ofs. */
> > -static int ovs_ct_helper(struct sk_buff *skb, u16 proto)
> > -{
> > -     const struct nf_conntrack_helper *helper;
> > -     const struct nf_conn_help *help;
> > -     enum ip_conntrack_info ctinfo;
> > -     unsigned int protoff;
> > -     struct nf_conn *ct;
> > -     int err;
> > -
> > -     ct = nf_ct_get(skb, &ctinfo);
> > -     if (!ct || ctinfo == IP_CT_RELATED_REPLY)
> > -             return NF_ACCEPT;
> > -
> > -     help = nfct_help(ct);
> > -     if (!help)
> > -             return NF_ACCEPT;
> > -
> > -     helper = rcu_dereference(help->helper);
> > -     if (!helper)
> > -             return NF_ACCEPT;
> > -
> > -     switch (proto) {
> > -     case NFPROTO_IPV4:
> > -             protoff = ip_hdrlen(skb);
> > -             break;
> > -     case NFPROTO_IPV6: {
> > -             u8 nexthdr = ipv6_hdr(skb)->nexthdr;
> > -             __be16 frag_off;
> > -             int ofs;
> > -
> > -             ofs = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr,
> > -                                    &frag_off);
> > -             if (ofs < 0 || (frag_off & htons(~0x7)) != 0) {
> > -                     pr_debug("proto header not found\n");
> > -                     return NF_ACCEPT;
> > -             }
> > -             protoff = ofs;
> > -             break;
> > -     }
> > -     default:
> > -             WARN_ONCE(1, "helper invoked on non-IP family!");
> > -             return NF_DROP;
> > -     }
> > -
> > -     err = helper->help(skb, protoff, ct, ctinfo);
> > -     if (err != NF_ACCEPT)
> > -             return err;
> > -
> > -     /* Adjust seqs after helper.  This is needed due to some helpers (e.g.,
> > -      * FTP with NAT) adusting the TCP payload size when mangling IP
> > -      * addresses and/or port numbers in the text-based control connection.
> > -      */
> > -     if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
> > -         !nf_ct_seq_adjust(skb, ct, ctinfo, protoff))
> > -             return NF_DROP;
> > -     return NF_ACCEPT;
> > -}
> > -
> >  /* Returns 0 on success, -EINPROGRESS if 'skb' is stolen, or other nonzero
> >   * value if 'skb' is freed.
> >   */
> > @@ -1038,7 +979,7 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
> >                */
> >               if ((nf_ct_is_confirmed(ct) ? !cached || add_helper :
> >                                             info->commit) &&
> > -                 ovs_ct_helper(skb, info->family) != NF_ACCEPT) {
> > +                 nf_ct_helper(skb, info->family) != NF_ACCEPT) {
> >                       return -EINVAL;
> >               }
>
