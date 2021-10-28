Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAFD43E476
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 16:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbhJ1PBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 11:01:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231460AbhJ1PBD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 11:01:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21CC6610F8;
        Thu, 28 Oct 2021 14:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635433116;
        bh=rxxyEmN2uszr+vqqocUQm+iO6p+MV6wqE7VBwDbAgYA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J4eO3CBYiHs+nKKef5BHHL5oNafSyOvhatcM5yK3jzuFivkWEThroi3D/qrnhjt3M
         vGbsztbQ1U8lG6VcZtxaKrxGV7Pfo/S7FZmwOkdF2MhIQi2GUarRx/PMQ0auxeu+mS
         4e3V2CAV59F/nNr/Fqfw90dGE2wprQmeKR3MgzSzlgM8iLl977Q41MDSK8nIEjzPD8
         IWOxVwyLB5Iq7Nba8SEx4kQ77invoSByiTdAeqRV47GWhqYx+eIcAhzlbM5P90E31B
         YmzVCNm5fQgDbg6gxuiBOM4fBXDd9XDm4+dU2bnmYed//tfHnmu9XBaOvIAeAe1kD0
         +klc6NmXD/GQA==
Date:   Thu, 28 Oct 2021 07:58:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yu Xiao <yu.xiao@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Niklas Soderlund <niklas.soderlund@corigine.com>
Subject: Re: [PATCH net v2] nfp: bpf: relax prog rejection for mtu check
 through max_pkt_offset
Message-ID: <20211028075835.7121120c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211028100036.8477-1-simon.horman@corigine.com>
References: <20211028100036.8477-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Oct 2021 12:00:36 +0200 Simon Horman wrote:
> From: Yu Xiao <yu.xiao@corigine.com>
> 
> MTU change is refused whenever the value of new MTU is bigger than
> the max packet bytes that fits in NFP Cluster Target Memory (CTM).
> However, an eBPF program doesn't always need to access the whole
> packet data.
> 
> The maximum direct packet access (DPA) offset has always been
> caculated by verifier and stored in the max_pkt_offset field of prog
> aux data.
> 
> Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
> Reviewed-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> Reviewed-by: Niklas Soderlund <niklas.soderlund@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>

Looks fine, not sure why it's tagged for net but okay..
