Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704FA3DBBC6
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 17:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239408AbhG3PLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 11:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238909AbhG3PLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 11:11:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C13DC06175F;
        Fri, 30 Jul 2021 08:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=z+rTA/ObrOOYDpgQnhNyZXPSqPg3dMUwZ39219bYFYE=; b=pQPFmm2qtpvBeXzSGuCG99sBt
        GnAGGc3nmRVTeaMDX0ptT6QyXrrsVMC3YPYeq7BbDYWf8LSVVStBzyo6PeSlpHP+cwLMLs3qSokbY
        mWVW9W+CkFnNLGC7lAPqURjvqzPxwLAbpEXxHTWw6x6HFYF4CIbXoKjwYDNZcKnwaCWOK6rc90HuS
        sZW4F72+P1xJiu4DYVhAA3M0ymOAPljHsawH26xKEUOHD+LU375LfiP64tg7wKuZ2eH8TXDJ+huH1
        4va2I0Pw4fD/9S82qUiZFZtrmkP7CAExq+cFks2Vxkn9QZUWvKvob+NvqphJgs4j7V4WCirUcRJIE
        zAnmj/2Ww==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46762)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1m9UAZ-0002eP-Rr; Fri, 30 Jul 2021 16:11:27 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1m9UAX-00005c-3y; Fri, 30 Jul 2021 16:11:25 +0100
Date:   Fri, 30 Jul 2021 16:11:25 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Daniel Walker <danielwa@cisco.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Balamurugan Selvarajan <balamsel@cisco.com>,
        xe-linux-external@cisco.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC-PATCH] net: stmmac: Add KR port support.
Message-ID: <20210730151124.GH22278@shell.armlinux.org.uk>
References: <20210729234443.1713722-1-danielwa@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729234443.1713722-1-danielwa@cisco.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 04:44:42PM -0700, Daniel Walker wrote:
> From: Balamurugan Selvarajan <balamsel@cisco.com>
> 
> For KR port the mii interface is a chip-to-chip
> interface without a mechanical connector. So PHY
> inits are not applicable. In this case MAC is
> configured to operate at forced speed(1000Mbps)
> and full duplex. Modified driver to accommodate
> PHY and NON-PHY mode.

Can we clarify exactly what you are talking about here. What does
"KR port" refer to? What protocol is spoken by this port? Is it
1000BASE-KX (1000BASE-X over backplane)? Does it include 10GBASE-KR?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
