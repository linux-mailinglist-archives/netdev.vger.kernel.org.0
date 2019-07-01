Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 371255C0A1
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 17:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729979AbfGAPtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 11:49:17 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:36842 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729973AbfGAPtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 11:49:16 -0400
Received: by mail-yw1-f67.google.com with SMTP id t126so145665ywf.3
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 08:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kq+wnbBq/Yiwlhufxf5DcNxbDH6VKCaJIWYPDt1uop4=;
        b=T0kExSnoaBymARSjTN9BRYIN7Sra2f79runCRwBFHrSHSoaG5/rKsvaIcfIa7Zg/fW
         mUqAYhvVdeAHH4Ic+7fYx/qeW5E/DSIvjHmzPYTzTR4eensVwp7LV98/txph/k6wmQHj
         6vxEvYAmyEGydGKoTpsbVwvYdsvmNFkWvjXe/D4JlxJnks6E0i1kvQd2LJNTM5UZvcfp
         whD4W+793XKFtKEatGB/UVMukZMm65euVWWtGD9wZY57Qu9E13iUy5dBb9+DbTEu823L
         OpsOO5IJh1reEEXDcSFNY1oF+JviAcYtgK57uVkgukjgw3M3/oU41PyR4SAoF3bfXPNj
         Wt9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kq+wnbBq/Yiwlhufxf5DcNxbDH6VKCaJIWYPDt1uop4=;
        b=KVEObfUhwjszSaDS+e5I3cDgQqE+bFVxF0d3novDYjF6NxryLmEl5V0vMegLl4bATQ
         awnB1yxhvt4IzFNKGocdRLBlzb6KDqESqCKYdgm+F5DOnio+uI0YGiLBzg28PDSqaxjt
         cYBeviMpKxY8nzn3kcFFnEwHj07XZ80/CfQoVySh1VTtCGT9nDeaValGlFSN8/3F45ON
         B0w4SEmrq6mdezRlpqtoEqM3dLKhPh/611HnhLZmWiXRIbABwQNjy4dX1aJWC4IkrDsN
         0FqfdFL1pxn6QlgI8Hc9iXQN6jqJVOiDEDDFgr8IIVrTMBr1KZOytwfRq4zojn7EaL+W
         3YNQ==
X-Gm-Message-State: APjAAAWpya9Be6/5mm5lJEvy/53TikHXU4jFuAlkO5kR7taUFzYXBffN
        3Hwdef+Fvs1ETS+xXwcULPn2zNKC
X-Google-Smtp-Source: APXvYqwmIqn7ZJeZ7IFMKcGChQHrX4HAb1NeEFGMAJ/OyQ+//Q5vn20KyY4+Xs/ZT8PT6z0jviKtRQ==
X-Received: by 2002:a81:7d07:: with SMTP id y7mr13216028ywc.377.1561996154648;
        Mon, 01 Jul 2019 08:49:14 -0700 (PDT)
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com. [209.85.219.178])
        by smtp.gmail.com with ESMTPSA id j9sm2629345ywc.43.2019.07.01.08.49.13
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 08:49:13 -0700 (PDT)
Received: by mail-yb1-f178.google.com with SMTP id f195so130851ybg.9
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 08:49:13 -0700 (PDT)
X-Received: by 2002:a5b:4c9:: with SMTP id u9mr4807654ybp.235.1561996152992;
 Mon, 01 Jul 2019 08:49:12 -0700 (PDT)
MIME-Version: 1.0
References: <1561984257-9798-1-git-send-email-john.hurley@netronome.com> <1561984257-9798-5-git-send-email-john.hurley@netronome.com>
In-Reply-To: <1561984257-9798-5-git-send-email-john.hurley@netronome.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 1 Jul 2019 11:48:38 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdwmg9Ui4K+PNurs2UN3EX1HSF2h2mV88h+PY8SCwKoPw@mail.gmail.com>
Message-ID: <CA+FuTSdwmg9Ui4K+PNurs2UN3EX1HSF2h2mV88h+PY8SCwKoPw@mail.gmail.com>
Subject: Re: [PATCH net-next v4 4/5] net: sched: add mpls manipulation actions
 to TC
