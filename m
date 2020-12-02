Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833D02CC7D6
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 21:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbgLBUcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 15:32:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:34772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgLBUcx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 15:32:53 -0500
Date:   Wed, 2 Dec 2020 12:32:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606941132;
        bh=/rLhiZU87lsc3fpBViXDhoWTtiR1VbHnhQrRIUc8L6A=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=VWSrBlOMEwDy66RFbx+m04YNJW7wtpWciBFIIBQuZpPQEuOFxekZg9Kg67PqF17xI
         /O8rCZKMVHjP6dZ8rnqzaBhoJFE+KHmw+7yMyYPrRMQhyZX+MqrmgtD4nPvhMUGcW5
         Q+2Kg3xAC2l9PbBNZQzb9S0mHAUYu49Gkk7YPpV/auruUBZ4utJRx+HbUwIntr5Uv0
         FXVHva+lQmiBvOAvp7FGkB/lKSAURG0CdvTAQLYnTHKRH6NkLUIZtfIwiJ3XcRvTAC
         VBdDRJzP5kli7HnblL5+n3+Ar9Jo6aa1pIf9zf+T0x2TiHezh+EXy3vbjTw40MGVpy
         dj7zRoffHXyeA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: Re: [pull request][net-next] mlx5 next 2020-12-02
Message-ID: <20201202123211.616d8adb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201202201141.194535-1-saeedm@nvidia.com>
References: <20201202201141.194535-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Dec 2020 12:11:41 -0800 Saeed Mahameed wrote:
> Hi Jakub,
> 
> This pull request includes [1] low level mlx5 updates required by both netdev
> and rdma trees, needed for upcoming mlx5 netdev submission.
> 
> Please pull and let me know if there's any problem.
> 
> [1] https://patchwork.kernel.org/project/linux-rdma/cover/20201120230339.651609-1-saeedm@nvidia.com/

fatal: couldn't find remote ref mlnx/mlx5-next

