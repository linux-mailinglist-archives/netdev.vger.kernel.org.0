Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA4DF191D7E
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 00:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgCXXZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 19:25:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37874 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbgCXXZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 19:25:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E770F159F5293;
        Tue, 24 Mar 2020 16:25:36 -0700 (PDT)
Date:   Tue, 24 Mar 2020 16:25:36 -0700 (PDT)
Message-Id: <20200324.162536.1931215402668902440.davem@davemloft.net>
To:     vladyslavt@mellanox.com
Cc:     netdev@vger.kernel.org, maximmi@mellanox.com, mkubecek@suse.cz,
        moshe@mellanox.com
Subject: Re: [PATCH net-next] ethtool: fix incorrect tx-checksumming
 settings reporting
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200324115708.31186-1-vladyslavt@mellanox.com>
References: <20200324115708.31186-1-vladyslavt@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Mar 2020 16:25:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
Date: Tue, 24 Mar 2020 13:57:08 +0200

> Currently, ethtool feature mask for checksum command is ORed with
> NETIF_F_FCOE_CRC_BIT, which is bit's position number, instead of the
> actual feature bit - NETIF_F_FCOE_CRC.
> 
> The invalid bitmask here might affect unrelated features when toggling
> TX checksumming. For example, TX checksumming is always mistakenly
> reported as enabled on the netdevs tested (mlx5, virtio_net).
> 
> Fixes: f70bb06563ed ("ethtool: update mapping of features to legacy ioctl requests")
> Signed-off-by: Vladyslav Tarasiuk <vladyslavt@mellanox.com>

Applied, thanks.
