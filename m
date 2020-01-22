Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 313731453B7
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 12:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgAVLZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 06:25:31 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42413 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgAVLZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 06:25:30 -0500
Received: by mail-lj1-f194.google.com with SMTP id y4so6356335ljj.9
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 03:25:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cZhb/gG3SByBKtU48aR/gHOnPk8ztmr2/FXxtcrAFw0=;
        b=EdGJGWMNPQK8dBeLLZhFj4xdsrw9AsZYGNe47A6gtOPCRr2VNuzjYK4hSTq6c0QRuQ
         lsOuUN/oU7NE+ua23ZxuafcG/E4FPcCe7Ksa+ZHWdvotRDtj7LOfeKohAt6RTZRZQyvd
         xgrT7P4JA2eEEKVYFM/v23iP2iyBJDfDN1HHm2mMlrwG3NZGVT5zSd56KdteYdFVHvcj
         j+tifxe3J8M96VkGLBXn+WIwl7JrPzl/3QJ6Wk2oeDs6mbyv1+O+zxS4RfwxWqiJAQXb
         7bsOFtROIoWFTy4Nbdqqw4sJ0mlXwjMQtO98oXqRGs76mI+MmMpA5zzG0jmPESDHChD/
         Rt0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cZhb/gG3SByBKtU48aR/gHOnPk8ztmr2/FXxtcrAFw0=;
        b=ikpxy7zWDxVN2MSDeuam9OQeRCAZJZGwzpqIGjkluCLLgp4x579c84t44Q4DgRKuvi
         bd79o1/2TUJjJ9XAhMoEVVeSVSPynIupoQ7USACulOMslQFtvC27+fy4jc7A6OODel5J
         sghqBIN/Edev4qEdbuYP/RqMaplgGslCAXvFfkilRT8IUieUr9yGV/c6YeliopwY59F6
         dd9tFoogD2oYIwH8W316vu+m5FySYfWsRTRl5kHP9OtkN3/RyFhcKWkpZEgToH5NqZeX
         gd8Na+jDOPXfZd4B/Q94zqwXLy778aSg3/q63Hqfq4xLOXxI2Z0wSEqlq1VT0WJ8eNLf
         /esw==
X-Gm-Message-State: APjAAAUyZz0gVs5MgOYupUZhhIgikNZgy9a18xbx3IgF2QtUfoXu/6lI
        eoozaGZi+j2nlplZa3voR6SeDI50lJTUViyUTZ0=
X-Google-Smtp-Source: APXvYqwg4L5JNJJQm4kqox7eNtqFcoe2FeW1Q8fCp7KEqnAIy+R4JaiWIP71eUeIIgryRt1FSbk05xlH2vGDXCYZPdo=
X-Received: by 2002:a2e:924d:: with SMTP id v13mr19158913ljg.267.1579692328047;
 Wed, 22 Jan 2020 03:25:28 -0800 (PST)
MIME-Version: 1.0
References: <1579400705-22118-1-git-send-email-xiangxia.m.yue@gmail.com> <73d77bc7-6a1b-44de-a45f-967bbda68894@mellanox.com>
In-Reply-To: <73d77bc7-6a1b-44de-a45f-967bbda68894@mellanox.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Wed, 22 Jan 2020 19:24:51 +0800
Message-ID: <CAMDZJNXrZzkQaEBWBO4j3=0-LA1ExGaKa0+0Whg0R8NugbkLTw@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net/mlx5e: Don't allow forwarding between uplink
To:     Roi Dayan <roid@mellanox.com>
Cc:     "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>,
        "saeedm@dev.mellanox.co.il" <saeedm@dev.mellanox.co.il>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 5:39 PM Roi Dayan <roid@mellanox.com> wrote:
