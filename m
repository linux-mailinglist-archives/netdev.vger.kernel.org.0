Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5B81E34A
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 15:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbfD2NKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 09:10:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48511 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbfD2NKW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 09:10:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=aYKtvh8CGD4Fir29/5qEcjjZUDlh8MOEt6C5OW0zFX0=; b=lIpDsbuhS8wthEqycJIffIJRuO
        noAYg/gVoDvjB3kzDXFB5oOuLHqiwkTg2k7cdgjY4eGBb2JnpiPCLDXnaFjia2+R48Iwsy8qFhZlS
        wSGaJOkLXAzvsPAN1c/qksACWcdG9JeCJYmRSDuqj0xzJX/lsDzIBbeAU3K9118YoijA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hL62y-0000qn-7g; Mon, 29 Apr 2019 15:10:16 +0200
Date:   Mon, 29 Apr 2019 15:10:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Ong, Boon Leong" <boon.leong.ong@intel.com>
Cc:     "Voon, Weifeng" <weifeng.voon@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>
Subject: Re: [PATCH 0/7] net: stmmac: enable EHL SGMII
Message-ID: <20190429131016.GE10772@lunn.ch>
References: <1556126241-2774-1-git-send-email-weifeng.voon@intel.com>
 <20190424134854.GP28405@lunn.ch>
 <D6759987A7968C4889FDA6FA91D5CBC8146EF128@PGSMSX103.gar.corp.intel.com>
 <20190425123801.GD8117@lunn.ch>
 <AF233D1473C1364ABD51D28909A1B1B75C0B205D@pgsmsx114.gar.corp.intel.com>
 <20190425152332.GD23779@lunn.ch>
 <AF233D1473C1364ABD51D28909A1B1B75C0B8B35@pgsmsx114.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AF233D1473C1364ABD51D28909A1B1B75C0B8B35@pgsmsx114.gar.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Sorry for the delay, we have checked with hardware/SoC HW architect
> and gotten confirmation that the controller can only support SGMII inter-chip
> connection. It does not support 1000Base-X. 

O.K, i'm surprised about that, but if that is what the hardware
engineer says...

> In this case, we believe that the current implementation of the DW xPCS
> are sufficient. Ok?

Yes, if all i can do is SGMII, hard coding SGMII is fine. But you
should probably check phy-mode and return an error if it has a value
other than SGMII,

      Andrew
