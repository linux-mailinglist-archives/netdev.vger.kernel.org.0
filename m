Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D469C2CFF36
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 22:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgLEV16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 16:27:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:37884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726173AbgLEV16 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 16:27:58 -0500
Date:   Sat, 5 Dec 2020 13:27:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607203637;
        bh=FD4PyLI/19p+zpfFll8rCI/9aR2mAR3+g29XkXnp8fg=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=TTX4lDSWJHCfeyKYmYD9VrgrqASPFYttBYRKKTns5roGvSnFK3Kq5CoKFGaPAR1hL
         G2QRaExRTzQMCPRCXh3Di3nJWQiZsvKKesb5zgry6C+j3XHay2YgZaSbJA/Rz6/GdL
         wqGIf4q7Rj7I816+wSsVd4rdJPLFOBlA8zmtp0heGz5DcD8FYqWuff6RFCb/meZCEB
         NQgnzrJvmNXJ4C93auUBsON/ISUhtdyHQrBPReZw/UYgC21OYyn8oIlihZ8FUscYsT
         Ey6OMIKZj3Q856OKy99W7lWinZA0ryZzXwxbGp7QesIxYBJv6CZ8XXkDEryf4Z+ozv
         scwKn5k/YSwHQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Qiang Zhao <qiang.zhao@nxp.com>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH 00/20] ethernet: ucc_geth: assorted fixes and
 simplifications
Message-ID: <20201205132716.4c68e35d@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <7e78df84-0035-6935-acb0-adbd0c648128@prevas.dk>
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
        <20201205125351.41e89579@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <7e78df84-0035-6935-acb0-adbd0c648128@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 5 Dec 2020 22:11:39 +0100 Rasmus Villemoes wrote:
> > Looks like a nice clean up on a quick look.
> > 
> > Please separate patches 1 and 11 (which are the two bug fixes I see)  
> 
> I think patch 2 is a bug fix as well, but I'd like someone from NXP to
> comment.

Sure, makes sense.

> > rebase (retest) and post them against the net tree:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/  
> 
> So I thought this would go through Li Yang's tree. That's where my
> previous QE related patches have gone through, and at least some need
> some input from NXP folks - and what MAINTAINERS suggests. So not
> marking the patches with net or net-next was deliberate. But I'm happy
> to rearrange and send to net/net-next as appropriate if that's what you
> and Li Yang can agree to.

Ah, now I noticed you didn't CC all of the patches to netdev.
Please don't do that, build bots won't be able to validate partially
posted patches.
