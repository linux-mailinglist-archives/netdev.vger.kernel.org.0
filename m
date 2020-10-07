Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A06285F56
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 14:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgJGMlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 08:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727253AbgJGMle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 08:41:34 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DBF0C061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 05:41:34 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id r127so2080915lff.12
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 05:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OXQa9YWA7KjK4KA6hRxoW6CMSfxwR2KTg0k3LCuNwsY=;
        b=dpcregHntw0pnbJtfuqj+cIf2gYdH5RfgyB6Cy1vSUcmlsVuDvCAfXbvsWJPze/y4w
         aSxTCiLDyZsh0gqdCVPP0viSWNVLLflDjzBEZN8hiJHete14krAkHpiOm50KDK79lC4H
         mE742m1YJqjGskDmqD9k3OjeZEluLdrYWi0Zc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OXQa9YWA7KjK4KA6hRxoW6CMSfxwR2KTg0k3LCuNwsY=;
        b=FVMiAzl1pCBG1t0n8C5NleEL3WIGh5W0sFe8SJNuF0jvj8LBUUmQ+iXQ1WsSJVvMF3
         2bcrKDO5yUfTU/7vjtr57JRjkooQ4Im9fCVYfJ23R7/x0iLNLsRgRmCqI4bPbJRfq6Ni
         /miDt9Sh79NKhWMO+BiziaV2qXfdy1dhL37YDKQhkScusn4vRXvWhTr/Rr7smr8joFiz
         qulB81O5CzjOlOXEJCYo1KYyXCGjVQqLgSP5yt2vtTnjkiJ8flvjmYaa4BJO25bl+e8P
         KaKLVwmJMjLIMdGD4EY+eB9U0ajIAM4NuC5Eq9raGoaMhy1M9gKyKGuymbgcOOBusKy5
         pLHw==
X-Gm-Message-State: AOAM531UyOONeZwKi10WY0dEI0xJdam4MOuVMW63aiHDoJ1WYoujnO9A
        6Gs/1CjaXlX85CQCcEScY8CMKvLGVdFM5JqgDopAjw==
X-Google-Smtp-Source: ABdhPJySDDtNfGxdO2u68LKI6rEmOejAcgUT/ZC6nqMcm0esP4C74VDdpxIX6/87C3Vb1fSh0LbQ14OF65OKE7JbLzM=
X-Received: by 2002:ac2:55a5:: with SMTP id y5mr1033028lfg.473.1602074492183;
 Wed, 07 Oct 2020 05:41:32 -0700 (PDT)
MIME-Version: 1.0
References: <1602050457-21700-1-git-send-email-moshe@mellanox.com> <1602050457-21700-4-git-send-email-moshe@mellanox.com>
In-Reply-To: <1602050457-21700-4-git-send-email-moshe@mellanox.com>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Wed, 7 Oct 2020 18:11:21 +0530
Message-ID: <CAACQVJo6soxxy-xMF0pWtBFBTqkipp7Yri1XJJUiwnBo-_yJDg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 03/16] devlink: Add devlink reload limit option
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000000d765705b114095c"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000000d765705b114095c
Content-Type: text/plain; charset="UTF-8"

