Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A869146B7C
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 15:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbgAWOkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 09:40:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:44568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgAWOkH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 09:40:07 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B70F820704;
        Thu, 23 Jan 2020 14:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579790406;
        bh=irSuPaZhU/o3in5pvgpltjlvsLUDO8WGzPIRUemEAdg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rjsYD0kdTdAdQrBl1V2OVcVTsHqQyF6mxB3HAB14WM6arrzVWtqKK4TrTVn9AjvsU
         ooZJ4xapL2ljGZOjY7a+zF5mVwpciQmTZ7h62Wqt3l46LuJndYdYEA8SaL3NwNehqL
         x+66YiV6jxmu7hgda9vngIJk/FdQMsbczEflhLDU=
Date:   Thu, 23 Jan 2020 06:40:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@mellanox.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next] net/core: Replace driver version to be kernel
 version
Message-ID: <20200123064006.2012fb0b@cakuba>
In-Reply-To: <20200123130541.30473-1-leon@kernel.org>
References: <20200123130541.30473-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Jan 2020 15:05:41 +0200, Leon Romanovsky wrote:
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

I wonder how hard it would be to tell Coccinelle to remove all prints
in the drivers.  Removing related defines would probably be a little
painful/manual. Hm..

Anyway, you gotta rebase on net-next, the ethtool code got moved around
:)