To:     John Hurley <john.hurley@netronome.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, jiri@mellanox.com,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Ahern <dsahern@gmail.com>, simon.horman@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 1, 2019 at 8:31 AM John Hurley <john.hurley@netronome.com> wrote:
>
> Currently, TC offers the ability to match on the MPLS fields of a packet
> through the use of the flow_dissector_key_mpls struct. However, as yet, TC
> actions do not allow the modification or manipulation of such fields.
>
> Add a new module that registers TC action ops to allow manipulation of
> MPLS. This includes the ability to push and pop headers as well as modify
> the contents of new or existing headers. A further action to decrement the
> TTL field of an MPLS header is also provided.
>
> Signed-off-by: John Hurley <john.hurley@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>

> +static __be32 tcf_mpls_get_lse(struct mpls_shim_hdr *lse,
> +                              struct tcf_mpls_params *p, bool set_bos)
> +{
> +       u32 new_lse = 0;
> +
> +       if (lse)
> +               new_lse = be32_to_cpu(lse->label_stack_entry);
> +
> +       if (p->tcfm_label) {
> +               new_lse &= ~MPLS_LS_LABEL_MASK;
> +               new_lse |= p->tcfm_label << MPLS_LS_LABEL_SHIFT;
> +       }
> +       if (p->tcfm_ttl) {
> +               new_lse &= ~MPLS_LS_TTL_MASK;
> +               new_lse |= p->tcfm_ttl << MPLS_LS_TTL_SHIFT;
> +       }
> +       if (p->tcfm_tc != ACT_MPLS_TC_NOT_SET) {
> +               new_lse &= ~MPLS_LS_TC_MASK;
> +               new_lse |= p->tcfm_tc << MPLS_LS_TC_SHIFT;
> +       }
> +       if (p->tcfm_bos != ACT_MPLS_BOS_NOT_SET) {
> +               new_lse &= ~MPLS_LS_S_MASK;
> +               new_lse |= p->tcfm_bos << MPLS_LS_S_SHIFT;
> +       } else if (set_bos) {
> +               new_lse |= 1 << MPLS_LS_S_SHIFT;
> +       }

not necessarily for this patchset, but perhaps it would make code more
readable to add a struct mpls_label_type with integer bit fields to avoid
all this explicit masking and shifting.

> +static int tcf_mpls_act(struct sk_buff *skb, const struct tc_action *a,
> +                       struct tcf_result *res)
> +{
> +       struct tcf_mpls *m = to_mpls(a);
> +       struct mpls_shim_hdr *pkt_lse;
> +       struct tcf_mpls_params *p;
> +       __be32 new_lse;
> +       u32 cpu_lse;
> +       int ret;
> +       u8 ttl;
> +
> +       tcf_lastuse_update(&m->tcf_tm);
> +       bstats_cpu_update(this_cpu_ptr(m->common.cpu_bstats), skb);
> +
> +       /* Ensure 'data' points at mac_header prior calling mpls manipulating
> +        * functions.
> +        */
> +       if (skb_at_tc_ingress(skb))
> +               skb_push_rcsum(skb, skb->mac_len);
> +
> +       ret = READ_ONCE(m->tcf_action);
> +
> +       p = rcu_dereference_bh(m->mpls_p);
> +
> +       switch (p->tcfm_action) {
> +       case TCA_MPLS_ACT_POP:
> +               if (skb_mpls_pop(skb, p->tcfm_proto))
> +                       goto drop;
> +               break;
> +       case TCA_MPLS_ACT_PUSH:
> +               new_lse = tcf_mpls_get_lse(NULL, p, !eth_p_mpls(skb->protocol));
> +               if (skb_mpls_push(skb, new_lse, p->tcfm_proto))
> +                       goto drop;
> +               break;
> +       case TCA_MPLS_ACT_MODIFY:
> +               new_lse = tcf_mpls_get_lse(mpls_hdr(skb), p, false);
> +               if (skb_mpls_update_lse(skb, new_lse))
> +                       goto drop;
> +               break;
> +       case TCA_MPLS_ACT_DEC_TTL:
> +               pkt_lse = mpls_hdr(skb);
> +               cpu_lse = be32_to_cpu(pkt_lse->label_stack_entry);
> +               ttl = (cpu_lse & MPLS_LS_TTL_MASK) >> MPLS_LS_TTL_SHIFT;
> +               if (!--ttl)
> +                       goto drop;
> +
> +               cpu_lse &= ~MPLS_LS_TTL_MASK;
> +               cpu_lse |= ttl << MPLS_LS_TTL_SHIFT;

this could perhaps use a helper of its own?


> +               if (skb_mpls_update_lse(skb, cpu_to_be32(cpu_lse)))
> +                       goto drop;
> +               break;
> +       }
