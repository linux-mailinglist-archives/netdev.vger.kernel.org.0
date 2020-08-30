Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E444825705A
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 22:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgH3UCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 16:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbgH3UCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 16:02:39 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FAB7C061573;
        Sun, 30 Aug 2020 13:02:39 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id w7so1935527pfi.4;
        Sun, 30 Aug 2020 13:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mo5cAIcbwLzF8PLyUfTTGUYPFzb31BV6RLnWmzyqoHg=;
        b=JBx/cGx6MfiQz2OjroWGIBtpPeLHX8W0OWHVbciuPaSKbaYQdtiC2TUFNo88TOi6J+
         lSSALZGDzrHCwIbDmyWsTHbX9bcTCfR+Xqm50BTu9vZCe4nulNMjmvdYx5jC5uWAdXi+
         1qrEBX1U1s4f9Mu5oGyuTli3i93AY9CAst1dDMnXHmQN58tqz/BDnvVxx7hSF/I+0Vl1
         zQT2J06qYYginzSgt4nlzNb0uVRf4y0GCEduivD07fZVxPSPGDMndEpV/T8BkIp1XQEw
         nDvIHS5AKXUDe5ztq8WxzxKNAg/X/UaFvWqeeiCkKXPyzVxhgvl2ScM8IwY6HfEfaRcC
         KkSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mo5cAIcbwLzF8PLyUfTTGUYPFzb31BV6RLnWmzyqoHg=;
        b=n25tUgD+VEDdFi3bqcAaJN11X5YAY9mEY47CPMBe3DSdzxDpRaQLNMeWdWRdHrjWz9
         fVogXdQ8F52QTVFAzScHga1RXfc/Ny0q6d/hjd16zpcBSGHV1mPwqrveDD3Te3KeVGJi
         bL9UDwPOBMwYHlWMdDbcziXUCwFq5MBoNZqXAoLQYcdnKwgvAzm5/Aq14ByCr+YJLoUA
         ZCqaCKtDQ1HxzSRARRMAFtu9VtWjO4IoU2c1StnCj7hFg172aH1sBT+EEFoL3rdomD4j
         uks1W2yLafrno3qL6fwbamVU2bQhieT8m2ImHi6G+vDhCC6xSFfqWvB5++Mj6q0cRVHQ
         jKrA==
X-Gm-Message-State: AOAM5304zB4fUdLBDU5kUGkrGwgIWhdC2JD0+bwZJuEshIH/ysGlkzxw
        zqMu7XwLTonzo4dBo81JcDBamJ6RcIX9uPONEN8=
X-Google-Smtp-Source: ABdhPJxUffIbG/iCd16oJlINxEPYq4eIkGuYiKN/6PVKQddOAusN/dNB7UGQr/OGu9oykRFkFEiLYuXonN3E65r9lG0=
X-Received: by 2002:a62:2587:: with SMTP id l129mr6826216pfl.47.1598817755781;
 Sun, 30 Aug 2020 13:02:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200830151459.4648-1-trix@redhat.com>
In-Reply-To: <20200830151459.4648-1-trix@redhat.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Sun, 30 Aug 2020 23:02:19 +0300
Message-ID: <CAHp75VcdUoNMxzoQ4n2y4LrbYX5nTh3Y8rFh=5J9cv7iU-V=Hg@mail.gmail.com>
Subject: Re: [PATCH] net: openvswitch: pass NULL for unused parameters
To:     trix@redhat.com
Cc:     pshelar@ovn.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev <netdev@vger.kernel.org>, dev@openvswitch.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 30, 2020 at 6:17 PM <trix@redhat.com> wrote:
>
> From: Tom Rix <trix@redhat.com>
>
> clang static analysis flags these problems
>
> flow_table.c:713:2: warning: The expression is an uninitialized
>   value. The computed value will also be garbage
>         (*n_mask_hit)++;
>         ^~~~~~~~~~~~~~~
> flow_table.c:748:5: warning: The expression is an uninitialized
>   value. The computed value will also be garbage
>                                 (*n_cache_hit)++;
>                                 ^~~~~~~~~~~~~~~~
>
> These are not problems because neither pararmeter is used

