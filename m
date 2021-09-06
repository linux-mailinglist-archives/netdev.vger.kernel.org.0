Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A48F34018D7
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 11:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241295AbhIFJaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 05:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241206AbhIFJay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 05:30:54 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D671C061575;
        Mon,  6 Sep 2021 02:29:49 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 17so6219318pgp.4;
        Mon, 06 Sep 2021 02:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hL2ugt59kOCAMo+Nwz7pp0ILNBTnt9SHLqa6r2SYKKQ=;
        b=f8S7kjs/+WhRPf5Q5OnBagtx7FEFHKZ+4HkKgF6hxo7te04of8kuvUbFgAzzIKG8O9
         YS7aj48Z10CghHBhiol4ds/Z9ulgAPnIEo3EcZ3g4gZhWDoTaxhtwU54gvsBUS8H19DV
         4+yHMFDPji0ImWPywSxEzwE0Dx0LkbNcdOtzaGip7mSLsxeo6Ol2IhCco2vTJZwxtsX1
         f8FgI2qJiKjKPWKzFaYx0XtoA2gwVscaE2jqboiyGx0tBtrbzi39uM4mhapvrMKoPV8K
         DjT5f2X7Jf2dkH8YxrKkV7bMcAYm6pA/YLkA+0OTciD8elXWNOnqFPOsuOkexpFNgNll
         XeSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hL2ugt59kOCAMo+Nwz7pp0ILNBTnt9SHLqa6r2SYKKQ=;
        b=f3F+P1O7Udlu2t4gxBI4F9UdKM2TUbNHc2I77CtcyQLeYJEToOIc7vjtn6pe5WF+Y5
         NWkcXbMIudTjjoGyOAVvpDykppU2sHqBPh5Ql20E5r/hv7DVkeQnMbJDQQOtZASzt8qR
         irIOpv4NFTW3sdDWrvx33q192TsvW4QQv1JqnIGbDVkzdzZU5hDjZJH02h1DOXmwhiUt
         FWJyZ2nTeE3Cml7/u1mC63QAyfEttRofWy+65lzHiFqbcy2SM3B7Oy4Z/8E17zxEvzen
         Ik9JyJhSzC6FbmQgGUwsMIijvsdC2IoNBQBd+mx8CbM5NcF7DENRX4Z1carE/7hKn+AJ
         izMw==
X-Gm-Message-State: AOAM5330AoXZXUf2VJ5i9cEAl5k9PhX2rraGvXejp3fqB2k2YBaCB4AD
        ZsXuuTyJ5LIUf7dsegBbaPc=
X-Google-Smtp-Source: ABdhPJwOe8B+CLfO6tTr9GRywGUhzTze4STspDfmBSz8ORqi/MdXQx6o6JEqFo9//6/78CHTmkmynw==
X-Received: by 2002:aa7:8e81:0:b0:3fe:f212:f9dd with SMTP id a1-20020aa78e81000000b003fef212f9ddmr10801405pfr.46.1630920588805;
        Mon, 06 Sep 2021 02:29:48 -0700 (PDT)
Received: from arn.remote.csb ([49.206.7.248])
        by smtp.gmail.com with ESMTPSA id x124sm6913652pfb.59.2021.09.06.02.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 02:29:48 -0700 (PDT)
From:   Abhiram R N <abhiramrn@gmail.com>
X-Google-Original-From: Abhiram R N <abhiramrm@gmail.com>
Date:   Mon, 6 Sep 2021 14:59:35 +0530
To:     Roi Dayan <roid@nvidia.com>
Cc:     Abhiram R N <abhiramrn@gmail.com>, saeedm@nvidia.com,
        arn@redhat.com, hakhande@redhat.com,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net/mlx5e: Add extack msgs related to TC for better
 debug
