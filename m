Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5177D2CFEF4
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 21:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgLEUyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 15:54:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:54570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725270AbgLEUyc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 15:54:32 -0500
Date:   Sat, 5 Dec 2020 12:53:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607201632;
        bh=uUWQNjkzP7jsDA3hiG3fn47VNCNDg6puRbpmbUSoqew=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=XjLCieWXIm6u9BddBMaTSLjRjSBqYozZZtAuX4WYNSgGOXBggGw8bQpNXPv4mCFkx
         aJVrWlp0Y4044T/EwN1cyjYjsHfe5S48jhYbjkX3GjJLoA5akyMU8ZYn7fEJC46TFL
         oNf8l5w+376M2S+L39d1/Jv9YsOyH8omIEnsPi3A3YGfXdIp3z1IJsAuXlWIPpsDoh
         Yov5Hh5MsUQZih8EIlQ6fKakYy5AWIwEwp6mXeENpv/0PQtHfojcpfz+AcbS3viH89
         vUV7ZsgC0V3/fyF6A309vg4zjwek9xtHUpT38hiYneb7CVmvwOnQsCI36tZkRqMJEO
         /rMzuG1EiWr7A==
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
Message-ID: <20201205125351.41e89579@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  5 Dec 2020 20:17:23 +0100 Rasmus Villemoes wrote:
> While trying to figure out how to allow bumping the MTU with the
> ucc_geth driver, I fell into a rabbit hole and stumbled on a whole
> bunch of issues of varying importance - some are outright bug fixes,
> while most are a matter of simplifying the code to make it more
> accessible.
> 
> At the end of digging around the code and data sheet to figure out how
> it all works, I think the MTU issue might be fixed by a one-liner, but
> I'm not sure it can be that simple. It does seem to work (ping -s X
> works for larger values of X, and wireshark confirms that the packets
> are not fragmented).
> 
> Re patch 2, someone in NXP should check how the hardware actually
> works and make an updated reference manual available.

Looks like a nice clean up on a quick look.

Please separate patches 1 and 11 (which are the two bug fixes I see)
rebase (retest) and post them against the net tree:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/

so they are available for backports.

The reset should go into net-next:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/

Please indicate the tree in the tag like [PATCH net] or [PATCH
net-next] so the test bots know which base to use for testing.

Thanks!
