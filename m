Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57E6E2A0BC1
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 17:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbgJ3QvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 12:51:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbgJ3QvJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 12:51:09 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E03D20725;
        Fri, 30 Oct 2020 16:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604076669;
        bh=2yuS3dPoBINhat1fzUGcPGhNP/ehJNmVIZDPEmcvgH8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cSMRkTjLBABZ/BOpIqeJA8KfpzG2hpnc2UCNTYVdm2jUbO9IsNkpP3n++pCxCiDBt
         13NSg8ToSZnt5eEtxTzm0WGGagP0+Tziainba3JUxXEVhv1HcNBJwRHb0vGPGXzNdG
         a9tZKo7/lVxYbasbsSY+FoFWr8pz10wlFSh/Ij28=
Date:   Fri, 30 Oct 2020 09:51:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wong Vee Khee <vee.khee.wong@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>
Subject: Re: [PATCH net 1/1] stmmac: intel: Fix kernel panic on pci probe
Message-ID: <20201030095107.3cc31f3b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201029093228.1741-1-vee.khee.wong@intel.com>
References: <20201029093228.1741-1-vee.khee.wong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 17:32:28 +0800 Wong Vee Khee wrote:
> The commit "stmmac: intel: Adding ref clock 1us tic for LPI cntr"
> introduced a regression which leads to the kernel panic duing loading
> of the dwmac_intel module.
> 
> Move the code block after pci resources is obtained.
> 
> Fixes: b4c5f83ae3f3 ("stmmac: intel: Adding ref clock 1us tic for LPI cntr")
> Cc: Voon Weifeng <weifeng.voon@intel.com>
> Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>

Applied, thanks!
