Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFE7DC90CD
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 20:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbfJBS1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 14:27:34 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52184 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfJBS1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 14:27:34 -0400
Received: by mail-wm1-f65.google.com with SMTP id 7so8254265wme.1
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 11:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PNn5DQVGZsmw/Z7qo6ZoC5VN/UI1eLcZeBPa4q/txj4=;
        b=BgCx5rA4ATIdMxRVzOZNkW2mjRU8vrtOH7UfBDvIxCenm2XrTGbamz5f/hG/1uGo50
         3MlrAZFkBXxrtA4zs6UzPbuHv/vJDF19jr92o0Cf47bxSmOa9qYWDVXXZ5d/IZ+hiN5N
         eguWuzA5QLm8iZ3Y8zemr2S7ZAHg7eSoofYheloHA1yAb3KI3x4Uxzf5yKp4MKrj6bNk
         kF/sxnkJSwAGCRKMcaRHRktt0n1kTYRlf4Z2loFe0ypD5mYfq3UIYIHSn7rX6nIZnFc8
         oubvXFhJUhwgJ7x76MjT8gUbEGCJpcvY+N06aeuEgZhd+p+9LbW3Gd/SSuycBJEhWnqw
         cDcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PNn5DQVGZsmw/Z7qo6ZoC5VN/UI1eLcZeBPa4q/txj4=;
        b=cD3cy3NbXBFp5+ZN8VDcD1/6gkBRKneHfggbvjZ5lkGWMapb6jd5zVLSpUA2uJVBCQ
         JCOhTsCK1GbeLg33p3MOAh63y36o2Oo0mO72J+GE9dhxrcp4Tjb+ljLlA9QvJfJDHio4
         0SVUF9Qczdn2ig0+ZXhKL74oB5lwbr3mJ+NsqU/BHmWVxbOPsjKJdLcFUCL3R0UJSlac
         Od9BAL64R5ID+GWxGi1GT7Km5lP8gjbqCkyWmsCAzkLiHcAoh2VzEhTKftyAIo8YoTea
         jATSyacbrLX1OTMqC1L4sW1B5GATHQVp+WBhCfIiqR2iTkImVSCXuPML4JvmN7aLwiuH
         nomA==
X-Gm-Message-State: APjAAAWBokPmnniVuDzndNIeSS7ET0TXY27IseVxZZXNVChmhvpK3js0
        uD/jVbz71oz9mQAZJtTSefYNhw==
X-Google-Smtp-Source: APXvYqySg8vCDauQBHIflINdXmR8jgw6yOG/zFShY0T8ke7x1h70+q+ZjdMdZqd4D8KZCNFzg7pscA==
X-Received: by 2002:a1c:7d8e:: with SMTP id y136mr3842186wmc.83.1570040852036;
        Wed, 02 Oct 2019 11:27:32 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id l4sm304245wrw.6.2019.10.02.11.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 11:27:31 -0700 (PDT)
Date:   Wed, 2 Oct 2019 20:27:30 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@gmail.com,
        jiri@mellanox.com, jakub.kicinski@netronome.com,
        saeedm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 13/15] mlxsw: spectrum_router: Mark routes
 as "in hardware"
Message-ID: <20191002182730.GG2279@nanopsycho>
References: <20191002084103.12138-1-idosch@idosch.org>
 <20191002084103.12138-14-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002084103.12138-14-idosch@idosch.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Oct 02, 2019 at 10:41:01AM CEST, idosch@idosch.org wrote:
