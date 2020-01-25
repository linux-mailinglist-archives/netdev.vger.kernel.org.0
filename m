Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1A65149413
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 10:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgAYJNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 04:13:15 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48722 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgAYJNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 04:13:14 -0500
Received: from localhost (unknown [147.229.117.36])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AEDF115A1AF33;
        Sat, 25 Jan 2020 01:13:12 -0800 (PST)
Date:   Sat, 25 Jan 2020 10:13:11 +0100 (CET)
Message-Id: <20200125.101311.1924780619716720495.davem@davemloft.net>
To:     leon@kernel.org
Cc:     kuba@kernel.org, leonro@mellanox.com, michal.kalderon@marvell.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] net/core: Replace driver version to be kernel
 version
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200123130541.30473-1-leon@kernel.org>
References: <20200123130541.30473-1-leon@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 Jan 2020 01:13:14 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leon@kernel.org>
Date: Thu, 23 Jan 2020 15:05:41 +0200

> From: Leon Romanovsky <leonro@mellanox.com>
> 
> In order to stop useless driver version bumps and unify output
> presented by ethtool -i, let's overwrite the version string.
> 
> Before this change:
> [leonro@erver ~]$ ethtool -i eth0
> driver: virtio_net
> version: 1.0.0
> After this change:
> [leonro@server ~]$ ethtool -i eth0
> driver: virtio_net
> version: 5.5.0-rc6+
> 
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

Please respin on current net-next, thank you :)
