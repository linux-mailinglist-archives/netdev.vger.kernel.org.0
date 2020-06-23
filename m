Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD187206289
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392833AbgFWVEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 17:04:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389620AbgFWVD7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 17:03:59 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E72420724;
        Tue, 23 Jun 2020 21:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592946239;
        bh=jJIW+p9OyYiiw56Z+mZUA5cdxbphGvJCpK8z8PNr4ts=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xjrvCOXQces/UtDKEssR4iHIvOmXtcz4B+mvwkFnOcM2nmWSFgS0j6W0kc0NJKJ/Z
         ceWUGFbW9RJfK12drdF3Mi86E6x4GwIPasqJlyT8TPix1g1lha6SNGfnSeAYpPsJze
         +2BJLHgkRe/J7AApN/GJE4Ipx7gRGf953ZZR6UUg=
Date:   Tue, 23 Jun 2020 14:03:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Maor Dickman <maord@mellanox.com>
Subject: Re: [net-next 07/10] net/mlx5e: Move TC-specific function
 definitions into MLX5_CLS_ACT
Message-ID: <20200623140357.6412f74f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200623195229.26411-8-saeedm@mellanox.com>
References: <20200623195229.26411-1-saeedm@mellanox.com>
 <20200623195229.26411-8-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jun 2020 12:52:26 -0700 Saeed Mahameed wrote:
> From: Vlad Buslov <vladbu@mellanox.com>
> 
> en_tc.h header file declares several TC-specific functions in
> CONFIG_MLX5_ESWITCH block even though those functions are only compiled
> when CONFIG_MLX5_CLS_ACT is set, which is a recent change. Move them to
> proper block.
> 
> Fixes: d956873f908c ("net/mlx5e: Introduce kconfig var for TC support")

and here... do those break build or something?

> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
> Reviewed-by: Roi Dayan <roid@mellanox.com>
> Reviewed-by: Maor Dickman <maord@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
