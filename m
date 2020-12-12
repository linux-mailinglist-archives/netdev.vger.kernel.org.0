Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8EFF2D89F6
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 21:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391830AbgLLU0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 15:26:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:53550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgLLU0A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 15:26:00 -0500
Date:   Sat, 12 Dec 2020 12:25:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607804720;
        bh=3TWsNwx2GEMWi7xdXCw9vFSkyKSH9/nDeEWheML+rDk=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=U4vpsmG5vRLikMTyfFhseSaeogcp5jADDx0iPz7taOWYFvZQaIY7alQrPabopoVE9
         xvRJSJjd4SyXwtvYaIz2Lz1T9FLbohM/HylezxN3q/HGIuOUstiFSxcI3icko406zp
         XEWN8DcukgKOxHA3AKTRP2loZwNSeMaehzVZUeeNOdXXcuH1i8uJ60sdIY1AtQruOS
         Jx198YQ3ffYg1ErJTX2OkW/rVBbyRqpzXWv48M6jzu7+xo7hE2teFjMb/gZZJhkk6e
         qZhnEV8RNfJchVRxVpqK22mQRUtIznWWLw/TH53VJCzqIqhQ3r0wPS9DTbPB4XgWcW
         PFr3knwLYm7zw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        david.m.ertman@intel.com, dan.j.williams@intel.com,
        kiran.patil@intel.com, gregkh@linuxfoundation.org
Subject: Re: [net-next v3 00/14] Add mlx5 subfunction support
Message-ID: <20201212122518.1c09eefe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201212061225.617337-1-saeed@kernel.org>
References: <20201212061225.617337-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Dec 2020 22:12:11 -0800 Saeed Mahameed wrote:
> Hi Dave, Jakub, Jason,
> 
> This series form Parav was the theme of this mlx5 release cycle,
> we've been waiting anxiously for the auxbus infrastructure to make it into
> the kernel, and now as the auxbus is in and all the stars are aligned, I
> can finally submit this V2 of the devlink and mlx5 subfunction support.
> 
> Subfunctions came to solve the scaling issue of virtualization
> and switchdev environments, where SRIOV failed to deliver and users ran
> out of VFs very quickly as SRIOV demands huge amount of physical resources
> in both of the servers and the NIC.
> 
> Subfunction provide the same functionality as SRIOV but in a very
> lightweight manner, please see the thorough and detailed
> documentation from Parav below, in the commit messages and the
> Networking documentation patches at the end of this series.
> 
> Sending V2/V3 as a continuation to V1 that was sent Last month [0],
> [0] https://lore.kernel.org/linux-rdma/20201112192424.2742-1-parav@nvidia.com/

This adds more and more instances of the 32 bit build warning.

The warning was also reported separately on netdev after the recent
mlx5-next pull.

Please address that first (or did you already do and I missed it
somehow?)
