Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A39D20626D
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404256AbgFWVA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 17:00:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:60940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391290AbgFWVAy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 17:00:54 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31A9420663;
        Tue, 23 Jun 2020 21:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592946054;
        bh=0VkKxmMXx/LOiZQqragEZRQnuQ6M8Kdu7DyUmp2S9Kg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KW5Q7Rrp8onp2EJIz8FD3SiHrGSeFKz+YZUd60/xHVxkvQhBhIuvIKZRG3cBHRf/0
         6dCevkqiJjg2BpeZGMRuFcvbaCcAZtq7M46KFYogTHU1aRO1RaWARwHfh2ASVEMVJZ
         RC3vW+JLCyNFV89gavZQRqfJgNJS5r45LyEUQziU=
Date:   Tue, 23 Jun 2020 14:00:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Parav Pandit <parav@mellanox.com>
Subject: Re: [net-next 01/10] net/mlx5: Avoid eswitch header inclusion in fs
 core layer
Message-ID: <20200623140052.43913f80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200623195229.26411-2-saeedm@mellanox.com>
References: <20200623195229.26411-1-saeedm@mellanox.com>
        <20200623195229.26411-2-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jun 2020 12:52:20 -0700 Saeed Mahameed wrote:
> From: Parav Pandit <parav@mellanox.com>
> 
> Flow steering core layer is independent of the eswitch layer.
> Hence avoid fs_core dependency on eswitch.
> 
> Fixes: 328edb499f99 ("net/mlx5: Split FDB fast path prio to multiple namespaces")

A little liberal on the use of fixes tag here...

> Signed-off-by: Parav Pandit <parav@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
