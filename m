Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 212572D55E
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 08:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbfE2GKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 02:10:25 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:47877 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725855AbfE2GKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 02:10:25 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1823F22406;
        Wed, 29 May 2019 02:10:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 29 May 2019 02:10:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=MlulXj
        NemHIjrnuxZhQ/WS08arXxr64bjJ89Kagwgx0=; b=R0wmMbXR45IYvvWzKJ0Uv5
        4qPNbOgX9zaDXKkE7pTQ4q2eZDsV8FH1pDt8g0xYbUvZmcMnlD58zgn1X8bSW5Mt
        6RJ0qSWEb5+NXK1t9ARZ8T3r+frmYRrYI/UJpgcvl2KwgrUC52Y61EL706v1nASx
        k+r3m3CPpRV2e75F3vxDVxJa3QLbEIZmHiBL+/eTuWCirjg9QP92xIAS5CwqDuS6
        J3sMMOGvPtopi0HMXE5s19Y0m8VkWoHUdILiknkUUNBpQKVjaRz8EySp1GHGwci6
        ogZLdotWzNDX+oDMXPtphqTG9yszFBiOaKd0VCQh3YT5+wVST30Ctr+tjHVCNmJg
        ==
X-ME-Sender: <xms:TyLuXICDydNRPMjil--ZjjjrpMOCz3Jde9msp1RXAbmXa8_CaFS_cA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddviedguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepud
    elfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgt
    hhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:TyLuXAcf4u_dREO6I1lNWUeamOXR5PeAjF8Um4H7S4m5_EHdmfcXUw>
    <xmx:TyLuXIsfCV3qieuHDdkYw46kke2c7ZLyKx4_9SAlBKqB6PrMCzPESw>
    <xmx:TyLuXPhaRwbFhiIRJmU0XK5CZFpRFcbtAkVpc0BGP8Mf079Fv2sxnQ>
    <xmx:UCLuXLoXawV5x1_RtHnMEh4Jp-789VmRCouLdjyFRxW_FFHvjYYFMA>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9FA0B80059;
        Wed, 29 May 2019 02:10:22 -0400 (EDT)
Date:   Wed, 29 May 2019 09:10:20 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org,
        f.fainelli@gmail.com
Subject: Re: [patch net-next v2 5/7] mlxfw: Introduce status_notify op and
 call it to notify about the status
Message-ID: <20190529061020.GD10684@splinter>
References: <20190528114846.1983-1-jiri@resnulli.us>
 <20190528114846.1983-6-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528114846.1983-6-jiri@resnulli.us>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 01:48:44PM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Add new op status_notify which is called to update the user about
> flashing status.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

As I wrote during internal review, I think it is weird to have drivers
implement this status_notify() operation given mlxfw has all the
required information. The only thing drivers are doing is resolving the
devlink instance and calling into devlink. Would have been cleaner to
pass the devlink instance to mlxfw and have it call into devlink for
status updates directly.

But I don't see anything incorrect, so:

Reviewed-by: Ido Schimmel <idosch@mellanox.com>
