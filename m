Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58AD2F92EF
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 15:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729286AbhAQO3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 09:29:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:42370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729020AbhAQO3N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Jan 2021 09:29:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C622620780;
        Sun, 17 Jan 2021 14:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610893712;
        bh=/iaUtXukjseA0MPCRHEhZWtUgZwzUkRsfeEOpJOlCVc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nUBmS2dk0WwuwCLSXdd9Eap9MY8buro+D29BEkMQp9ZLDYcrE+LnafbTlSDPEQYoj
         6RGlIPP5r5POfvwtxUr5PZP51isArHJsElYi7keNS3/5nEXsQO3ULua3OT6WyKuRoB
         nLWjId4Wk8bNMV/YBFGTPTXI/m0COaBf5NU3ZdDQ=
Date:   Sun, 17 Jan 2021 15:28:29 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jan Kiszka <jan.kiszka@siemens.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
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
Message-ID: <YARJjWvNL2HOZx9Y@kroah.com>
References: <20201106094341.4241-1-vee.khee.wong@intel.com>
 <bf5170d1-62a9-b2dc-cb5a-d568830c947a@siemens.com>
 <20210116165914.31b6ca5f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210116165914.31b6ca5f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 16, 2021 at 04:59:14PM -0800, Jakub Kicinski wrote:
> On Sat, 16 Jan 2021 10:12:21 +0100 Jan Kiszka wrote:
> > On 06.11.20 10:43, Wong Vee Khee wrote:
> > > From: Voon Weifeng <weifeng.voon@intel.com>
> > > 
> > > Set all EHL/TGL phy_addr to -1 so that the driver will automatically
> > > detect it at run-time by probing all the possible 32 addresses.
> > > 
> > > Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
> > > Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
> > 
> > This fixes PHY detection on one of our EHL-based boards. Can this also
> > be applied to stable 5.10?
> 
> Sure.
> 
> Greg, we'd like to request a backport of the following commit to 5.10.
> 
> commit bff6f1db91e330d7fba56f815cdbc412c75fe163
> Author: Voon Weifeng <weifeng.voon@intel.com>
> Date:   Fri Nov 6 17:43:41 2020 +0800
> 
>     stmmac: intel: change all EHL/TGL to auto detect phy addr
>     
>     Set all EHL/TGL phy_addr to -1 so that the driver will automatically
>     detect it at run-time by probing all the possible 32 addresses.
>     
>     Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
>     Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
>     Link: https://lore.kernel.org/r/20201106094341.4241-1-vee.khee.wong@intel.com
>     Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> 
> It's relatively small, and Jan reports it makes his boards detect the
> PHY. The change went in via -next and into Linus's tree during the 5.11
> merge window.

Now queued up, thanks.

greg k-h
