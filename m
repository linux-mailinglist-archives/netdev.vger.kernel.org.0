Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAD21A5FA2
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 19:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbgDLR7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 13:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:38938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727190AbgDLR7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 13:59:42 -0400
X-Greylist: delayed 527 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Apr 2020 13:59:42 EDT
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1AE2C0A3BF7;
        Sun, 12 Apr 2020 10:59:42 -0700 (PDT)
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FB34206DA;
        Sun, 12 Apr 2020 17:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586714382;
        bh=8tkHbA61wjiG7DNp5xOrMq1CJ/6A62xfaIaq4VvIp8U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jM2oCETVhtPPaYIz9kSFzFw/9h0X2wsg/u5sWQ4J5Ry/LcJgvgoQf5sgIgcxtyqey
         DBRSJGA147pXU6e6dmuJ2UcA+cZ3Bb10hU8Ri5oEtHN7b0zaCqLNL/XgiHWR7Db+yM
         nV5pTcl+IAD/q0U6dByJK4NRrt3So9Yr2QxI4KFQ=
Date:   Sun, 12 Apr 2020 10:59:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, Stable <stable@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Message-ID: <20200412105935.49dacbf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAJ3xEMhhtj77M5vercHDMAHPPVZ8ZF-eyCVQgD4ZZ1Ur3Erbdw@mail.gmail.com>
References: <20200411231413.26911-1-sashal@kernel.org>
        <20200411231413.26911-9-sashal@kernel.org>
        <CAJ3xEMhhtj77M5vercHDMAHPPVZ8ZF-eyCVQgD4ZZ1Ur3Erbdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Apr 2020 10:10:22 +0300 Or Gerlitz wrote:
> On Sun, Apr 12, 2020 at 2:16 AM Sasha Levin <sashal@kernel.org> wrote:
> 
> > [ Upstream commit 6783e8b29f636383af293a55336f036bc7ad5619 ]  
> 
> Sasha,
> 
> This was pushed to net-next without a fixes tag, and there're probably
> reasons for that.
> As you can see the possible null deref is not even reproducible without another
> patch which for itself was also net-next and not net one.
> 
> If a team is not pushing patch to net nor putting a fixes that, I
> don't think it's correct
> to go and pick that into stable and from there to customer production kernels.
> 
> Alsom, I am not sure what's the idea behind the auto-selection concept, e.g for
> mlx5 the maintainer is specifically pointing which patches should go
> to stable and
> to what releases there and this is done with care and thinking ahead, why do we
> want to add on that? and why this can be something which is just
> automatic selection?
> 
> We have customers running production system with LTS 4.4.x and 4.9.y (along with
> 4.14.z and 4.19.w) kernels, we put lots of care thinking if/what
> should go there, I don't
> see a benefit from adding auto-selection, the converse.

FWIW I had the same thoughts about the nfp driver, and I indicated to
Sasha to skip it in the auto selection, which AFAICT worked nicely.

Maybe we should communicate more clearly that maintainers who carefully
select patches for stable should opt out of auto-selection?
