Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87E6A46538
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 18:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725825AbfFNQ70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 12:59:26 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33020 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfFNQ70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 12:59:26 -0400
Received: by mail-pg1-f196.google.com with SMTP id k187so1896154pga.0
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 09:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0uZICgZ06K8Aj2ZvodgKxKoyv1EpRvOXIrB0Hvtlrg8=;
        b=GKWLBgFDqsadjLfvW7oHDrBdDUa739vWMbc52Sa9Y7kWyk6NKOBaH10QFWmFMDq1YX
         gVx49NFLUlfWZ2nGOVi6aOnnWTh8of8NBaSP6vqBgyLGa5YusnmbEJnghYbIEfh2snSx
         Cc8troWXKdFtzK6FtfYwDBQ/dprZAX1HSe0kOcxXZ2fx7q9u6avgsGO8d0PLsA9nFncd
         g9j9K/Sv+5kh0O3/SXe5nc6MYOJ/UzoqLAHKcZdE7TB/WSUVN/8Y1NIxCCEb+wFHCVek
         bg/N6XEI/GQP5G7rvKge+bFX4o1GWZvZYcpBpgffl/rwwagIOf4benb/vZuOh9AhtS5C
         JsKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0uZICgZ06K8Aj2ZvodgKxKoyv1EpRvOXIrB0Hvtlrg8=;
        b=CJ8f0vAyrPFhNaXlOxNutr8OCClg3NicrwnCCgSbmBEv59RaOp/vhYso//9+tQU94J
         gsW3Cq+FO0WSbDSmj0Rk2ovrIgxohKssJ9AVs6xOBrMnnTurVvoSdxdOdN8ZOOVtT43y
         2ogE+O8xPsEu5oQ5SjVRAncvVVcHBmBy8bWXR3g5Q259zLFuNzPwXJ9kPpsQHw0hoHzc
         BQy8PbYv9hqURCcYGpYQGKbyOcqIOIPHK7G6mHwzgTymt5/OUvPAyjOE2/B4LufzwTmJ
         EKMJE8JaheOdXXJCN+XKL59wx66k2Y3jckNVXd1DM6yAxVNpqSX8iHrP9+PuopIb2cmp
         7QYQ==
X-Gm-Message-State: APjAAAUxs+HG5frE03kdEEalek1+EQYGbhYCdvFGKIUfkDaF7b9T4x8B
        kOKRcUwau4jKLNmGI7vjYnD0AodLBX99fgfkSZ+WJWUJwd8=
X-Google-Smtp-Source: APXvYqzz8mQBcSDgLSKIIRWY27zYT28wdzgf+K2KfQS2E4WWrRgYr4gGHsA2fo6q4q7oyKEYcYESd9FhRXBnIAvwigs=
X-Received: by 2002:a17:90a:b883:: with SMTP id o3mr4122809pjr.50.1560531565618;
 Fri, 14 Jun 2019 09:59:25 -0700 (PDT)
MIME-Version: 1.0
References: <1560447839-8337-1-git-send-email-john.hurley@netronome.com> <1560447839-8337-2-git-send-email-john.hurley@netronome.com>
In-Reply-To: <1560447839-8337-2-git-send-email-john.hurley@netronome.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 14 Jun 2019 09:59:14 -0700
Message-ID: <CAM_iQpU0jZhg60-CVEZ9H1N57ga9jPwVt5tF1fM=uP_sj4kmKQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/3] net: sched: add mpls manipulation actions
 to TC
