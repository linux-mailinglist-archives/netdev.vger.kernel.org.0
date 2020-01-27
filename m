Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9DA414A415
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 13:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729834AbgA0Mrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 07:47:52 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38588 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbgA0Mrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 07:47:52 -0500
Received: from localhost (unknown [213.175.37.12])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 99D9C153CB64B;
        Mon, 27 Jan 2020 04:47:49 -0800 (PST)
Date:   Mon, 27 Jan 2020 13:47:48 +0100 (CET)
Message-Id: <20200127.134748.1483388411907375372.davem@davemloft.net>
To:     leon@kernel.org
Cc:     kuba@kernel.org, f.fainelli@gmail.com, mkubecek@suse.cz,
        snelson@pensando.io, leonro@mellanox.com,
        michal.kalderon@marvell.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v4] net/core: Replace driver version to be
 kernel version
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200127072028.19123-1-leon@kernel.org>
References: <20200127072028.19123-1-leon@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jan 2020 04:47:51 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leon@kernel.org>
Date: Mon, 27 Jan 2020 09:20:28 +0200

> From: Leon Romanovsky <leonro@mellanox.com>
> 
> In order to stop useless driver version bumps and unify output
> presented by ethtool -i, let's set default version string.
> 
> As Linus said in [1]: "Things are supposed to be backwards and
> forwards compatible, because we don't accept breakage in user
> space anyway. So versioning is pointless, and only causes
> problems."
> 
> They cause problems when users start to see version changes
> and expect specific set of features which will be different
> for stable@, vanilla and distribution kernels.
> 
> Distribution kernels are based on some kernel version with extra
> patches on top, for example, in RedHat world this "extra" is a lot
> and for them your driver version say nothing. Users who run vanilla
> kernels won't use driver version information too, because running
> such kernels requires knowledge and understanding.
> 
> Another set of problems are related to difference in versioning scheme
> and such doesn't allow to write meaningful automation which will work
> sanely on all ethtool capable devices.
> 
> Before this change:
> [leonro@erver ~]$ ethtool -i eth0
> driver: virtio_net
> version: 1.0.0
> After this change and once ->version assignment will be deleted
> from virtio_net:
> [leonro@server ~]$ ethtool -i eth0
> driver: virtio_net
> version: 5.5.0-rc6+
> 
> Link: https://lore.kernel.org/ksummit-discuss/CA+55aFx9A=5cc0QZ7CySC4F2K7eYaEfzkdYEc9JaNgCcV25=rg@mail.gmail.com/
> Link: https://lore.kernel.org/linux-rdma/20200122152627.14903-1-michal.kalderon@marvell.com/T/#md460ff8f976c532a89d6860411c3c50bb811038b
> Link: https://lore.kernel.org/linux-rdma/20200127060835.GA570@unicorn.suse.cz
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

Applied to net-next, thanks.
