Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30ECC2D20D4
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 03:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgLHC3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 21:29:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:36982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbgLHC3O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 21:29:14 -0500
Date:   Mon, 7 Dec 2020 18:28:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607394513;
        bh=F9mCW68y+BrRPXQAv0Ku05sHJCYmXoJRWpr9w6GJx2I=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=lNMZZP0ggjDdhCxNJ/vr5G2DHfGmMecL3VOFrqEcksIkghEJWOVAiyDdmv8x/U6Ux
         Xvr0xa3vMR8GkoJuw5h9zNmG+138PFDTleSr2qkjBpC3meyh0JMAVGdq/RbawvNoDm
         aM6AqJj1x04g7ldSdsARt5Jnrz4tKngziXVKec+uYaHEDT0NRF1U0cpdCXtqRteHqw
         gSDpai2AaTIF24gOyyJfDpbgBX+P7fRidFgDfPETFmFT6YYOm+m1DY+BlSaIQyyck5
         nyMU9g6g3iTfsrh0L2I3fZGLIIEhPP82zZSzLao0wxJ0NyskZNlXAvZPrEIRLccQOc
         IrROKbGyJEqGA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chris Mi <cmi@nvidia.com>
Cc:     netdev@vger.kernel.org, roid@nvidia.com
Subject: Re: [PATCH net] net: flow_offload: Fix memory leak for indirect
 flow block
Message-ID: <20201207182832.346e246e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201207015916.43126-1-cmi@nvidia.com>
References: <20201207015916.43126-1-cmi@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  7 Dec 2020 09:59:16 +0800 Chris Mi wrote:
> The offending commit introduces a cleanup callback that is invoked
> when the driver module is removed to clean up the tunnel device
> flow block. But it returns on the first iteration of the for loop.
> The remaining indirect flow blocks will never be freed.
> 
> Fixes: 1fac52da5942 ("net: flow_offload: consolidate indirect flow_block infrastructure")
> Signed-off-by: Chris Mi <cmi@nvidia.com>
> Reviewed-by: Roi Dayan <roid@nvidia.com>

Please repost and CC relevant people.