parameter

> by the calling function.
>
> Looking at all of the calling functions, there are many
> cases where the results are unused.  Passing unused
> parameters is a waste.
>
> To avoid passing unused parameters, rework the
> masked_flow_lookup() and flow_lookup() routines to check
> for NULL parameters and change the unused parameters to NULL.
>
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  net/openvswitch/flow_table.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
>
> diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
> index e2235849a57e..18e7fa3aa67e 100644
> --- a/net/openvswitch/flow_table.c
> +++ b/net/openvswitch/flow_table.c
> @@ -710,7 +710,8 @@ static struct sw_flow *masked_flow_lookup(struct table_instance *ti,
>         ovs_flow_mask_key(&masked_key, unmasked, false, mask);
>         hash = flow_hash(&masked_key, &mask->range);
>         head = find_bucket(ti, hash);
> -       (*n_mask_hit)++;
> +       if (n_mask_hit)
> +               (*n_mask_hit)++;
>
>         hlist_for_each_entry_rcu(flow, head, flow_table.node[ti->node_ver],
>                                 lockdep_ovsl_is_held()) {
> @@ -745,7 +746,8 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
>                                 u64_stats_update_begin(&ma->syncp);
>                                 usage_counters[*index]++;
>                                 u64_stats_update_end(&ma->syncp);
> -                               (*n_cache_hit)++;
> +                               if (n_cache_hit)
> +                                       (*n_cache_hit)++;
>                                 return flow;
>                         }
>                 }
> @@ -798,9 +800,8 @@ struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *tbl,
>         *n_cache_hit = 0;

>         if (unlikely(!skb_hash || mc->cache_size == 0)) {
>                 u32 mask_index = 0;
> -               u32 cache = 0;
>
> -               return flow_lookup(tbl, ti, ma, key, n_mask_hit, &cache,
> +               return flow_lookup(tbl, ti, ma, key, n_mask_hit, NULL,
>                                    &mask_index);

Can it be done for mask_index as well?

>         }
>
> @@ -849,11 +850,9 @@ struct sw_flow *ovs_flow_tbl_lookup(struct flow_table *tbl,
>  {
>         struct table_instance *ti = rcu_dereference_ovsl(tbl->ti);
>         struct mask_array *ma = rcu_dereference_ovsl(tbl->mask_array);
> -       u32 __always_unused n_mask_hit;
> -       u32 __always_unused n_cache_hit;
>         u32 index = 0;
>

> -       return flow_lookup(tbl, ti, ma, key, &n_mask_hit, &n_cache_hit, &index);
> +       return flow_lookup(tbl, ti, ma, key, NULL, NULL, &index);

Ditto.

>  }
>
>  struct sw_flow *ovs_flow_tbl_lookup_exact(struct flow_table *tbl,
> @@ -865,7 +864,6 @@ struct sw_flow *ovs_flow_tbl_lookup_exact(struct flow_table *tbl,
>         /* Always called under ovs-mutex. */
>         for (i = 0; i < ma->max; i++) {
>                 struct table_instance *ti = rcu_dereference_ovsl(tbl->ti);
> -               u32 __always_unused n_mask_hit;
>                 struct sw_flow_mask *mask;
>                 struct sw_flow *flow;
>
> @@ -873,7 +871,7 @@ struct sw_flow *ovs_flow_tbl_lookup_exact(struct flow_table *tbl,
>                 if (!mask)
>                         continue;
>
> -               flow = masked_flow_lookup(ti, match->key, mask, &n_mask_hit);
> +               flow = masked_flow_lookup(ti, match->key, mask, NULL);
>                 if (flow && ovs_identifier_is_key(&flow->id) &&
>                     ovs_flow_cmp_unmasked_key(flow, match)) {
>                         return flow;
> --
> 2.18.1
>


-- 
With Best Regards,
Andy Shevchenko
