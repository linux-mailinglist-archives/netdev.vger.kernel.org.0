Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 993A22F8FFE
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 02:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbhAQBAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 20:00:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:51998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726788AbhAQA74 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Jan 2021 19:59:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 297F722BEA;
        Sun, 17 Jan 2021 00:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610845155;
        bh=tSvaCGk0aGCNFtliffn2jp5B4ukLkm0tvq5XS8ex8ms=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gobF7UkZ6zQb7p6QOThEsdi2tUKlW+6yOgTW721zh8mn/M0OmYbuIQcKbWHxpBmub
         31ZxlQgLccAavCrPdPeqvk2z4zMPR1tbi9xtiY3r3QzA7gXmUZyL3856d0odD6w2AU
         urKIdPrGaikuDtLUHipcnhiXbhkW8zSC49wgVgEePupvomUQ9jFr+SuocseRoh3Gbf
         MrnJclJJdgFdmhDnD6vO8VRD2i16xzKxsJyg6GXbuZ+JWhNVk3vLMqKnugAauaZ21j
         EGFXLf094z5XiyxHdafrOaGavgxbCodtvA1yIQdURqCmNxQcz2mjFvjEe43L/voBHR
         XbspO/7N4mmyg==
Date:   Sat, 16 Jan 2021 16:59:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jan Kiszka <jan.kiszka@siemens.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Wong Vee Khee <vee.khee.wong@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH net-next 1/1] stmmac: intel: change all EHL/TGL to auto
 detect phy addr
Message-ID: <20210116165914.31b6ca5f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <bf5170d1-62a9-b2dc-cb5a-d568830c947a@siemens.com>
References: <20201106094341.4241-1-vee.khee.wong@intel.com>
        <bf5170d1-62a9-b2dc-cb5a-d568830c947a@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 16 Jan 2021 10:12:21 +0100 Jan Kiszka wrote:
> On 06.11.20 10:43, Wong Vee Khee wrote:
> > From: Voon Weifeng <weifeng.voon@intel.com>
> > 
> > Set all EHL/TGL phy_addr to -1 so that the driver will automatically
> > detect it at run-time by probing all the possible 32 addresses.
> > 
> > Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
> > Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
> 
> This fixes PHY detection on one of our EHL-based boards. Can this also
> be applied to stable 5.10?

Sure.

Greg, we'd like to request a backport of the following commit to 5.10.

commit bff6f1db91e330d7fba56f815cdbc412c75fe163
Author: Voon Weifeng <weifeng.voon@intel.com>
Date:   Fri Nov 6 17:43:41 2020 +0800

    stmmac: intel: change all EHL/TGL to auto detect phy addr
    
    Set all EHL/TGL phy_addr to -1 so that the driver will automatically
    detect it at run-time by probing all the possible 32 addresses.
    
    Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
    Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
    Link: https://lore.kernel.org/r/20201106094341.4241-1-vee.khee.wong@intel.com
    Signed-off-by: Jakub Kicinski <kuba@kernel.org>


It's relatively small, and Jan reports it makes his boards detect the
PHY. The change went in via -next and into Linus's tree during the 5.11
merge window.
