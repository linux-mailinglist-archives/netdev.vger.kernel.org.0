Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9962F267707
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 03:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgILBKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 21:10:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725824AbgILBKf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 21:10:35 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3684C2074B;
        Sat, 12 Sep 2020 01:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599873035;
        bh=pkS0fL0+KYuhbsmVbhe1zSsIV8q73VfYcOc0QukrGQ4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0pkHtA197w8GQg5n59qgabQnzsihAWqRH1bQsI10xtHxtwp35kyTOj9rHFa7kxzhO
         /9hpxauLpMVg4FgQmHIyrWaqbUGJM4moTBwvvAzTaBT+mhSLEJCeuM8cCiuSQHeTYh
         TySfKJ77FWlUY6zRf5PsYhxzn+8JlZDVuMJPqXUs=
Date:   Fri, 11 Sep 2020 18:10:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        michael.chan@broadcom.com, tariqt@nvidia.com, saeedm@nvidia.com,
        alexander.duyck@gmail.com, andrew@lunn.ch
Subject: Re: [PATCH net-next v2 7/8] mlx5: add pause frame stats
Message-ID: <20200911181033.35b459fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200911232853.1072362-8-kuba@kernel.org>
References: <20200911232853.1072362-1-kuba@kernel.org>
        <20200911232853.1072362-8-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Sep 2020 16:28:52 -0700 Jakub Kicinski wrote:
> +static void mlx5e_uplink_rep_get_pause_stats(struct net_device *netdev,
> +					     struct ethtool_pause_stats *stats)
> +{
> +	struct mlx5e_priv *priv = netdev_priv(netdev);
> +
> +	mlx5e_stats_pause_get(priv, pause_stats);

s/pause_stats/stats/

I'll give people time to review and post v3 on Monday.
