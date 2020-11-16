Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367232B54A0
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 23:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727618AbgKPWw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 17:52:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:51646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgKPWw2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 17:52:28 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06B2C2244C;
        Mon, 16 Nov 2020 22:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605567147;
        bh=M9FCESf28oCmz+hTXOcJ+1gNj88Zf0TWJldSx6u9Y8Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IBichkyvjC6sx2U0pLoSqX4SmE/fbdAkuz4M1+ZWsnzs+LmQmsA9Ccv5WaWBHK27g
         o14lyVYT4IB5f7oBLD7xX0RMyWU5aBPKXEpfn5RmgfcvuxJSWgrUPDaEKYrS5AG436
         /YvHMw/9cmIiUudFVbwCQxT6QV1BTnweJrsFDY24=
Date:   Mon, 16 Nov 2020 14:52:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <jiri@nvidia.com>, <jgg@nvidia.com>,
        <dledford@redhat.com>, <leonro@nvidia.com>, <saeedm@nvidia.com>,
        <davem@davemloft.net>
Subject: Re: [PATCH net-next 00/13] Add mlx5 subfunction support
Message-ID: <20201116145226.27b30b1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201112192424.2742-1-parav@nvidia.com>
References: <20201112192424.2742-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 21:24:10 +0200 Parav Pandit wrote:
> This series introduces support for mlx5 subfunction (SF).
> A subfunction is a portion of a PCI device that supports multiple
> classes of devices such as netdev, RDMA and more.
> 
> This patchset is based on Leon's series [3].
> It is a third user of proposed auxiliary bus [4].
> 
> Subfunction support is discussed in detail in RFC [1] and [2].
> RFC [1] and extension [2] describes requirements, design, and proposed
> plumbing using devlink, auxiliary bus and sysfs for systemd/udev
> support.

So we're going to have two ways of adding subdevs? Via devlink and via
the new vdpa netlink thing?

Question number two - is this supposed to be ready to be applied to
net-next? It seems there is a conflict.

Also could you please wrap your code at 80 chars?

Thanks.
