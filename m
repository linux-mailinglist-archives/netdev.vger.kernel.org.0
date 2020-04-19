Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C001AFCCE
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 19:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbgDSRbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 13:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725969AbgDSRbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 13:31:01 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD75C061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 10:31:01 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id n26so1011996uap.11
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 10:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cTlrT1AZ5TO2A0iVMUTHb8HrUwpakbS5yueKYOUGINA=;
        b=UOC25IQlKWvAK04rkPlRyUCrXFet0ixg4NNdbrHq0rMCVkVhovHWZRVcdJBVSmitPz
         nwsc1sP3zX+UMUCgNnVpNrusbN1ULjDdxRq25o2EEU1vWNQU6Gsh4US89mUq2uXbX95r
         Z84PmTzCeoxAyf55Hyjy+MPpYgQfaSXi9P0G2afoTTLGR5IzLMYAnvnaUbS53okqe0Wy
         sujPt+vK5GkpF0IbJJqFWc4/cMdHTELD5XdpJiyxp/e7zQpBAy9n4ZMd6Pdp7KtdFGdC
         sxumMZ7o0YNx+8JBQxv77aZbkTWFiG1A5Ogu9ZyJKgOm/rF0z7YwjE23zuDJtYfcuwFy
         gv+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cTlrT1AZ5TO2A0iVMUTHb8HrUwpakbS5yueKYOUGINA=;
        b=TlRORyHsRABW7ODQ0xc9F8j5Hcepf79Ns0FqyK3UwF8CRR15UK96jkPGqtrEExoQK9
         Rjbf5rm+X+bvuZc8osZxxAKiMUqw6DLQueVqPq73MDiYDD5wEcjXVKI3iR4jWvRhx5UK
         DEGX4wMy1d9dPxkiU8pQ9T+dBW/IgQUahttgV5uFpcHNa/y4f6HYoHhWkhsRedlnM9cM
         ZWpLUWegodvY3v8LpdQdWqCDSbbF6f9JZe36daW9Sh0+s+Ezv1UqlklZ2nWlZLRcpBW7
         S+xjt4R6qiB1lwBciF4finiYM8N7QGnxsRkqxdzo1ToUamaF6bDw7h7XcvR+J2jNF12Q
         4coA==
X-Gm-Message-State: AGi0PuYeVWqE+iL47fr93k83o88ZHg/tD9ijRHM9odeHP4UgoDLuIOBl
        /glvWDjdUC9MfZ8859rZyI/x9C2u7wWTlSQe8J0=
X-Google-Smtp-Source: APiQypIfIj8rRdpY5Qch+dfMbNRg2co7FWWuaeKTrLBO+M5IwQ9kt7VuszcAWTO8KVlk2oyAMR4Jlplna4ITkum8DYA=
X-Received: by 2002:ab0:770b:: with SMTP id z11mr2869663uaq.64.1587317460474;
 Sun, 19 Apr 2020 10:31:00 -0700 (PDT)
MIME-Version: 1.0
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1587032223-49460-1-git-send-email-xiangxia.m.yue@gmail.com> <1587032223-49460-3-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1587032223-49460-3-git-send-email-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Sun, 19 Apr 2020 10:30:49 -0700
Message-ID: <CAOrHB_D1OQujNyw9StmHRknDQZywHB02z8berxm+aPUNgQhYnA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/5] net: openvswitch: set max limitation to meters
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Andy Zhou <azhou@ovn.org>, Ben Pfaff <blp@ovn.org>,
        William Tu <u9012063@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 18, 2020 at 10:25 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> Don't allow user to create meter unlimitedly,
> which may cause to consume a large amount of kernel memory.
> The 200,000 meters may be fine in general case.
>
> Cc: Pravin B Shelar <pshelar@ovn.org>
> Cc: Andy Zhou <azhou@ovn.org>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  net/openvswitch/meter.c | 21 +++++++++++++++------
>  net/openvswitch/meter.h |  1 +
>  2 files changed, 16 insertions(+), 6 deletions(-)
>
> diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
> index 494a0014ecd8..1b6776f9c109 100644
> --- a/net/openvswitch/meter.c
> +++ b/net/openvswitch/meter.c
> @@ -137,6 +137,7 @@ static int attach_meter(struct dp_meter_table *tbl, struct dp_meter *meter)
>  {
>         struct dp_meter_instance *ti = rcu_dereference_ovsl(tbl->ti);
>         u32 hash = meter_hash(ti, meter->id);
> +       int err;
>
>         /*
>          * In generally, slot selected should be empty, because
> @@ -148,16 +149,24 @@ static int attach_meter(struct dp_meter_table *tbl, struct dp_meter *meter)
>         dp_meter_instance_insert(ti, meter);
>
>         /* That function is thread-safe. */
> -       if (++tbl->count >= ti->n_meters)
> -               if (dp_meter_instance_realloc(tbl, ti->n_meters * 2))
> -                       goto expand_err;
> +       tbl->count++;
> +       if (tbl->count > DP_METER_NUM_MAX) {
> +               err = -EFBIG;
> +               goto attach_err;
> +       }
> +
> +       if (tbl->count >= ti->n_meters &&
> +           dp_meter_instance_realloc(tbl, ti->n_meters * 2)) {
> +               err = -ENOMEM;
> +               goto attach_err;
> +       }
>
>         return 0;
>
> -expand_err:
> +attach_err:
>         dp_meter_instance_remove(ti, meter);
>         tbl->count--;
> -       return -ENOMEM;
> +       return err;
>  }
>
>  static void detach_meter(struct dp_meter_table *tbl, struct dp_meter *meter)
> @@ -264,7 +273,7 @@ static int ovs_meter_cmd_features(struct sk_buff *skb, struct genl_info *info)
>         if (IS_ERR(reply))
>                 return PTR_ERR(reply);
>
> -       if (nla_put_u32(reply, OVS_METER_ATTR_MAX_METERS, U32_MAX) ||
> +       if (nla_put_u32(reply, OVS_METER_ATTR_MAX_METERS, DP_METER_NUM_MAX) ||
>             nla_put_u32(reply, OVS_METER_ATTR_MAX_BANDS, DP_MAX_BANDS))
>                 goto nla_put_failure;
>
> diff --git a/net/openvswitch/meter.h b/net/openvswitch/meter.h
> index d91940383bbe..cdfc6b9dbd42 100644
> --- a/net/openvswitch/meter.h
> +++ b/net/openvswitch/meter.h
> @@ -19,6 +19,7 @@ struct datapath;
>
>  #define DP_MAX_BANDS           1
>  #define DP_METER_ARRAY_SIZE_MIN        (1ULL << 10)
> +#define DP_METER_NUM_MAX       (200000ULL)
>
Lets make it configurable and default could 200k to allow
customization on different memory configurations.


>  struct dp_meter_band {
>         u32 type;
> --
> 2.23.0
>
