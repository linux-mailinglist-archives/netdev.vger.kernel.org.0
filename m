Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 430ED20E0E5
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731425AbgF2Uup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731436AbgF2TNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:13:34 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BE5C08EB41;
        Sun, 28 Jun 2020 23:42:17 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id ga4so15354642ejb.11;
        Sun, 28 Jun 2020 23:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PuBNArcvvl+lYaMjjB23oqTZzdShoohIwup/K/q77Kk=;
        b=scjDLt0eneyMPsM8Cpw3mmqW1vBT5O4LJQ55cH0yENAAoLolY12rHmsnveH3hq8bf4
         XaInXDN3sAkUSZSbvzA3be+rxIWi9PpcIZw9Lnexstw+C1LYpxoZOEA6jEsuKLA++h7W
         c/efkRcGGUKxyssChcRHA48FXWZCAiWUgtqpb66UtWM2nYsdM7lAl6ANVcb9CK0YG3gl
         nkuWL334yaarpudNqhyxsNnvKHXLdc9Y2SZ/PTqgGmTiqwlT4uZ+fJaBkwl1eF3o08En
         6geDurFGHR9IrsQJkb65VSzLMNJPVCbO8+Oe/8SgDHrLeCbK+AguCiTpEgnHv6ZOYLj2
         TTtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PuBNArcvvl+lYaMjjB23oqTZzdShoohIwup/K/q77Kk=;
        b=Nz3Cui7M2kRAt1t7jvqMw4rw/LD3NRaMEYAsupyoQi66m4Vls5K+uLk3fVJN7kkfaS
         oOsIwyJbnZ57kJdSomx7ZtvE/RoM3nyCHgNMcA5CzEofwSr21mlOtUHw24DFuyKqN+NO
         I/rgNxJLizjQQwoyoKs+UFUHVYhsaHQUdq4x/QqOoLi8ygzv7uKCG1IL1/khgohnaN6S
         6nIl80zpeHlLVnwe08ksQgKYc1EYfGAyPEnWUTNN6n1rP+yADjA0rZ4J3WSvUhFUDOb7
         qoSANC5tPt3KSqpNWdQe82RZBxG19zu+0t4FPb4INI0XdDGYoov1n7oV8iENka10pGCa
         mEhw==
X-Gm-Message-State: AOAM5331Jl5oRGrFGxQODi4Acng/XAyUDrSwu0QCbMWYSexROk0lgIK5
        Enz0UUzSVjmccOmJ0GjDest1xBbC7Sq0H3urSyY=
X-Google-Smtp-Source: ABdhPJxF4IOzeC+gw3Xw9uUtobxLZqdWQ97Wn3+hW4leDjYQ9P/0VxnD/ExFHb04Dfc9jZlbPU5jWJSVlFezgQcHhM8=
X-Received: by 2002:a17:906:492:: with SMTP id f18mr12561941eja.279.1593412935855;
 Sun, 28 Jun 2020 23:42:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200629022500.30527-1-po.liu@nxp.com>
In-Reply-To: <20200629022500.30527-1-po.liu@nxp.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 29 Jun 2020 09:42:04 +0300
Message-ID: <CA+h21hqTSrmA8Q0hrJrQ23Qa-kwYjMqxH_mnVFcxPJruQJGqiA@mail.gmail.com>
Subject: Re: [v1,net-next] net:qos: police action offloading parameter 'burst'
 change to the original value
To:     Po Liu <po.liu@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, vlad@buslov.dev,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        michael.chan@broadcom.com, vishal@chelsio.com, saeedm@mellanox.com,
        leon@kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        simon.horman@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Po,

On Mon, 29 Jun 2020 at 05:25, Po Liu <po.liu@nxp.com> wrote:
>
> Since 'tcfp_burst' with TICK factor, driver side always need to recover
> it to the original value, this patch moves the generic calculation and
> recover to the 'burst' original value before offloading to device driver.
>
> Signed-off-by: Po Liu <po.liu@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Just one small comment:
I think the use of my "Signed-off-by" tag here is incorrect. Typically
the first Signed-off-by tag corresponds to the patch author (and that
one is correct) and further ones correspond to the other people who
picked up this patch and submitted it to a tree. So, my Signed-off-by
in the second position would indicate that I took your patch and
submitted it to netdev, which I didn't do.
I think the Acked-by and Tested-by tags would have been more appropriate.