To:     John Hurley <john.hurley@netronome.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 10:44 AM John Hurley <john.hurley@netronome.com> wrote:
> +static inline void tcf_mpls_set_eth_type(struct sk_buff *skb, __be16 ethertype)
> +{
> +       struct ethhdr *hdr = eth_hdr(skb);
> +
> +       skb_postpull_rcsum(skb, &hdr->h_proto, ETH_TLEN);
> +       hdr->h_proto = ethertype;
> +       skb_postpush_rcsum(skb, &hdr->h_proto, ETH_TLEN);

So you just want to adjust the checksum with the new ->h_proto
value. please use a right csum API, rather than skb_post*_rcsum().


> +}
> +
> +static int tcf_mpls_act(struct sk_buff *skb, const struct tc_action *a,
> +                       struct tcf_result *res)
> +{
> +       struct tcf_mpls *m = to_mpls(a);
> +       struct mpls_shim_hdr *lse;
> +       struct tcf_mpls_params *p;
> +       u32 temp_lse;
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
> +               if (unlikely(!eth_p_mpls(skb->protocol)))
> +                       goto out;
> +
> +               if (unlikely(skb_ensure_writable(skb, ETH_HLEN + MPLS_HLEN)))
> +                       goto drop;
> +
> +               skb_postpull_rcsum(skb, mpls_hdr(skb), MPLS_HLEN);
> +               memmove(skb->data + MPLS_HLEN, skb->data, ETH_HLEN);
> +
> +               __skb_pull(skb, MPLS_HLEN);
> +               skb_reset_mac_header(skb);
> +               skb_set_network_header(skb, ETH_HLEN);
> +
> +               tcf_mpls_set_eth_type(skb, p->tcfm_proto);
> +               skb->protocol = p->tcfm_proto;
> +               break;
> +       case TCA_MPLS_ACT_PUSH:
> +               if (unlikely(skb_cow_head(skb, MPLS_HLEN)))
> +                       goto drop;
> +
> +               skb_push(skb, MPLS_HLEN);
> +               memmove(skb->data, skb->data + MPLS_HLEN, ETH_HLEN);
> +               skb_reset_mac_header(skb);
> +               skb_set_network_header(skb, ETH_HLEN);
> +
> +               lse = mpls_hdr(skb);
> +               lse->label_stack_entry = 0;
> +               tcf_mpls_mod_lse(lse, p, !eth_p_mpls(skb->protocol));
> +               skb_postpush_rcsum(skb, lse, MPLS_HLEN);
> +
> +               tcf_mpls_set_eth_type(skb, p->tcfm_proto);
> +               skb->protocol = p->tcfm_proto;
> +               break;

Is it possible to refactor and reuse the similar code in
net/openvswitch/actions.c::pop_mpls()/push_mpls()?



> +       case TCA_MPLS_ACT_MODIFY:
> +               if (unlikely(!eth_p_mpls(skb->protocol)))
> +                       goto out;
> +
> +               if (unlikely(skb_ensure_writable(skb, ETH_HLEN + MPLS_HLEN)))
> +                       goto drop;
> +
> +               lse = mpls_hdr(skb);
> +               skb_postpull_rcsum(skb, lse, MPLS_HLEN);
> +               tcf_mpls_mod_lse(lse, p, false);
> +               skb_postpush_rcsum(skb, lse, MPLS_HLEN);
> +               break;
> +       case TCA_MPLS_ACT_DEC_TTL:
> +               if (unlikely(!eth_p_mpls(skb->protocol)))
> +                       goto out;
> +
> +               if (unlikely(skb_ensure_writable(skb, ETH_HLEN + MPLS_HLEN)))
> +                       goto drop;
> +
> +               lse = mpls_hdr(skb);
> +               temp_lse = be32_to_cpu(lse->label_stack_entry);
> +               ttl = (temp_lse & MPLS_LS_TTL_MASK) >> MPLS_LS_TTL_SHIFT;
> +               if (!--ttl)
> +                       goto drop;
> +
> +               temp_lse &= ~MPLS_LS_TTL_MASK;
> +               temp_lse |= ttl << MPLS_LS_TTL_SHIFT;
> +               skb_postpull_rcsum(skb, lse, MPLS_HLEN);
> +               lse->label_stack_entry = cpu_to_be32(temp_lse);
> +               skb_postpush_rcsum(skb, lse, MPLS_HLEN);
> +               break;
> +       default:
> +               WARN_ONCE(1, "Invalid MPLS action\n");


This warning is not necessary, it must be validated in ->init().


> +       }
> +
> +out:
> +       if (skb_at_tc_ingress(skb))
> +               skb_pull_rcsum(skb, skb->mac_len);
> +
> +       return ret;
> +
> +drop:
> +       qstats_drop_inc(this_cpu_ptr(m->common.cpu_qstats));
> +       return TC_ACT_SHOT;
> +}


Thanks.