>
>
>
> On 2020-01-19 4:25 AM, xiangxia.m.yue@gmail.com wrote:
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > We can install forwarding packets rule between uplink
> > in switchdev mode, as show below. But the hardware does
> > not do that as expected (mlnx_perf -i $PF1, we can't get
> > the counter of the PF1). By the way, if we add the uplink
> > PF0, PF1 to Open vSwitch and enable hw-offload, the rules
> > can be offloaded but not work fine too. This patch add a
> > check and if so return -EOPNOTSUPP.
> >
> > $ tc filter add dev $PF0 protocol all parent ffff: prio 1 handle 1 \
> >       flower skip_sw action mirred egress redirect dev $PF1
> >
> > $ tc -d -s filter show dev $PF0 ingress
> >       skip_sw
> >       in_hw in_hw_count 1
> >       action order 1: mirred (Egress Redirect to device enp130s0f1) stolen
> >       ...
> >       Sent 408954 bytes 4173 pkt (dropped 0, overlimits 0 requeues 0)
> >       Sent hardware 408954 bytes 4173 pkt
> >       ...
> >
> > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > ---
> > v2: don't break LAG case
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c |  5 +++++
> >  drivers/net/ethernet/mellanox/mlx5/core/en_rep.h |  1 +
> >  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c  | 23 ++++++++++++++++++++---
> >  3 files changed, 26 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> > index f175cb2..ac2a035 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> > @@ -1434,6 +1434,11 @@ static struct devlink_port *mlx5e_get_devlink_port(struct net_device *dev)
> >       .ndo_set_features        = mlx5e_set_features,
> >  };
> >
> > +bool mlx5e_eswitch_uplink_rep(struct net_device *netdev)
> > +{
> > +     return netdev->netdev_ops == &mlx5e_netdev_ops_uplink_rep;
> > +}
> > +
> >  bool mlx5e_eswitch_rep(struct net_device *netdev)
> >  {
> >       if (netdev->netdev_ops == &mlx5e_netdev_ops_rep ||
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
> > index 31f83c8..5211819 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
> > @@ -199,6 +199,7 @@ void mlx5e_rep_encap_entry_detach(struct mlx5e_priv *priv,
> >  void mlx5e_rep_queue_neigh_stats_work(struct mlx5e_priv *priv);
> >
> >  bool mlx5e_eswitch_rep(struct net_device *netdev);
> > +bool mlx5e_eswitch_uplink_rep(struct net_device *netdev);
> >
> >  #else /* CONFIG_MLX5_ESWITCH */
> >  static inline bool mlx5e_is_uplink_rep(struct mlx5e_priv *priv) { return false; }
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > index db614bd..28f4522 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > @@ -3242,6 +3242,10 @@ static int add_vlan_pop_action(struct mlx5e_priv *priv,
> >  bool mlx5e_is_valid_eswitch_fwd_dev(struct mlx5e_priv *priv,
> >                                   struct net_device *out_dev)
> >  {
> > +     if (mlx5e_eswitch_uplink_rep(priv->netdev) &&
> > +         mlx5e_eswitch_uplink_rep(out_dev))
> > +             return false;
> > +
> >       if (is_merged_eswitch_dev(priv, out_dev))
> >               return true;
> >
> > @@ -3361,6 +3365,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
> >                               struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
> >                               struct net_device *uplink_dev = mlx5_eswitch_uplink_get_proto_dev(esw, REP_ETH);
> >                               struct net_device *uplink_upper;
> > +                             struct mlx5e_rep_priv *rep_priv;
> >
> >                               if (is_duplicated_output_device(priv->netdev,
> >                                                               out_dev,
> > @@ -3396,10 +3401,22 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
> >                                               return err;
> >                               }
> >
> > -                             if (!mlx5e_is_valid_eswitch_fwd_dev(priv, out_dev)) {
> > +                             /* Input vport was stored esw_attr->in_rep.
> > +                              * In LAG case, *priv* is the private data of
> > +                              * uplink which may be not the input vport.
> > +                              * Use the input vport to check forwarding
> > +                              * validity.
> > +                              */
> > +                             rep_priv = mlx5e_rep_to_rep_priv(attr->in_rep);
> > +                             if (!mlx5e_is_valid_eswitch_fwd_dev(netdev_priv(rep_priv->netdev),
> > +                                                                 out_dev)) {
> >                                       NL_SET_ERR_MSG_MOD(extack,
> > -                                                        "devices are not on same switch HW, can't offload forwarding");
> > -                                     pr_err("devices %s %s not on same switch HW, can't offload forwarding\n",
> > +                                                        "devices are both uplink "
> > +                                                        "are not on same switch HW, "
> > +                                                        "can't offload forwarding");
> > +                                     pr_err("devices %s %s are both uplink "
> > +                                            "not on same switch HW, "
> > +                                            "can't offload forwarding\n",
> >                                              priv->netdev->name, out_dev->name);
>
> can you fix the netlink msg to be the same as printk
> the netlink msg iss "are both uplink are not on"
> the printk msg is "are both uplink not on"
>
> >                                       return -EOPNOTSUPP;
> >                               }
> >
>
>
> I noticed you still modified mlx5e_is_valid_eswitch_fwd_dev() which
> is called from parse tc actions and also from resolving route for vxlan rules.
>
> I tested the patch for normal, lag and ecmp modes.
> ecmp vxlan encap rule breaks now as not supported.
> the break is in get_route_and_out_devs() at this part
>
> else if (mlx5e_eswitch_rep(dev) &&
>                  mlx5e_is_valid_eswitch_fwd_dev(priv, dev))
>
> since ecmp is like lag we fail on the same scenario here that
> we test uplink priv but not input vport.
>
> to activate ecmp we change both ports to switchdev mode
> and add a multipath route rule.
> you can see my test here
> https://github.com/roidayan/ovs-tests/blob/master/test-ecmp-add-vxlan-rule.sh
I sent v3 again, and thanks for your review.
I'll be taking my holidays soon. And I can't reply to you immediately.
