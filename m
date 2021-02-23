Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1493322471
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 04:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbhBWDFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 22:05:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:48164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229996AbhBWDFO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 22:05:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D368B64E02;
        Tue, 23 Feb 2021 03:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614049473;
        bh=34LaJk3vKn36fNu7mqiE8/9uAxt0QPP06tXPED4djAs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AnyieTNjG86nuIJ6BfAJQ7ht5i4iCrp5Z6L42eLzJaAzEwvrgpiiRtQ2FpsPaZX5U
         bA91IW7uCSaVPoCdhPpoTQ2ZZ+dbUKbGf48LCRDFpPKfL7/7n0EZF0bvg/CMuBSQjI
         PJkxuyAwflSu+37YjbljBjcRc/QnsWIPhLRtyenqmnBN3P+TupQKTX+TDxgJ7+cDcG
         5QmIglOhbzAqN+eUSF2O0sF+oKk75Sq9bMWj4gtavzWMGXu+sL5FU7vnD5k/KeoRm9
         bUpmX11tR5pSa4dF8zjRtNHfH5suPVpC0fIua1Awq12kTc/filk9B4dePp0hvMvMH4
         7PYYO57WIE3OQ==
Date:   Mon, 22 Feb 2021 19:04:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christian Melki <christian.melki@t2data.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phy: micrel: set soft_reset callback to
 genphy_soft_reset for KSZ8081
Message-ID: <20210222190430.12ec4eda@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <5eb8b25e-f646-ed3d-8572-9b6ef318ae9e@t2data.com>
References: <5eb8b25e-f646-ed3d-8572-9b6ef318ae9e@t2data.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Feb 2021 22:09:32 +0100 Christian Melki wrote:
> Following a similar reinstate for the KSZ9031.
> 
> Older kernels would use the genphy_soft_reset if the PHY did not 
> implement a .soft_reset.
> 
> Bluntly removing that default may expose a lot of situations where 
> various PHYs/board implementations won't recover on various changes.
> Like with implementation during a 4.9.x to 5.4.x LTS transition.
> I think it's a good thing to remove unwanted soft resets but wonder if 
> it did open a can of worms?
> 
> Atleast this fixes one iMX6 FEC/RMII/8081 combo.
> 
> Fixes: 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
> Signed-off-by: Christian Melki <christian.melki@t2data.com>

Does not apply to net/master:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/

Please rebase and resend.

Please make sure you CC maintainers and other relevant developers 
(you can use ./scripts/get_maintainers.pl $path_to_patch to find them).
