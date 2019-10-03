Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96F13CA104
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 17:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729937AbfJCPQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 11:16:09 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60531 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728061AbfJCPQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 11:16:09 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8409922063;
        Thu,  3 Oct 2019 11:16:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 03 Oct 2019 11:16:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=mzdXGz
        /g4Dse1gMubOvrsjwUWm78WAXcMXDPxz2ioBs=; b=Jeaqks3TaPDgy8aJKfURbj
        srUpCtkliOMBhSxrO40n+QkO3lartXO0LMn8yTScOPWpKA73my/Dwlpk5hOoFvnq
        Q7cVRekOLCTSlQr9FOdsQ6WUM5W4d7O/NXQqhpR4QcMAHEv3XUj5g8v4K6IWhBFP
        VeuJ7Eax7SJBgkjcqVukCxlEnZO2j2fDlmLV3KVTqY2j51H66p1VYYeMFiy1VIyh
        ndMRLhdMdb8Pmncs7sFzXy7miuwigW3GnO7pIFQkVVgqYVudT7yOomPKH2qopcnv
        PRsx3NggrKPYQgMNaceW2egPUo8GoayVOJSIMl1FOIer1FwjcPhiUOuGSig6Sl0A
        ==
X-ME-Sender: <xms:txCWXftl4WbfAQBjDq_03L1MWMPVwn0gRNlZd5nKkmlrzGQacktGNg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeekgdekjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepudelfe
    drgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:txCWXZ5x6APhow80hfc618a3qA2ODcqDMzepsVW4hnpO354lCcdF0Q>
    <xmx:txCWXTmvlhFR59cHnqvdJmBQH5Byo3SpJ2wdYm8c473Hq_edljly_Q>
    <xmx:txCWXZgmjTEgdjbfjCzFLkJ-iPR7Gg7AH5AzTpi3RSeGHuOv0XEMAQ>
    <xmx:uBCWXSlyupYy7oVJxl8K_BwjJddfhuVJe-gc48tFFGLMrqUJdaIRGg>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1942BD6005F;
        Thu,  3 Oct 2019 11:16:06 -0400 (EDT)
Date:   Thu, 3 Oct 2019 18:16:04 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@gmail.com,
        jiri@mellanox.com, jakub.kicinski@netronome.com,
        saeedm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 13/15] mlxsw: spectrum_router: Mark routes
 as "in hardware"
Message-ID: <20191003151604.GB26217@splinter>
References: <20191002084103.12138-1-idosch@idosch.org>
 <20191002084103.12138-14-idosch@idosch.org>
 <20191002182730.GG2279@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002182730.GG2279@nanopsycho>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 02, 2019 at 08:27:30PM +0200, Jiri Pirko wrote:
> Wed, Oct 02, 2019 at 10:41:01AM CEST, idosch@idosch.org wrote:
> >From: Ido Schimmel <idosch@mellanox.com>
> >
> >Make use of the recently introduced APIs and mark notified routes as "in
> >hardware" after they were programmed to the device's LPM tree.
> >
> >Similarly, when a route is replaced by an higher priority one, clear the
> >"in hardware" indication from it.
> >
> >Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> >---
> > .../ethernet/mellanox/mlxsw/spectrum_router.c | 19 +++++++++++++++++++
> > 1 file changed, 19 insertions(+)
> >
> >diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> >index 5a4e61f1feec..26ab8ae482ec 100644
> >--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> >+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> >@@ -4769,7 +4769,10 @@ static void mlxsw_sp_fib4_entry_replace(struct mlxsw_sp *mlxsw_sp,
> > 					struct mlxsw_sp_fib4_entry *fib4_entry)
> > {
> > 	struct mlxsw_sp_fib_node *fib_node = fib4_entry->common.fib_node;
> >+	struct net *net = mlxsw_sp_net(mlxsw_sp);
> >+	u32 *addr = (u32 *) fib_node->key.addr;
> > 	struct mlxsw_sp_fib4_entry *replaced;
> >+	struct fib_info *fi;
> > 
> > 	if (list_is_singular(&fib_node->entry_list))
> > 		return;
> >@@ -4777,6 +4780,10 @@ static void mlxsw_sp_fib4_entry_replace(struct mlxsw_sp *mlxsw_sp,
> > 	/* We inserted the new entry before replaced one */
> > 	replaced = list_next_entry(fib4_entry, common.list);
> > 
> >+	fi = mlxsw_sp_nexthop4_group_fi(replaced->common.nh_group);
> >+	fib_alias_in_hw_clear(net, *addr, fib_node->key.prefix_len, fi,
> >+			      replaced->tos, replaced->type, replaced->tb_id);
> >+
> > 	mlxsw_sp_fib4_node_entry_unlink(mlxsw_sp, replaced);
> > 	mlxsw_sp_fib4_entry_destroy(mlxsw_sp, replaced);
> > 	mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
> >@@ -4786,6 +4793,7 @@ static int
> > mlxsw_sp_router_fib4_replace(struct mlxsw_sp *mlxsw_sp,
> > 			     const struct fib_entry_notifier_info *fen_info)
> > {
> >+	struct net *net = mlxsw_sp_net(mlxsw_sp);
> > 	struct mlxsw_sp_fib4_entry *fib4_entry;
> > 	struct mlxsw_sp_fib_node *fib_node;
> > 	int err;
> >@@ -4815,6 +4823,10 @@ mlxsw_sp_router_fib4_replace(struct mlxsw_sp *mlxsw_sp,
> > 		goto err_fib4_node_entry_link;
> > 	}
> > 
> >+	fib_alias_in_hw_set(net, fen_info->dst, fen_info->dst_len,
> >+			    fen_info->fi, fen_info->tos, fen_info->type,
> >+			    fen_info->tb_id);
> 
> Can't you pass "fa" through fen_info and down to fib_alias_in_hw_set and
> avoid lookup?

No, because we don't have a reference count on 'fa' and we can't
guarantee that it will not disappear by the time we want to mark it.

> 
> 
> >+
> > 	mlxsw_sp_fib4_entry_replace(mlxsw_sp, fib4_entry);
> > 
> > 	return 0;
> >@@ -5731,11 +5743,18 @@ static void mlxsw_sp_fib4_node_flush(struct mlxsw_sp *mlxsw_sp,
> > 				     struct mlxsw_sp_fib_node *fib_node)
> > {
> > 	struct mlxsw_sp_fib4_entry *fib4_entry, *tmp;
> >+	struct net *net = mlxsw_sp_net(mlxsw_sp);
> >+	u32 *addr = (u32 *) fib_node->key.addr;
> > 
> > 	list_for_each_entry_safe(fib4_entry, tmp, &fib_node->entry_list,
> > 				 common.list) {
> > 		bool do_break = &tmp->common.list == &fib_node->entry_list;
> >+		struct fib_info *fi;
> > 
> >+		fi = mlxsw_sp_nexthop4_group_fi(fib4_entry->common.nh_group);
> >+		fib_alias_in_hw_clear(net, *addr, fib_node->key.prefix_len, fi,
> >+				      fib4_entry->tos, fib4_entry->type,
> >+				      fib4_entry->tb_id);
> > 		mlxsw_sp_fib4_node_entry_unlink(mlxsw_sp, fib4_entry);
> > 		mlxsw_sp_fib4_entry_destroy(mlxsw_sp, fib4_entry);
> > 		mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
> >-- 
> >2.21.0
> >
