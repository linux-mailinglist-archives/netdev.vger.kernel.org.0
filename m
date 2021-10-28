Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6383943E4F8
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 17:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhJ1PYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 11:24:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230017AbhJ1PYe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 11:24:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 164A260724;
        Thu, 28 Oct 2021 15:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635434527;
        bh=7936Cz/bcS/ey7mkaQy6b0gaE1gu9Zt1qTDCbVN0+yM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ll/cyVxhDuWAyfOteRg04jE577LvRXl/FQJa2OxpETHMyILrawj2sjo3aHM4n3NeW
         cJ86PpX1hjPJUPDfilywC+YGfO45PRPTE3CeKurad7RJYmH6zUQSNsBDnT1DNGPh9G
         pyA0qvoFmIxUSbOnDSCzcnyp+bmCgmmGfs2Zs/8oTbwL1YDNB8w69Xekrv12HYQx9z
         pDW4ejLEUFvPOqbHvfgBWSeN41GwRatF0CHuine1AZB/THaB9JmrGE3D/kZAiirZy1
         Khdftk5YjBX1JxJwAlk3vMfs6WI522sg/yV+cWFl3w/E9HoJFroKFP5gvmOyGElHX6
         1hdOXoO6G6hCw==
Date:   Thu, 28 Oct 2021 08:22:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [pull-request][net-next] Merge mlx5-next into net-next
Message-ID: <20211028082206.3690e760@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211028052104.1071670-1-saeed@kernel.org>
References: <20211028052104.1071670-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Oct 2021 22:21:04 -0700 Saeed Mahameed wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> Hi Dave, Jakub,
> 
> This pull request provides a single merge commit of mlx5-next into net-next
> which handles a non-trivial conflict.
> 
> The commits from mlx5-next provide MR (Memory Region) Memory Key
> management cleanup in mlx5 IB driver and mlx5 core driver [1].
> 
> Please pull and let me know if there's any problem.
> 
> [1] https://patchwork.kernel.org/project/netdevbpf/cover/cover.1634033956.git.leonro@nvidia.com/
> 
> Thanks,
> Saeed.
> 
> -- 

FWIW the PR is fumbled a little bit and the actual contents are in the
footer. But Dave has pulled so all good. Just noting this for the
future cause I think that's why we missed the pw bot's auto-response.