https://www.kernel.org/doc/html/latest/process/5.Posting.html#patch-formatting-and-changelogs

>  drivers/net/dsa/ocelot/felix.c                |  4 +--
>  drivers/net/dsa/sja1105/sja1105_flower.c      | 16 ++++------
>  drivers/net/dsa/sja1105/sja1105_main.c        |  4 +--
>  .../net/ethernet/freescale/enetc/enetc_qos.c  |  8 +----
>  drivers/net/ethernet/mscc/ocelot_flower.c     |  4 +--
>  drivers/net/ethernet/mscc/ocelot_net.c        |  4 +--
>  .../ethernet/netronome/nfp/flower/qos_conf.c  |  6 ++--
>  include/net/dsa.h                             |  2 +-
>  include/net/flow_offload.h                    |  2 +-
>  include/net/tc_act/tc_police.h                | 32 +++++++++++++++++--
>  net/sched/cls_api.c                           |  2 +-
>  11 files changed, 48 insertions(+), 36 deletions(-)
>
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> index 25046777c993..75020af7f7a4 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -746,9 +746,7 @@ static int felix_port_policer_add(struct dsa_switch *ds, int port,
>         struct ocelot *ocelot = ds->priv;
>         struct ocelot_policer pol = {
>                 .rate = div_u64(policer->rate_bytes_per_sec, 1000) * 8,
> -               .burst = div_u64(policer->rate_bytes_per_sec *
> -                                PSCHED_NS2TICKS(policer->burst),
> -                                PSCHED_TICKS_PER_SEC),
> +               .burst = policer->burst,
>         };
>
>         return ocelot_port_policer_add(ocelot, port, &pol);
> diff --git a/drivers/net/dsa/sja1105/sja1105_flower.c b/drivers/net/dsa/sja1105/sja1105_flower.c
> index 9ee8968610cd..12e76020bea3 100644
> --- a/drivers/net/dsa/sja1105/sja1105_flower.c
> +++ b/drivers/net/dsa/sja1105/sja1105_flower.c
> @@ -31,7 +31,7 @@ static int sja1105_setup_bcast_policer(struct sja1105_private *priv,
>                                        struct netlink_ext_ack *extack,
>                                        unsigned long cookie, int port,
>                                        u64 rate_bytes_per_sec,
> -                                      s64 burst)
> +                                      u32 burst)
>  {
>         struct sja1105_rule *rule = sja1105_rule_find(priv, cookie);
>         struct sja1105_l2_policing_entry *policing;
> @@ -79,9 +79,8 @@ static int sja1105_setup_bcast_policer(struct sja1105_private *priv,
>
>         policing[rule->bcast_pol.sharindx].rate = div_u64(rate_bytes_per_sec *
>                                                           512, 1000000);
> -       policing[rule->bcast_pol.sharindx].smax = div_u64(rate_bytes_per_sec *
> -                                                         PSCHED_NS2TICKS(burst),
> -                                                         PSCHED_TICKS_PER_SEC);
> +       policing[rule->bcast_pol.sharindx].smax = burst;
> +
>         /* TODO: support per-flow MTU */
>         policing[rule->bcast_pol.sharindx].maxlen = VLAN_ETH_FRAME_LEN +
>                                                     ETH_FCS_LEN;
> @@ -103,7 +102,7 @@ static int sja1105_setup_tc_policer(struct sja1105_private *priv,
>                                     struct netlink_ext_ack *extack,
>                                     unsigned long cookie, int port, int tc,
>                                     u64 rate_bytes_per_sec,
> -                                   s64 burst)
> +                                   u32 burst)
>  {
>         struct sja1105_rule *rule = sja1105_rule_find(priv, cookie);
>         struct sja1105_l2_policing_entry *policing;
> @@ -152,9 +151,8 @@ static int sja1105_setup_tc_policer(struct sja1105_private *priv,
>
>         policing[rule->tc_pol.sharindx].rate = div_u64(rate_bytes_per_sec *
>                                                        512, 1000000);
> -       policing[rule->tc_pol.sharindx].smax = div_u64(rate_bytes_per_sec *
> -                                                      PSCHED_NS2TICKS(burst),
> -                                                      PSCHED_TICKS_PER_SEC);
> +       policing[rule->tc_pol.sharindx].smax = burst;
> +
>         /* TODO: support per-flow MTU */
>         policing[rule->tc_pol.sharindx].maxlen = VLAN_ETH_FRAME_LEN +
>                                                  ETH_FCS_LEN;
> @@ -177,7 +175,7 @@ static int sja1105_flower_policer(struct sja1105_private *priv, int port,
>                                   unsigned long cookie,
>                                   struct sja1105_key *key,
>                                   u64 rate_bytes_per_sec,
> -                                 s64 burst)
> +                                 u32 burst)
>  {
>         switch (key->type) {
>         case SJA1105_KEY_BCAST:
> diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
> index 789b288cc78b..5079e4aeef80 100644
> --- a/drivers/net/dsa/sja1105/sja1105_main.c
> +++ b/drivers/net/dsa/sja1105/sja1105_main.c
> @@ -3324,9 +3324,7 @@ static int sja1105_port_policer_add(struct dsa_switch *ds, int port,
>          */
>         policing[port].rate = div_u64(512 * policer->rate_bytes_per_sec,
>                                       1000000);
> -       policing[port].smax = div_u64(policer->rate_bytes_per_sec *
> -                                     PSCHED_NS2TICKS(policer->burst),
> -                                     PSCHED_TICKS_PER_SEC);
> +       policing[port].smax = policer->burst;
>
>         return sja1105_static_config_reload(priv, SJA1105_BEST_EFFORT_POLICING);
>  }
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
> index 4f670cbdf186..b8b336179d82 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
> @@ -1241,8 +1241,6 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
>         /* Flow meter and max frame size */
>         if (entryp) {
>                 if (entryp->police.burst) {
> -                       u64 temp;
> -
>                         fmi = kzalloc(sizeof(*fmi), GFP_KERNEL);
>                         if (!fmi) {
>                                 err = -ENOMEM;
> @@ -1250,11 +1248,7 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
>                         }
>                         refcount_set(&fmi->refcount, 1);
>                         fmi->cir = entryp->police.rate_bytes_ps;
> -                       /* Convert to original burst value */
> -                       temp = entryp->police.burst * fmi->cir;
> -                       temp = div_u64(temp, 1000000000ULL);
> -
> -                       fmi->cbs = temp;
> +                       fmi->cbs = entryp->police.burst;
>                         fmi->index = entryp->police.index;
>                         filter->flags |= ENETC_PSFP_FLAGS_FMI;
>                         filter->fmi_index = fmi->index;
> diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
> index f2a85b06a6e7..ec1b6e2572ba 100644
> --- a/drivers/net/ethernet/mscc/ocelot_flower.c
> +++ b/drivers/net/ethernet/mscc/ocelot_flower.c
> @@ -12,7 +12,6 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
>                                       struct ocelot_vcap_filter *filter)
>  {
>         const struct flow_action_entry *a;
> -       s64 burst;
>         u64 rate;
>         int i;
>
> @@ -35,8 +34,7 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
>                         filter->action = OCELOT_VCAP_ACTION_POLICE;
>                         rate = a->police.rate_bytes_ps;
>                         filter->pol.rate = div_u64(rate, 1000) * 8;
> -                       burst = rate * PSCHED_NS2TICKS(a->police.burst);
> -                       filter->pol.burst = div_u64(burst, PSCHED_TICKS_PER_SEC);
> +                       filter->pol.burst = a->police.burst;
>                         break;
>                 default:
>                         return -EOPNOTSUPP;
> diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
> index 702b42543fb7..b69187c51fa6 100644
> --- a/drivers/net/ethernet/mscc/ocelot_net.c
> +++ b/drivers/net/ethernet/mscc/ocelot_net.c
> @@ -74,9 +74,7 @@ static int ocelot_setup_tc_cls_matchall(struct ocelot_port_private *priv,
>                 }
>
>                 pol.rate = (u32)div_u64(action->police.rate_bytes_ps, 1000) * 8;
> -               pol.burst = (u32)div_u64(action->police.rate_bytes_ps *
> -                                        PSCHED_NS2TICKS(action->police.burst),
> -                                        PSCHED_TICKS_PER_SEC);
> +               pol.burst = action->police.burst;
>
>                 err = ocelot_port_policer_add(ocelot, port, &pol);
>                 if (err) {
> diff --git a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
> index bb327d48d1ab..d4ce8f9ef3cc 100644
> --- a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
> +++ b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
> @@ -69,7 +69,8 @@ nfp_flower_install_rate_limiter(struct nfp_app *app, struct net_device *netdev,
>         struct nfp_repr *repr;
>         struct sk_buff *skb;
>         u32 netdev_port_id;
> -       u64 burst, rate;
> +       u32 burst;
> +       u64 rate;
>
>         if (!nfp_netdev_is_nfp_repr(netdev)) {
>                 NL_SET_ERR_MSG_MOD(extack, "unsupported offload: qos rate limit offload not supported on higher level port");
> @@ -104,8 +105,7 @@ nfp_flower_install_rate_limiter(struct nfp_app *app, struct net_device *netdev,
>         }
>
>         rate = action->police.rate_bytes_ps;
> -       burst = div_u64(rate * PSCHED_NS2TICKS(action->police.burst),
> -                       PSCHED_TICKS_PER_SEC);
> +       burst = action->police.burst;
>         netdev_port_id = nfp_repr_get_port_id(netdev);
>
>         skb = nfp_flower_cmsg_alloc(repr->app, sizeof(struct nfp_police_config),
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 50389772c597..4046ccd1945d 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -144,7 +144,7 @@ struct dsa_mall_mirror_tc_entry {
>
>  /* TC port policer entry */
>  struct dsa_mall_policer_tc_entry {
> -       s64 burst;
> +       u32 burst;
>         u64 rate_bytes_per_sec;
>  };
>
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index 3bafb5124ac0..2dc25082eabf 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -233,7 +233,7 @@ struct flow_action_entry {
>                 } sample;
>                 struct {                                /* FLOW_ACTION_POLICE */
>                         u32                     index;
> -                       s64                     burst;
> +                       u32                     burst;
>                         u64                     rate_bytes_ps;
>                         u32                     mtu;
>                 } police;
> diff --git a/include/net/tc_act/tc_police.h b/include/net/tc_act/tc_police.h
> index cd973b10ae8c..6d1e26b709b5 100644
> --- a/include/net/tc_act/tc_police.h
> +++ b/include/net/tc_act/tc_police.h
> @@ -59,14 +59,42 @@ static inline u64 tcf_police_rate_bytes_ps(const struct tc_action *act)
>         return params->rate.rate_bytes_ps;
>  }
>
> -static inline s64 tcf_police_tcfp_burst(const struct tc_action *act)
> +static inline u32 tcf_police_burst(const struct tc_action *act)
>  {
>         struct tcf_police *police = to_police(act);
>         struct tcf_police_params *params;
> +       u32 burst;
>
>         params = rcu_dereference_protected(police->params,
>                                            lockdep_is_held(&police->tcf_lock));
> -       return params->tcfp_burst;
> +
> +       /*
> +        *  "rate" bytes   "burst" nanoseconds
> +        *  ------------ * -------------------
> +        *    1 second          2^6 ticks
> +        *
> +        * ------------------------------------
> +        *        NSEC_PER_SEC nanoseconds
> +        *        ------------------------
> +        *              2^6 ticks
> +        *
> +        *    "rate" bytes   "burst" nanoseconds            2^6 ticks
> +        *  = ------------ * ------------------- * ------------------------
> +        *      1 second          2^6 ticks        NSEC_PER_SEC nanoseconds
> +        *
> +        *   "rate" * "burst"
> +        * = ---------------- bytes/nanosecond
> +        *    NSEC_PER_SEC^2
> +        *
> +        *
> +        *   "rate" * "burst"
> +        * = ---------------- bytes/second
> +        *     NSEC_PER_SEC
> +        */
> +       burst = div_u64(params->tcfp_burst * params->rate.rate_bytes_ps,
> +                       NSEC_PER_SEC);
> +
> +       return burst;
>  }
>
>  static inline u32 tcf_police_tcfp_mtu(const struct tc_action *act)
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 5bfa6b985bb8..cf324807fc42 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -3660,7 +3660,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
>                         tcf_sample_get_group(entry, act);
>                 } else if (is_tcf_police(act)) {
>                         entry->id = FLOW_ACTION_POLICE;
> -                       entry->police.burst = tcf_police_tcfp_burst(act);
> +                       entry->police.burst = tcf_police_burst(act);
>                         entry->police.rate_bytes_ps =
>                                 tcf_police_rate_bytes_ps(act);
>                         entry->police.mtu = tcf_police_tcfp_mtu(act);
> --
> 2.17.1
>

Thanks,
-Vladimir
