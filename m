Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2D5438251
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 10:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbhJWIVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 04:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbhJWIVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 04:21:46 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B270FC061764;
        Sat, 23 Oct 2021 01:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=JWYazItGGDmxB3tlCZwxquRKPod4Oq86y096NCBmtDA=; b=0BOyAcQ7YXM1XCoGZnUqYY1gQa
        pr0MuZVpOz5yJUiRHTr/nv52T9U431VthHWOIo6YCmXDm+q4qcrAPKN08ppjYzi8oH/69/rPoHBn+
        sJIiHvEgttWn0CHaRX30XAiDYAijD33khmEGKvdwp3HmpaTOIFj+PcQYR3qsWTDAnDY9gF4+BnZsT
        F7u+yUZx+JwKZEh1MmuFkH7iLZ4D4+hzYSlC0oyYkfYWDDbLVIDW0nH8rUtdpNNrRTbhX2LMmIvoZ
        UjtxI0nK8go0sG2Ga0Wp9ZL2NyTp2ZtKqJtcCgiSw5/Px1XpZ8ljzH47XVTO8GASqUMtzR2mKkh51
        6oVwVI3g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55250)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1meCFK-0002Uk-Op; Sat, 23 Oct 2021 09:19:18 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1meCFI-0001xk-Ta; Sat, 23 Oct 2021 09:19:16 +0100
Date:   Sat, 23 Oct 2021 09:19:16 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jie Luo <quic_luoj@quicinc.com>
Cc:     Luo Jie <luoj@codeaurora.org>, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org
Subject: Re: [PATCH v4 01/14] net: phy: at803x: replace AT803X_DEVICE_ADDR
 with MDIO_MMD_PCS
Message-ID: <YXPFhJHpfPHNbKKd@shell.armlinux.org.uk>
References: <20211022120624.18069-1-luoj@codeaurora.org>
 <20211022120624.18069-2-luoj@codeaurora.org>
 <YXKq6j/CnQ/i34ZB@shell.armlinux.org.uk>
 <c943c86e-bbd9-746a-cfda-647b31af337f@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c943c86e-bbd9-746a-cfda-647b31af337f@quicinc.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 23, 2021 at 09:53:15AM +0800, Jie Luo wrote:
> 
> On 10/22/2021 8:13 PM, Russell King (Oracle) wrote:
> > On Fri, Oct 22, 2021 at 08:06:11PM +0800, Luo Jie wrote:
> > > Replace AT803X_DEVICE_ADDR with MDIO_MMD_PCS defined in mdio.h.
> > > 
> > > Signed-off-by: Luo Jie <luoj@codeaurora.org>
> > On v3, Andrew gave you a reviewed-by. You need to carry those forward
> > especially if the patches have not changed.
> > 
> > Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Thanks Russell for this reminder, will follow it.

But, from what I can tell, you still haven't followed it in your v5
posting either.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
