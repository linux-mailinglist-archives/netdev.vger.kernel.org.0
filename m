Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEEE49BAFA
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 19:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242561AbiAYSIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 13:08:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36316 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243976AbiAYSHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 13:07:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44AB7B817EF;
        Tue, 25 Jan 2022 18:07:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6BBC340E0;
        Tue, 25 Jan 2022 18:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643134072;
        bh=qaTTedUmiE2cBTM4T25L/uUOErgonKVsicfShCcszvQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lCB8p4DldybUAkBa3OuP43iCxZa5o3+R+JntgcIwMGWQZrJ73FygylJxULwg8q3zC
         Rvv1KPxdv9pu3gYIb6lA8Ri5XhEtB0Nb7Dn4F7zu+sSo8MhFdElcLujzF4oNZzYVDk
         utJKm2tpQYSh4UODm4QzKw/JfPYVCHoKQTP4bYPVLqhZkMeW2P9Szd1ZkLUwcIOQfl
         I7UJgSvUv4pQmldfMdtsbb59tSxOQdJMiF3pgI8Q419z0ttCAkj/hchPCeNU81WQad
         048f+lybIPO15j1zSqw0hJtx3Hsk13eMtBlbfkax5SttBImWRDuzO5B2cN8tWp0WAm
         CCoFlMoKtKCgw==
Date:   Tue, 25 Jan 2022 10:07:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Qing Deng <i@moy.cat>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ip6_tunnel: allow routing IPv4 traffic in NBMA mode
Message-ID: <20220125100750.0bae1acf@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220123060000.GA12551@devbox>
References: <20220123060000.GA12551@devbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 23 Jan 2022 14:00:00 +0800 Qing Deng wrote:
> Since IPv4 routes support IPv6 gateways now, we can route IPv4 traffic in
> NBMA tunnels.
> 
> Signed-off-by: Qing Deng <i@moy.cat>

Applied, thanks, c1f55c5e0482 ("ip6_tunnel: allow routing IPv4 traffic
in NBMA mode")  in net-next.
