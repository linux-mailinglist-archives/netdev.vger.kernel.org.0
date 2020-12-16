Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350B62DB7FE
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 01:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgLPAvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 19:51:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:47476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726249AbgLPAvv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 19:51:51 -0500
Date:   Tue, 15 Dec 2020 16:51:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608079871;
        bh=rX9HHzUQr+MIJ30jJtLtvWObzFw22Z26MuY/Sq/yN9Q=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=qNJBJYnTMpzXUepuib/PoaPgQcEAP+YPxd+AnQVWSoRr4NALrwjbth4/DyGA/yccP
         0V2ccMct5bKg5ccPpe3Kjkpo9uKILderqmcexFeh2UuNML1cEYxegAKWTn2yl/uPKF
         uaHdAZtvh2jup8t5UUVhbAntUoSvnyc4Sz/yJqKc4inSEb3PKq66cLpd/ZdwJBw3i3
         dwtdUo6ukfnzNg/be3vX64AUvontO+cIy/gh3DnJ2nihFR1RMyrpziCofRiLoRsyxt
         swmwCmufU95RhgCkAFFB+CkE2Xp+/CxVlI3WCvqY5XiWPOoFGt/o9aEQGMLGCRCDH1
         +FgvZIHN04gBg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        david.m.ertman@intel.com, dan.j.williams@intel.com,
        kiran.patil@intel.com, gregkh@linuxfoundation.org,
        Parav Pandit <parav@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next v5 11/15] net/mlx5: SF, Add port add delete
 functionality
Message-ID: <20201215165109.27906764@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201215090358.240365-12-saeed@kernel.org>
References: <20201215090358.240365-1-saeed@kernel.org>
        <20201215090358.240365-12-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Dec 2020 01:03:54 -0800 Saeed Mahameed wrote:
> To handle SF port management outside of the eswitch as independent
> software layer, introduce eswitch notifier APIs so that upper layer who
> wish to support sf port management in switchdev mode can perform its

Could you unpack this? What's the "upper layer" software in this
context?

> task whenever eswitch mode is set to switchdev or before eswitch is
> disabled.

How does SF work if eswich is disabled?

> Initialize sf port table on such eswitch event.
> 
> Add SF port add and delete functionality in switchdev mode.
> Destroy all SF ports when eswitch is disabled.
> Expose SF port add and delete to user via devlink commands.