On Wed, Oct 7, 2020 at 11:32 AM Moshe Shemesh <moshe@mellanox.com> wrote:
>
> Add reload limit to demand restrictions on reload actions.
> Reload limits supported:
> no_reset: No reset allowed, no down time allowed, no link flap and no
>           configuration is lost.
>
> By default reload limit is unspecified and so no constraints on reload
> actions are required.
>
> Some combinations of action and limit are invalid. For example, driver
> can not reinitialize its entities without any downtime.
>
> The no_reset reload limit will have usecase in this patchset to
> implement restricted fw_activate on mlx5.
>
> Have the uapi parameter of reload limit ready for future support of
> multiselection.
>
> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
> ---
> v1 -> v2:
> - Changed limit uapi parameter to bitfield32 for future support of
>   multiselection
> - Fixed reverse xmas tree
> RFCv5 -> v1:
> - Renamed supported_reload_actions_limit_levels to reload_limits
> - Renamed reload_action_limit_level to reload_limit
> - Change RELOAD_LIMIT_NONE to unspecified RELOAD_LIMIT_UNSPEC,
>   drivers don't need to declare support limits if they support only
>   no limitation
> - Use nla_poilcy range validation and remove the range check in
> devlink_nl_cmd_reload
> RFCv4 -> RFCv5:
> - Remove check DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX
> - Added list of invalid action-limit_level combinations and add check to
>   supported actions and levels and check user request
> RFCv3 -> RFCv4:
> - New patch
> ---
>  drivers/net/ethernet/mellanox/mlx4/main.c     |  4 +-
>  .../net/ethernet/mellanox/mlx5/core/devlink.c |  4 +-
>  drivers/net/ethernet/mellanox/mlxsw/core.c    |  4 +-
>  drivers/net/netdevsim/dev.c                   |  6 +-
>  include/net/devlink.h                         |  8 +-
>  include/uapi/linux/devlink.h                  | 14 +++
>  net/core/devlink.c                            | 92 +++++++++++++++++--
>  7 files changed, 119 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
> index 649c5323cf9f..c326b434734e 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/main.c
> @@ -3947,6 +3947,7 @@ static int mlx4_restart_one_up(struct pci_dev *pdev, bool reload,
>
>  static int mlx4_devlink_reload_down(struct devlink *devlink, bool netns_change,
>                                     enum devlink_reload_action action,
> +                                   enum devlink_reload_limit limit,
>                                     struct netlink_ext_ack *extack)
>  {
>         struct mlx4_priv *priv = devlink_priv(devlink);
I don't see any check for limit. If users provide a limit that is not
supported by the driver, it seems to be simply ignored. Is it checked
somewhere else?


> @@ -3964,7 +3965,8 @@ static int mlx4_devlink_reload_down(struct devlink *devlink, bool netns_change,
>  }
>
>  static int mlx4_devlink_reload_up(struct devlink *devlink, enum devlink_reload_action action,
> -                                 u32 *actions_performed, struct netlink_ext_ack *extack)
> +                                 enum devlink_reload_limit limit, u32 *actions_performed,
> +                                 struct netlink_ext_ack *extack)
>  {
>         struct mlx4_priv *priv = devlink_priv(devlink);
>         struct mlx4_dev *dev = &priv->dev;
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> index 1b248c01a209..0016041e8779 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> @@ -86,6 +86,7 @@ mlx5_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
>
>  static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
>                                     enum devlink_reload_action action,
> +                                   enum devlink_reload_limit limit,
>                                     struct netlink_ext_ack *extack)
>  {
>         struct mlx5_core_dev *dev = devlink_priv(devlink);
> @@ -95,7 +96,8 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
>  }
>
>  static int mlx5_devlink_reload_up(struct devlink *devlink, enum devlink_reload_action action,
> -                                 u32 *actions_performed, struct netlink_ext_ack *extack)
> +                                 enum devlink_reload_limit limit, u32 *actions_performed,
> +                                 struct netlink_ext_ack *extack)
>  {
>         struct mlx5_core_dev *dev = devlink_priv(devlink);
>
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
> index cd9f56c73827..7f77c2a71d1c 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/core.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
> @@ -1415,6 +1415,7 @@ mlxsw_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
>  static int
>  mlxsw_devlink_core_bus_device_reload_down(struct devlink *devlink,
>                                           bool netns_change, enum devlink_reload_action action,
> +                                         enum devlink_reload_limit limit,
>                                           struct netlink_ext_ack *extack)
>  {
>         struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
> @@ -1428,7 +1429,8 @@ mlxsw_devlink_core_bus_device_reload_down(struct devlink *devlink,
>
>  static int
>  mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink, enum devlink_reload_action action,
> -                                       u32 *actions_performed, struct netlink_ext_ack *extack)
> +                                       enum devlink_reload_limit limit, u32 *actions_performed,
> +                                       struct netlink_ext_ack *extack)
>  {
>         struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
>
> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> index b57e35c4ef6f..d07061417675 100644
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -701,7 +701,8 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
>  static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev);
>
>  static int nsim_dev_reload_down(struct devlink *devlink, bool netns_change,
> -                               enum devlink_reload_action action, struct netlink_ext_ack *extack)
> +                               enum devlink_reload_action action, enum devlink_reload_limit limit,
> +                               struct netlink_ext_ack *extack)
>  {
>         struct nsim_dev *nsim_dev = devlink_priv(devlink);
>
> @@ -718,7 +719,8 @@ static int nsim_dev_reload_down(struct devlink *devlink, bool netns_change,
>  }
>
>  static int nsim_dev_reload_up(struct devlink *devlink, enum devlink_reload_action action,
> -                             u32 *actions_performed, struct netlink_ext_ack *extack)
> +                             enum devlink_reload_limit limit, u32 *actions_performed,
> +                             struct netlink_ext_ack *extack)
>  {
>         struct nsim_dev *nsim_dev = devlink_priv(devlink);
>
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index 93c535ae5a4b..9f5c37c391f8 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -1151,10 +1151,14 @@ struct devlink_ops {
>          */
>         u32 supported_flash_update_params;
>         unsigned long reload_actions;
> +       unsigned long reload_limits;
>         int (*reload_down)(struct devlink *devlink, bool netns_change,
> -                          enum devlink_reload_action action, struct netlink_ext_ack *extack);
> +                          enum devlink_reload_action action,
> +                          enum devlink_reload_limit limit,
> +                          struct netlink_ext_ack *extack);
>         int (*reload_up)(struct devlink *devlink, enum devlink_reload_action action,
> -                        u32 *actions_performed, struct netlink_ext_ack *extack);
> +                        enum devlink_reload_limit limit, u32 *actions_performed,
> +                        struct netlink_ext_ack *extack);
>         int (*port_type_set)(struct devlink_port *devlink_port,
>                              enum devlink_port_type port_type);
>         int (*port_split)(struct devlink *devlink, unsigned int port_index,
> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> index 74bdad252c36..a0b8e24236c0 100644
> --- a/include/uapi/linux/devlink.h
> +++ b/include/uapi/linux/devlink.h
> @@ -311,6 +311,19 @@ enum devlink_reload_action {
>         DEVLINK_RELOAD_ACTION_MAX = __DEVLINK_RELOAD_ACTION_MAX - 1
>  };
>
> +enum devlink_reload_limit {
> +       DEVLINK_RELOAD_LIMIT_UNSPEC,    /* unspecified, no constraints */
> +       DEVLINK_RELOAD_LIMIT_NO_RESET,  /* No reset allowed, no down time allowed,
> +                                        * no link flap and no configuration is lost.
> +                                        */
> +
> +       /* Add new reload limit above */
> +       __DEVLINK_RELOAD_LIMIT_MAX,
> +       DEVLINK_RELOAD_LIMIT_MAX = __DEVLINK_RELOAD_LIMIT_MAX - 1
> +};
> +
> +#define DEVLINK_RELOAD_LIMITS_VALID_MASK (BIT(__DEVLINK_RELOAD_LIMIT_MAX) - 1)
> +
>  enum devlink_attr {
>         /* don't change the order or add anything between, this is ABI! */
>         DEVLINK_ATTR_UNSPEC,
> @@ -505,6 +518,7 @@ enum devlink_attr {
>
>         DEVLINK_ATTR_RELOAD_ACTION,             /* u8 */
>         DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED,  /* bitfield32 */
> +       DEVLINK_ATTR_RELOAD_LIMITS,             /* bitfield32 */
>
>         /* add new attributes above here, update the policy in devlink.c */
>
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index c026ed3519c9..28b63faa3c6b 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -479,12 +479,44 @@ static int devlink_nl_put_handle(struct sk_buff *msg, struct devlink *devlink)
>         return 0;
>  }
>
> +struct devlink_reload_combination {
> +       enum devlink_reload_action action;
> +       enum devlink_reload_limit limit;
> +};
> +
> +static const struct devlink_reload_combination devlink_reload_invalid_combinations[] = {
> +       {
> +               /* can't reinitialize driver with no down time */
> +               .action = DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
> +               .limit = DEVLINK_RELOAD_LIMIT_NO_RESET,
> +       },
> +};
> +
> +static bool
> +devlink_reload_combination_is_invalid(enum devlink_reload_action action,
> +                                     enum devlink_reload_limit limit)
> +{
> +       int i;
> +
> +       for (i = 0; i < ARRAY_SIZE(devlink_reload_invalid_combinations); i++)
> +               if (devlink_reload_invalid_combinations[i].action == action &&
> +                   devlink_reload_invalid_combinations[i].limit == limit)
> +                       return true;
> +       return false;
> +}
> +
>  static bool
>  devlink_reload_action_is_supported(struct devlink *devlink, enum devlink_reload_action action)
>  {
>         return test_bit(action, &devlink->ops->reload_actions);
>  }
>
> +static bool
> +devlink_reload_limit_is_supported(struct devlink *devlink, enum devlink_reload_limit limit)
> +{
> +       return test_bit(limit, &devlink->ops->reload_limits);
> +}
> +
>  static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
>                            enum devlink_command cmd, u32 portid,
>                            u32 seq, int flags)
> @@ -2990,22 +3022,22 @@ bool devlink_is_reload_failed(const struct devlink *devlink)
>  EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
>
>  static int devlink_reload(struct devlink *devlink, struct net *dest_net,
> -                         enum devlink_reload_action action, u32 *actions_performed,
> -                         struct netlink_ext_ack *extack)
> +                         enum devlink_reload_action action, enum devlink_reload_limit limit,
> +                         u32 *actions_performed, struct netlink_ext_ack *extack)
>  {
>         int err;
>
>         if (!devlink->reload_enabled)
>                 return -EOPNOTSUPP;
>
> -       err = devlink->ops->reload_down(devlink, !!dest_net, action, extack);
> +       err = devlink->ops->reload_down(devlink, !!dest_net, action, limit, extack);
>         if (err)
>                 return err;
>
>         if (dest_net && !net_eq(dest_net, devlink_net(devlink)))
>                 devlink_reload_netns_change(devlink, dest_net);
>
> -       err = devlink->ops->reload_up(devlink, action, actions_performed, extack);
> +       err = devlink->ops->reload_up(devlink, action, limit, actions_performed, extack);
>         devlink_reload_failed_set(devlink, !!err);
>         if (err)
>                 return err;
> @@ -3050,6 +3082,7 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
>  {
>         struct devlink *devlink = info->user_ptr[0];
>         enum devlink_reload_action action;
> +       enum devlink_reload_limit limit;
>         struct net *dest_net = NULL;
>         u32 actions_performed;
>         int err;
> @@ -3082,7 +3115,38 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
>                 return -EOPNOTSUPP;
>         }
>
> -       err = devlink_reload(devlink, dest_net, action, &actions_performed, info->extack);
> +       limit = DEVLINK_RELOAD_LIMIT_UNSPEC;
> +       if (info->attrs[DEVLINK_ATTR_RELOAD_LIMITS]) {
> +               struct nla_bitfield32 limits;
> +               u32 limits_selected;
> +
> +               limits = nla_get_bitfield32(info->attrs[DEVLINK_ATTR_RELOAD_LIMITS]);
> +               limits_selected = limits.value & limits.selector;
> +               if (!limits_selected) {
> +                       NL_SET_ERR_MSG_MOD(info->extack, "Invalid limit selected");
> +                       return -EINVAL;
> +               }
> +               for (limit = 0 ; limit <= DEVLINK_RELOAD_LIMIT_MAX ; limit++)
> +                       if (limits_selected & BIT(limit))
> +                               break;
> +               /* UAPI enables multiselection, but currently it is not used */
> +               if (limits_selected != BIT(limit)) {
> +                       NL_SET_ERR_MSG_MOD(info->extack,
> +                                          "Multiselection of limit is not supported");
> +                       return -EOPNOTSUPP;
> +               }
> +               if (!devlink_reload_limit_is_supported(devlink, limit)) {
> +                       NL_SET_ERR_MSG_MOD(info->extack,
> +                                          "Requested limit is not supported by the driver");
> +                       return -EOPNOTSUPP;
> +               }
> +               if (devlink_reload_combination_is_invalid(action, limit)) {
> +                       NL_SET_ERR_MSG_MOD(info->extack,
> +                                          "Requested limit is invalid for this action");
> +                       return -EINVAL;
> +               }
> +       }
> +       err = devlink_reload(devlink, dest_net, action, limit, &actions_performed, info->extack);
>
>         if (dest_net)
>                 put_net(dest_net);
> @@ -3090,7 +3154,7 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
>         if (err)
>                 return err;
>         /* For backward compatibility generate reply only if attributes used by user */
> -       if (!info->attrs[DEVLINK_ATTR_RELOAD_ACTION])
> +       if (!info->attrs[DEVLINK_ATTR_RELOAD_ACTION] && !info->attrs[DEVLINK_ATTR_RELOAD_LIMITS])
>                 return 0;
>
>         return devlink_nl_reload_actions_performed_snd(devlink, actions_performed,
> @@ -7347,6 +7411,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
>         [DEVLINK_ATTR_PORT_FUNCTION] = { .type = NLA_NESTED },
>         [DEVLINK_ATTR_RELOAD_ACTION] = NLA_POLICY_RANGE(NLA_U8, DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
>                                                         DEVLINK_RELOAD_ACTION_MAX),
> +       [DEVLINK_ATTR_RELOAD_LIMITS] = NLA_POLICY_BITFIELD32(DEVLINK_RELOAD_LIMITS_VALID_MASK),
>  };
>
>  static const struct genl_small_ops devlink_nl_ops[] = {
> @@ -7682,6 +7747,9 @@ static struct genl_family devlink_nl_family __ro_after_init = {
>
>  static bool devlink_reload_actions_valid(const struct devlink_ops *ops)
>  {
> +       const struct devlink_reload_combination *comb;
> +       int i;
> +
>         if (!devlink_reload_supported(ops)) {
>                 if (WARN_ON(ops->reload_actions))
>                         return false;
> @@ -7692,6 +7760,17 @@ static bool devlink_reload_actions_valid(const struct devlink_ops *ops)
>                     ops->reload_actions & BIT(DEVLINK_RELOAD_ACTION_UNSPEC) ||
>                     ops->reload_actions >= BIT(__DEVLINK_RELOAD_ACTION_MAX)))
>                 return false;
> +
> +       if (WARN_ON(ops->reload_limits & BIT(DEVLINK_RELOAD_LIMIT_UNSPEC) ||
> +                   ops->reload_limits >= BIT(__DEVLINK_RELOAD_LIMIT_MAX)))
> +               return false;
> +
> +       for (i = 0; i < ARRAY_SIZE(devlink_reload_invalid_combinations); i++)  {
> +               comb = &devlink_reload_invalid_combinations[i];
> +               if (ops->reload_actions == BIT(comb->action) &&
> +                   ops->reload_limits == BIT(comb->limit))
> +                       return false;
> +       }
>         return true;
>  }
>
> @@ -10056,6 +10135,7 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
>                                 continue;
>                         err = devlink_reload(devlink, &init_net,
>                                              DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
> +                                            DEVLINK_RELOAD_LIMIT_UNSPEC,
>                                              &actions_performed, NULL);
>                         if (err && err != -EOPNOTSUPP)
>                                 pr_warn("Failed to reload devlink instance into init_net\n");
> --
> 2.18.2
>

--0000000000000d765705b114095c
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
YS3R0dCZgl93IjbqtxySfyXCYBVcbmNI7TXYwPKDp3rYDuXJN+UPU+LuUTcffMyOyxGH45mhNXx5
RnSV48nP5wIDAQABo4IB1jCCAdIwDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBN
BggrBgEFBQcwAoZBaHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25h
bHNpZ24yc2hhMmczb2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWdu
LmNvbS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYI
KwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQC
MAAwRAYDVR0fBD0wOzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFs
c2lnbjJzaGEyZzMuY3JsMCoGA1UdEQQjMCGBH3Zhc3VuZGhhcmEtdi52b2xhbUBicm9hZGNvbS5j
b20wEwYDVR0lBAwwCgYIKwYBBQUHAwQwHwYDVR0jBBgwFoAUaXKCYjFnlUSFd5GAxAQ2SZ17C2Ew
HQYDVR0OBBYEFKBXZ7bBA/b6lD9vCs1cnu0EUStlMA0GCSqGSIb3DQEBCwUAA4IBAQCUtbsWJbT8
mRvubq/HDaw7J1CrT0eVmhcStWb5oowqIv1vvivRBoNWBjCv8ME5o4mlhqb0f2uB1EqIL1B3oC4M
wslo5mPAA3SLSuE0k13VBajU3pBwidjPpuFZTXcmuZoRWTYp1iLFQHMoPF6ngcxlAzymFSxRhrDD
SqTlHafZ5cHnPvs2Vi1YYknDHNkg9Zu8jTqkIH35RfqBohg0aA37+n/4DivO4AkFT0uf/GAgmE3M
9TB6C6XSpcJwqMFie4QajeEVIuP7Iig2m95mEulo5aRerZDiITfACxDeZLEXlvVwaC/8E7MAnf0a
N9w2B4rts1llOp2FaxkZiIJC+xnGMYICbzCCAmsCAQEwbTBdMQswCQYDVQQGEwJCRTEZMBcGA1UE
ChMQR2xvYmFsU2lnbiBudi1zYTEzMDEGA1UEAxMqR2xvYmFsU2lnbiBQZXJzb25hbFNpZ24gMiBD
QSAtIFNIQTI1NiAtIEczAgxWYvjrsGxnl1+028wwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcN
AQkEMSIEIHPDTXifQlpX8BLoNuDeW4IaW6IJ2Y1rXQCTJeXD4n2MMBgGCSqGSIb3DQEJAzELBgkq
hkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIwMTAwNzEyNDEzMlowaQYJKoZIhvcNAQkPMVwwWjAL
BglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG
9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAyhUz9F61u
2dXTN1rsgvHuupbS3EpflsdxU09cQVeGiiHejASjdfO97IQMtkkMYctUE87O27wXxnObdS88Rnt6
HYKfiD7DWvQtrF5IAh7adyVrykfrPdi59a9xJl1Fw4Lcnybsf31BOJNrJgQkCaEPsjM9rOLh2pGG
zpvkbLvIUBd4Pfol15kFIovd3grSFP2Kte1GAwMd+SVlclnfruFFUwh3xCcPujRCamGPbax4ygV7
ZaaoHyLMMrDejtX0BcGfrZDeY2RfNY6uv1y6czbBVj3+i7UHalDsGdHv48hSE934SUT1tfbJGql/
vlhpDq80N7YwVIAXOp1JFDjN8tkp
--0000000000000d765705b114095c--
