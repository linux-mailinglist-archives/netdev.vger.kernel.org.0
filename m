Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0007543B789
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 18:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237540AbhJZQuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 12:50:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237530AbhJZQuY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 12:50:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C95060F56;
        Tue, 26 Oct 2021 16:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635266880;
        bh=xRaWeA3yziiQOEpBqiJyRp/na5u/5z3Y+66B0zkiT3E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WzOJ/Iqgm/lLPUoPy2wU3RCyNvV9OvAgN3jD0XNE3Jo/HiAbL0MLENf1L1XjsGtMw
         9nTQOq+v2D2L9/of18KKfF0BVfU4Ux1GnsBQG+YRRo06Nq0U6O2+8P/4iL77UwPwVY
         602Tz/6dsCIBreMUn5dtOR2p0W9GA8mHBuyNW92jWX9zt5+NwPPcmMxNN2jFxyhyWC
         jc5vECRy466B4IBURqWHrREDiXHSPhjg3Rb9n4lWjds8MgfasDemO8YB62K8aTpTVP
         m2wjaT+oibdopcb4Z4Rtcje/tLeKIsJwjQs+D6S/RB+qWsWrEgjMWpLy0WUiK21HuM
         Q6knKY724ldxg==
Date:   Tue, 26 Oct 2021 09:47:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     <davem@davemloft.net>, <saeedm@nvidia.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net/mlx5: remove the recent devlink params
Message-ID: <20211026094759.1282b7cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YXgwlsyGtK8qZfHj@unreal>
References: <20211026152939.3125950-1-kuba@kernel.org>
        <YXgwlsyGtK8qZfHj@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Oct 2021 19:45:10 +0300 Leon Romanovsky wrote:
> On Tue, Oct 26, 2021 at 08:29:39AM -0700, Jakub Kicinski wrote:
> > revert commit 46ae40b94d88 ("net/mlx5: Let user configure io_eq_size param")
> > revert commit a6cb08daa3b4 ("net/mlx5: Let user configure event_eq_size param")
> > revert commit 554604061979 ("net/mlx5: Let user configure max_macs param")
> > 
> > The EQE parameters are applicable to more drivers, they should
> > be configured via standard API, probably ethtool. Example of
> > another driver needing something similar:
> > 
> > https://lore.kernel.org/all/1633454136-14679-3-git-send-email-sbhatta@marvell.com/
> > 
> > The last param for "max_macs" is probably fine but the documentation
> > is severely lacking. The meaning and implications for changing the
> > param need to be stated.
> > 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > 
> > LocalWords:  EQE param  
> 
> Your emacs config sneaked out.

I know, sorry, removed when applying.