>From: Ido Schimmel <idosch@mellanox.com>
>
>Make use of the recently introduced APIs and mark notified routes as "in
>hardware" after they were programmed to the device's LPM tree.
>
>Similarly, when a route is replaced by an higher priority one, clear the
>"in hardware" indication from it.
>
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>
>---
> .../ethernet/mellanox/mlxsw/spectrum_router.c | 19 +++++++++++++++++++
> 1 file changed, 19 insertions(+)
>
>diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
>index 5a4e61f1feec..26ab8ae482ec 100644
>--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
>+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
>@@ -4769,7 +4769,10 @@ static void mlxsw_sp_fib4_entry_replace(struct mlxsw_sp *mlxsw_sp,
> 					struct mlxsw_sp_fib4_entry *fib4_entry)
> {
> 	struct mlxsw_sp_fib_node *fib_node = fib4_entry->common.fib_node;
>+	struct net *net = mlxsw_sp_net(mlxsw_sp);
>+	u32 *addr = (u32 *) fib_node->key.addr;
> 	struct mlxsw_sp_fib4_entry *replaced;
>+	struct fib_info *fi;
> 
> 	if (list_is_singular(&fib_node->entry_list))
> 		return;
>@@ -4777,6 +4780,10 @@ static void mlxsw_sp_fib4_entry_replace(struct mlxsw_sp *mlxsw_sp,
> 	/* We inserted the new entry before replaced one */
> 	replaced = list_next_entry(fib4_entry, common.list);
> 
>+	fi = mlxsw_sp_nexthop4_group_fi(replaced->common.nh_group);
>+	fib_alias_in_hw_clear(net, *addr, fib_node->key.prefix_len, fi,
>+			      replaced->tos, replaced->type, replaced->tb_id);
>+
> 	mlxsw_sp_fib4_node_entry_unlink(mlxsw_sp, replaced);
> 	mlxsw_sp_fib4_entry_destroy(mlxsw_sp, replaced);
> 	mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
>@@ -4786,6 +4793,7 @@ static int
> mlxsw_sp_router_fib4_replace(struct mlxsw_sp *mlxsw_sp,
> 			     const struct fib_entry_notifier_info *fen_info)
> {
>+	struct net *net = mlxsw_sp_net(mlxsw_sp);
> 	struct mlxsw_sp_fib4_entry *fib4_entry;
> 	struct mlxsw_sp_fib_node *fib_node;
> 	int err;
>@@ -4815,6 +4823,10 @@ mlxsw_sp_router_fib4_replace(struct mlxsw_sp *mlxsw_sp,
> 		goto err_fib4_node_entry_link;
> 	}
> 
>+	fib_alias_in_hw_set(net, fen_info->dst, fen_info->dst_len,
>+			    fen_info->fi, fen_info->tos, fen_info->type,
>+			    fen_info->tb_id);

Can't you pass "fa" through fen_info and down to fib_alias_in_hw_set and
avoid lookup?


>+
> 	mlxsw_sp_fib4_entry_replace(mlxsw_sp, fib4_entry);
> 
> 	return 0;
>@@ -5731,11 +5743,18 @@ static void mlxsw_sp_fib4_node_flush(struct mlxsw_sp *mlxsw_sp,
> 				     struct mlxsw_sp_fib_node *fib_node)
> {
> 	struct mlxsw_sp_fib4_entry *fib4_entry, *tmp;
>+	struct net *net = mlxsw_sp_net(mlxsw_sp);
>+	u32 *addr = (u32 *) fib_node->key.addr;
> 
> 	list_for_each_entry_safe(fib4_entry, tmp, &fib_node->entry_list,
> 				 common.list) {
> 		bool do_break = &tmp->common.list == &fib_node->entry_list;
>+		struct fib_info *fi;
> 
>+		fi = mlxsw_sp_nexthop4_group_fi(fib4_entry->common.nh_group);
>+		fib_alias_in_hw_clear(net, *addr, fib_node->key.prefix_len, fi,
>+				      fib4_entry->tos, fib4_entry->type,
>+				      fib4_entry->tb_id);
> 		mlxsw_sp_fib4_node_entry_unlink(mlxsw_sp, fib4_entry);
> 		mlxsw_sp_fib4_entry_destroy(mlxsw_sp, fib4_entry);
> 		mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
>-- 
>2.21.0
>
