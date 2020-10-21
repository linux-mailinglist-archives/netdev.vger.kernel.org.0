Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F03294715
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 05:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411876AbgJUD4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 23:56:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406735AbgJUD4u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 23:56:50 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F8B121741;
        Wed, 21 Oct 2020 03:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603252609;
        bh=XBGNkaYEUqlMFMVtbOPtDEIt72DqySZrBEAbtk/WssY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E8XjB3dAbYeiUgwvMORYBfO8EloEGDBXwEcgT9T0qXp0rkvzDtpREpia2yYO9/2mJ
         lxMjwxE/i6yzA6kfG1dHF48tWBJHivX8KNFDtgCT2i8k6uUrUUm21bYjRqFSszJ2No
         r1grpg3zlJ/XVbMGhIs4zob2RuajikrN0RpPR1Ts=
Date:   Tue, 20 Oct 2020 20:56:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Peter Krystad <peter.krystad@linux.intel.com>,
        netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mptcp: MPTCP_IPV6 should depend on IPV6 instead of
 selecting it
Message-ID: <20201020205647.20ab7009@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <5dddd3fe-86d7-d07f-dbc9-51b89c7c8173@tessares.net>
References: <20201020073839.29226-1-geert@linux-m68k.org>
        <5dddd3fe-86d7-d07f-dbc9-51b89c7c8173@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 11:26:34 +0200 Matthieu Baerts wrote:
> On 20/10/2020 09:38, Geert Uytterhoeven wrote:
> > MPTCP_IPV6 selects IPV6, thus enabling an optional feature the user may
> > not want to enable.  Fix this by making MPTCP_IPV6 depend on IPV6, like
> > is done for all other IPv6 features.  
> 
> Here again, the intension was to select IPv6 from MPTCP but I understand 
> the issue: if we enable MPTCP, we will select IPV6 as well by default. 
> Maybe not what we want on some embedded devices with very limited memory 
> where IPV6 is already off. We should instead enable MPTCP_IPV6 only if 
> IPV6=y. LGTM then!
> 
> Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Applied, thanks!