Message-ID: <20210906092935.GA29607@arn.remote.csb>
References: <b25cb092-6793-5175-55a2-1d620949da09@nvidia.com>
 <20210831084406.12825-1-abhiramrn@gmail.com>
 <76ab8d32-4457-8dd2-8df0-d31919d8441f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76ab8d32-4457-8dd2-8df0-d31919d8441f@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi,

Thanks for your feedback. Please see replies inline.

On Sun, Sep 05, 2021 at 04:39:41PM +0300, Roi Dayan wrote:
> 
> 
> On 2021-08-31 11:44 AM, Abhiram R N wrote:
> > As multiple places EOPNOTSUPP and EINVAL is returned from driver
> > it becomes difficult to understand the reason only with error code.
> > With the netlink extack message exact reason will be known and will
> > aid in debugging.
> > 
> > Signed-off-by: Abhiram R N <abhiramrn@gmail.com>
> > ---
> >   .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 106 +++++++++++++-----
> >   1 file changed, 76 insertions(+), 30 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > index d273758255c3..911eab2acaad 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > @@ -1894,8 +1894,10 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
> >   	bool needs_mapping, sets_mapping;
> >   	int err;
> > -	if (!mlx5e_is_eswitch_flow(flow))
> > +	if (!mlx5e_is_eswitch_flow(flow)) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Match on tunnel is not supported");
> >   		return -EOPNOTSUPP;
> > +	}
> >   	needs_mapping = !!flow->attr->chain;
> >   	sets_mapping = !flow->attr->chain && flow_has_tc_fwd_action(f);
> > @@ -2267,8 +2269,10 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
> >   		addr_type = match.key->addr_type;
> >   		/* the HW doesn't support frag first/later */
> > -		if (match.mask->flags & FLOW_DIS_FIRST_FRAG)
> > +		if (match.mask->flags & FLOW_DIS_FIRST_FRAG) {
> > +			NL_SET_ERR_MSG_MOD(extack, "Match on frag first/later is not supported");
> >   			return -EOPNOTSUPP;
> > +		}
> >   		if (match.mask->flags & FLOW_DIS_IS_FRAGMENT) {
> >   			MLX5_SET(fte_match_set_lyr_2_4, headers_c, frag, 1);
> > @@ -2435,8 +2439,11 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
> >   		switch (ip_proto) {
> >   		case IPPROTO_ICMP:
> >   			if (!(MLX5_CAP_GEN(priv->mdev, flex_parser_protocols) &
> > -			      MLX5_FLEX_PROTO_ICMP))
> > +			      MLX5_FLEX_PROTO_ICMP)) {
> > +				NL_SET_ERR_MSG_MOD(extack,
> > +						   "Match on Flex protocols for ICMP not supported");
> 
> can you add "is" as ".. is not supported"?
Sure. Will change it.
> 
> >   				return -EOPNOTSUPP;
> > +			}
> >   			MLX5_SET(fte_match_set_misc3, misc_c_3, icmp_type,
> >   				 match.mask->type);
> >   			MLX5_SET(fte_match_set_misc3, misc_v_3, icmp_type,
> > @@ -2448,8 +2455,11 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
> >   			break;
> >   		case IPPROTO_ICMPV6:
> >   			if (!(MLX5_CAP_GEN(priv->mdev, flex_parser_protocols) &
> > -			      MLX5_FLEX_PROTO_ICMPV6))
> > +			      MLX5_FLEX_PROTO_ICMPV6)) {
> > +				NL_SET_ERR_MSG_MOD(extack,
> > +						   "Match on Flex protocols for ICMPV6 not supported");
> 
> can you add "is" as ".. is not supported"?
Sure. will change it.
> 
> also, can you submit this patch to net-next and not net please?
> it's not really fixing an issue and will help avoid conflicts with
> changes we plan on this file.
> thanks

Sure. I will submit it to net-next. I checked now and net-next is closed 
it says (http://vger.kernel.org/~davem/net-next.html). 
I will wait for it to be open and then submit there.

> 
> 
> >   				return -EOPNOTSUPP;
> > +			}
> >   			MLX5_SET(fte_match_set_misc3, misc_c_3, icmpv6_type,
> >   				 match.mask->type);
> >   			MLX5_SET(fte_match_set_misc3, misc_v_3, icmpv6_type,
> > @@ -2555,15 +2565,19 @@ static int pedit_header_offsets[] = {
> >   #define pedit_header(_ph, _htype) ((void *)(_ph) + pedit_header_offsets[_htype])
> >   static int set_pedit_val(u8 hdr_type, u32 mask, u32 val, u32 offset,
> > -			 struct pedit_headers_action *hdrs)
> > +			 struct pedit_headers_action *hdrs,
> > +			 struct netlink_ext_ack *extack)
> >   {
> >   	u32 *curr_pmask, *curr_pval;
> >   	curr_pmask = (u32 *)(pedit_header(&hdrs->masks, hdr_type) + offset);
> >   	curr_pval  = (u32 *)(pedit_header(&hdrs->vals, hdr_type) + offset);
> > -	if (*curr_pmask & mask)  /* disallow acting twice on the same location */
> > +	if (*curr_pmask & mask) {  /* disallow acting twice on the same location */
> > +		NL_SET_ERR_MSG_MOD(extack,
> > +				   "curr_pmask and new mask same. Acting twice on same location");
> >   		goto out_err;
> > +	}
> >   	*curr_pmask |= mask;
> >   	*curr_pval  |= (val & mask);
> > @@ -2893,7 +2907,7 @@ parse_pedit_to_modify_hdr(struct mlx5e_priv *priv,
> >   	val = act->mangle.val;
> >   	offset = act->mangle.offset;
> > -	err = set_pedit_val(htype, ~mask, val, offset, &hdrs[cmd]);
> > +	err = set_pedit_val(htype, ~mask, val, offset, &hdrs[cmd], extack);
> >   	if (err)
> >   		goto out_err;
> > @@ -2913,8 +2927,10 @@ parse_pedit_to_reformat(struct mlx5e_priv *priv,
> >   	u32 mask, val, offset;
> >   	u32 *p;
> > -	if (act->id != FLOW_ACTION_MANGLE)
> > +	if (act->id != FLOW_ACTION_MANGLE) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Unsupported action id");
> >   		return -EOPNOTSUPP;
> > +	}
> >   	if (act->mangle.htype != FLOW_ACT_MANGLE_HDR_TYPE_ETH) {
> >   		NL_SET_ERR_MSG_MOD(extack, "Only Ethernet modification is supported");
> > @@ -3363,12 +3379,16 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
> >   	u32 action = 0;
> >   	int err, i;
> > -	if (!flow_action_has_entries(flow_action))
> > +	if (!flow_action_has_entries(flow_action)) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Flow Action doesn't have any entries");
> >   		return -EINVAL;
> > +	}
> >   	if (!flow_action_hw_stats_check(flow_action, extack,
> > -					FLOW_ACTION_HW_STATS_DELAYED_BIT))
> > +					FLOW_ACTION_HW_STATS_DELAYED_BIT)) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Flow Action HW stats check not supported");
> >   		return -EOPNOTSUPP;
> > +	}
> >   	nic_attr = attr->nic_attr;
> > @@ -3459,7 +3479,8 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
> >   			flow_flag_set(flow, CT);
> >   			break;
> >   		default:
> > -			NL_SET_ERR_MSG_MOD(extack, "The offload action is not supported");
> > +			NL_SET_ERR_MSG_MOD(extack,
> > +					   "The offload action is not supported in NIC action");
> >   			return -EOPNOTSUPP;
> >   		}
> >   	}
> > @@ -3514,19 +3535,25 @@ static bool is_merged_eswitch_vfs(struct mlx5e_priv *priv,
> >   static int parse_tc_vlan_action(struct mlx5e_priv *priv,
> >   				const struct flow_action_entry *act,
> >   				struct mlx5_esw_flow_attr *attr,
> > -				u32 *action)
> > +				u32 *action,
> > +				struct netlink_ext_ack *extack)
> >   {
> >   	u8 vlan_idx = attr->total_vlan;
> > -	if (vlan_idx >= MLX5_FS_VLAN_DEPTH)
> > +	if (vlan_idx >= MLX5_FS_VLAN_DEPTH) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Total vlans used is greater than supported");
> >   		return -EOPNOTSUPP;
> > +	}
> >   	switch (act->id) {
> >   	case FLOW_ACTION_VLAN_POP:
> >   		if (vlan_idx) {
> >   			if (!mlx5_eswitch_vlan_actions_supported(priv->mdev,
> > -								 MLX5_FS_VLAN_DEPTH))
> > +								 MLX5_FS_VLAN_DEPTH)) {
> > +				NL_SET_ERR_MSG_MOD(extack,
> > +						   "vlan pop action is not supported");
> >   				return -EOPNOTSUPP;
> > +			}
> >   			*action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_POP_2;
> >   		} else {
> > @@ -3542,20 +3569,27 @@ static int parse_tc_vlan_action(struct mlx5e_priv *priv,
> >   		if (vlan_idx) {
> >   			if (!mlx5_eswitch_vlan_actions_supported(priv->mdev,
> > -								 MLX5_FS_VLAN_DEPTH))
> > +								 MLX5_FS_VLAN_DEPTH)) {
> > +				NL_SET_ERR_MSG_MOD(extack,
> > +						   "vlan push action is not supported for vlan depth > 1");
> >   				return -EOPNOTSUPP;
> > +			}
> >   			*action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2;
> >   		} else {
> >   			if (!mlx5_eswitch_vlan_actions_supported(priv->mdev, 1) &&
> >   			    (act->vlan.proto != htons(ETH_P_8021Q) ||
> > -			     act->vlan.prio))
> > +			     act->vlan.prio)) {
> > +				NL_SET_ERR_MSG_MOD(extack,
> > +						   "vlan push action is not supported");
> >   				return -EOPNOTSUPP;
> > +			}
> >   			*action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH;
> >   		}
> >   		break;
> >   	default:
> > +		NL_SET_ERR_MSG_MOD(extack, "Unexpected action id for VLAN");
> >   		return -EINVAL;
> >   	}
> > @@ -3589,7 +3623,8 @@ static struct net_device *get_fdb_out_dev(struct net_device *uplink_dev,
> >   static int add_vlan_push_action(struct mlx5e_priv *priv,
> >   				struct mlx5_flow_attr *attr,
> >   				struct net_device **out_dev,
> > -				u32 *action)
> > +				u32 *action,
> > +				struct netlink_ext_ack *extack)
> >   {
> >   	struct net_device *vlan_dev = *out_dev;
> >   	struct flow_action_entry vlan_act = {
> > @@ -3600,7 +3635,7 @@ static int add_vlan_push_action(struct mlx5e_priv *priv,
> >   	};
> >   	int err;
> > -	err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, action);
> > +	err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, action, extack);
> >   	if (err)
> >   		return err;
> > @@ -3611,14 +3646,15 @@ static int add_vlan_push_action(struct mlx5e_priv *priv,
> >   		return -ENODEV;
> >   	if (is_vlan_dev(*out_dev))
> > -		err = add_vlan_push_action(priv, attr, out_dev, action);
> > +		err = add_vlan_push_action(priv, attr, out_dev, action, extack);
> >   	return err;
> >   }
> >   static int add_vlan_pop_action(struct mlx5e_priv *priv,
> >   			       struct mlx5_flow_attr *attr,
> > -			       u32 *action)
> > +			       u32 *action,
> > +			       struct netlink_ext_ack *extack)
> >   {
> >   	struct flow_action_entry vlan_act = {
> >   		.id = FLOW_ACTION_VLAN_POP,
> > @@ -3628,7 +3664,7 @@ static int add_vlan_pop_action(struct mlx5e_priv *priv,
> >   	nest_level = attr->parse_attr->filter_dev->lower_level -
> >   						priv->netdev->lower_level;
> >   	while (nest_level--) {
> > -		err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, action);
> > +		err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, action, extack);
> >   		if (err)
> >   			return err;
> >   	}
> > @@ -3751,12 +3787,16 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
> >   	int err, i, if_count = 0;
> >   	bool mpls_push = false;
> > -	if (!flow_action_has_entries(flow_action))
> > +	if (!flow_action_has_entries(flow_action)) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Flow action doesn't have any entries");
> >   		return -EINVAL;
> > +	}
> >   	if (!flow_action_hw_stats_check(flow_action, extack,
> > -					FLOW_ACTION_HW_STATS_DELAYED_BIT))
> > +					FLOW_ACTION_HW_STATS_DELAYED_BIT)) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Flow Action HW stats check is not supported");
> >   		return -EOPNOTSUPP;
> > +	}
> >   	esw_attr = attr->esw_attr;
> >   	parse_attr = attr->parse_attr;
> > @@ -3900,14 +3940,14 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
> >   				if (is_vlan_dev(out_dev)) {
> >   					err = add_vlan_push_action(priv, attr,
> >   								   &out_dev,
> > -								   &action);
> > +								   &action, extack);
> >   					if (err)
> >   						return err;
> >   				}
> >   				if (is_vlan_dev(parse_attr->filter_dev)) {
> >   					err = add_vlan_pop_action(priv, attr,
> > -								  &action);
> > +								  &action, extack);
> >   					if (err)
> >   						return err;
> >   				}
> > @@ -3953,10 +3993,13 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
> >   			break;
> >   		case FLOW_ACTION_TUNNEL_ENCAP:
> >   			info = act->tunnel;
> > -			if (info)
> > +			if (info) {
> >   				encap = true;
> > -			else
> > +			} else {
> > +				NL_SET_ERR_MSG_MOD(extack,
> > +						   "Zero tunnel attributes is not supported");
> >   				return -EOPNOTSUPP;
> > +			}
> >   			break;
> >   		case FLOW_ACTION_VLAN_PUSH:
> > @@ -3970,7 +4013,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
> >   							      act, parse_attr, hdrs,
> >   							      &action, extack);
> >   			} else {
> > -				err = parse_tc_vlan_action(priv, act, esw_attr, &action);
> > +				err = parse_tc_vlan_action(priv, act, esw_attr, &action, extack);
> >   			}
> >   			if (err)
> >   				return err;
> > @@ -4023,7 +4066,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
> >   			flow_flag_set(flow, SAMPLE);
> >   			break;
> >   		default:
> > -			NL_SET_ERR_MSG_MOD(extack, "The offload action is not supported");
> > +			NL_SET_ERR_MSG_MOD(extack,
> > +					   "The offload action is not supported in FDB action");
> >   			return -EOPNOTSUPP;
> >   		}
> >   	}
> > @@ -4731,8 +4775,10 @@ static int scan_tc_matchall_fdb_actions(struct mlx5e_priv *priv,
> >   		return -EOPNOTSUPP;
> >   	}
> > -	if (!flow_action_basic_hw_stats_check(flow_action, extack))
> > +	if (!flow_action_basic_hw_stats_check(flow_action, extack)) {
> > +		NL_SET_ERR_MSG_MOD(extack, "Flow Action HW stats check is not supported");
> >   		return -EOPNOTSUPP;
> > +	}
> >   	flow_action_for_each(i, act, flow_action) {
> >   		switch (act->id) {
> > 

Thanks & Regards,
Abhiram R N

