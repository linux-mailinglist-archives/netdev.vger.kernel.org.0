Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20978146BEE
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 15:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgAWOyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 09:54:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:57210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727307AbgAWOyq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 09:54:46 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4534A21569;
        Thu, 23 Jan 2020 14:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579791285;
        bh=SMQMIxOGkoJUC2jpo2BoAyASSVdtjj0htnHzSnpDQcw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e8Vqy0Wq0SzcDCnhQBfcUpJ/vgm1Khhb6Dv0xkSNdcW1kk5TgInJKqNPm9ZsRZqcd
         D/1k6AuyC87dALd/gcjez/q6smjJ71cMAyj4vk4f71lW3u/r8JUymR8Ap3MfP5gH6k
         HrNXyPE0S3RaDkDz4mizG7DjT+cPnAFBQ+oX2r4Y=
Date:   Thu, 23 Jan 2020 16:54:42 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next] net/core: Replace driver version to be kernel
 version
Message-ID: <20200123145442.GP7018@unreal>
References: <20200123130541.30473-1-leon@kernel.org>
 <20200123064006.2012fb0b@cakuba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200123064006.2012fb0b@cakuba>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 06:40:06AM -0800, Jakub Kicinski wrote:
> On Thu, 23 Jan 2020 15:05:41 +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > In order to stop useless driver version bumps and unify output
> > presented by ethtool -i, let's overwrite the version string.
> >
> > Before this change:
> > [leonro@erver ~]$ ethtool -i eth0
> > driver: virtio_net
> > version: 1.0.0
> > After this change:
> > [leonro@server ~]$ ethtool -i eth0
> > driver: virtio_net
> > version: 5.5.0-rc6+
> >
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>
> I wonder how hard it would be to tell Coccinelle to remove all prints
> in the drivers.  Removing related defines would probably be a little
> painful/manual. Hm..

It is also unclear how can we automatically catch new comers.

>
> Anyway, you gotta rebase on net-next, the ethtool code got moved around
> :)

I tried it now and It applies cleanly on top of commit
6d9f6e6790e7 Merge branch 'net-sched-add-Flow-Queue-PIE-packet-scheduler'

Thanks
