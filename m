Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1504C2313D4
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbgG1U0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:26:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728346AbgG1U0U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 16:26:20 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FBA52065E;
        Tue, 28 Jul 2020 20:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595967979;
        bh=k5R+o6YF2wW6JKZMtxoqIQ5Qj6vJtCVCYnXpnaEQ7rQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NFTlcjgzoX2/WM3YGuUVxEdCgv/jLhxx+jtDlH0zLa2a7TwODRPvEh9timTeZhBCn
         YUoupoB3YP3DCsgjch/SGPUB6eSGCl8zEtVfdAKDIZ5VJb+HGJ5mYUmgvzBS2nZ3uO
         IPu5NMfeyKzU7enk2uf31mdlvU9KF0JCD2GBdXAo=
Date:   Tue, 28 Jul 2020 13:26:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Jiri Pirko <jiri@mellanox.com>
Subject: Re: [net-next 06/13] net/mlx5e: Link non uplink representors to PCI
 device
Message-ID: <20200728132617.4e145997@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200728094411.116386-7-saeedm@mellanox.com>
References: <20200728094411.116386-1-saeedm@mellanox.com>
        <20200728094411.116386-7-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jul 2020 02:44:04 -0700 Saeed Mahameed wrote:
> In past there was little concern over seeing 10,000 lines output
> showing up at thread [1] is not applicable as ndo ops for VF
> handling is not exposed for all the 100 repesentors for mlx5 devices.

wasn't libvirt picking the netdev to run the vf ops on basically at
random, though?
