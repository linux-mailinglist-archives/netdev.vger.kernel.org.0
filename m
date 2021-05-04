Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C66737268D
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 09:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhEDH2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 03:28:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229918AbhEDH2M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 03:28:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5649611C0;
        Tue,  4 May 2021 07:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620113237;
        bh=pvoXsQYt7r4KrTOlGw9Xh3GWZuumRq9mZDJ7h74IJNo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m6E3MBB2CCpDjm3FUs4LYcnnUXEGEDTee5UppwJSDyb6mNng0AKWWzUE3aG7Ee21L
         QFOm6vSgtGCaW5D6P9Qngdcx0lXqaaarMhddl5HwrqQqwcMGsV7GBEW/vyOr6JIZJ/
         x6UYViNeYZOIsNoADmTUC8WH5tfD+EJa4wIGXyUDyA41oySg8noeJDvSwtwAOIFjw7
         dmSXHUwTMg6LhSWbSK78u6sbHPmw5sauy812Lm//GAgMYj7j+hOX85W7HiyXoHpICo
         sEGg19HsEvL7KX5GY9E6FgEg2HyfP1l8KEEv3GFwVz+SG1babH4gQRlMYtrCdSAVVw
         9RdCxkU+PSepQ==
Date:   Tue, 4 May 2021 10:27:13 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     kuba@kernel.org, davem@davemloft.net, saeedm@nvidia.com,
        netdev@vger.kernel.org, dingxiaoxiong@huawei.com
Subject: Re: [PATCH net-next v2] net/mlx5e: Fix uninitialised struct field
 moder.comps
Message-ID: <YJD3UQXFJfow86kl@unreal>
References: <1618902026-16588-1-git-send-email-wangyunjian@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <1618902026-16588-1-git-send-email-wangyunjian@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 03:00:26PM +0800, wangyunjian wrote:
> From: Yunjian Wang <wangyunjian@huawei.com>
>=20
> The 'comps' struct field in 'moder' is not being initialized in
> mlx5e_get_def_rx_moderation() and mlx5e_get_def_tx_moderation().
> So initialize 'moder' to zero to avoid the issue.
>=20
> Addresses-Coverity: ("Uninitialized scalar variable")
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> ---
> v2: update mlx5e_get_def_tx_moderation() also needs fixing

Actually grep other all "struct dim_cq_moder ...;" declarations shows
many places like this. Are you going to change them too?

Thanks
