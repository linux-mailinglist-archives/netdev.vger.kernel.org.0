Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7611858362
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 15:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfF0NXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 09:23:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36864 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726059AbfF0NXq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 09:23:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YQ7gws/dqiX/pzMEyAxyz7EX2o9K76GCX0QLcUGDgjI=; b=XKqE2KQFh6uecMLlvM0rTZeSe4
        bxXc57Bx0I0Tf3Ho1ElG8UN1Av7cAWmJypKbKY/OfhZPCtQ6QBMoIYiCV4zu5ln/rW7MtenAhe8Ia
        Bsb9cIs9xAw+VjE4QKPV5JybtSM5aHuZ0GmSRSQtEkxSi3tt6aYDT4wxXlSCb1xafYiQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hgUNI-0008Il-Ir; Thu, 27 Jun 2019 15:23:40 +0200
Date:   Thu, 27 Jun 2019 15:23:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: Re: [PATCH net-next 10/10] net: stmmac: Try to get C45 PHY if
 everything else fails
Message-ID: <20190627132340.GC31189@lunn.ch>
References: <cover.1561556555.git.joabreu@synopsys.com>
 <c7d1dbac1940853c22db8215ed60181b2abe3050.1561556556.git.joabreu@synopsys.com>
 <20190626200128.GH27733@lunn.ch>
 <BN8PR12MB3266A8396ACA97484A5E0CE7D3FD0@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB3266A8396ACA97484A5E0CE7D3FD0@BN8PR12MB3266.namprd12.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 07:54:14AM +0000, Jose Abreu wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> 
> > On Wed, Jun 26, 2019 at 03:47:44PM +0200, Jose Abreu wrote:
> > > On PCI based setups that are connected to C45 PHY we won't have DT
> > > bindings specifying what's the correct PHY type.
> > 
> > You can associate a DT node to a PCI device. The driver does not have
> > to do anything special, the PCI core code does all the work.
> > 
> > As an example look at imx6q-zii-rdu2.dts, node &pcie, which has an
> > intel i210 on the pcie bus, and we need a handle to it.
> 
> That's for ARM but I'm using X86_64 which only has ACPI :/

Hi Jose

There have been some drivers gaining patches for ACPI. That is
probably the better long term solution, ask ACPI where is the PHY and
what MDIO protocol to use to talk to it.

	 Andrew
