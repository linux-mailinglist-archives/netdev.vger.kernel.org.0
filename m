Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 481DA1A833
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 17:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728631AbfEKPIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 May 2019 11:08:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60811 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728572AbfEKPIZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 May 2019 11:08:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fz0TG2HVuHdCB+n/eg0BGCxLCtFhcBm6HNAd+QooGbs=; b=pQCJMws5AnRYd+VxMdt16JRvXY
        Cg8XfvdVo2QLMT/Hl6SJBRKWZ8PaZKNRLUP71MIS9yHGPBvGujpTpgAbJ4yCoUlii4PO4GDUoXNZ+
        qVphZ4oF6RHbaEZ8tO9KItJbV3r+ePD9vt3C/X3WMPI6+PPl8TJK+54+/dPB1MIt/zJM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hPTbn-0003X7-1b; Sat, 11 May 2019 17:08:19 +0200
Date:   Sat, 11 May 2019 17:08:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vicente Bergas <vicencb@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: net: phy: realtek: regression, kernel null pointer dereference
Message-ID: <20190511150819.GF4889@lunn.ch>
References: <16f75ff4-e3e3-4d96-b084-e772e3ce1c2b@gmail.com>
 <742a2235-4571-aa7d-af90-14c708205c6f@gmail.com>
 <11446b0b-c8a4-4e5f-bfa0-0892b500f467@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11446b0b-c8a4-4e5f-bfa0-0892b500f467@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 11, 2019 at 04:46:40PM +0200, Vicente Bergas wrote:
> On Friday, May 10, 2019 10:28:06 PM CEST, Heiner Kallweit wrote:
> >On 10.05.2019 17:05, Vicente Bergas wrote:
> >>Hello,
> >>there is a regression on linux v5.1-9573-gb970afcfcabd with a kernel null
> >>pointer dereference.
> >>The issue is the commit f81dadbcf7fd067baf184b63c179fc392bdb226e
> >> net: phy: realtek: Add rtl8211e rx/tx delays config ...
> >The page operation callbacks are missing in the RTL8211E driver.
> >I just submitted a fix adding these callbacks to few Realtek PHY drivers
> >including RTl8211E. This should fix the issue.
> 
> Hello Heiner,
> just tried your patch and indeed the NPE is gone. But still no network...
> The MAC <-> PHY link was working before, so, maybe the rgmii delays are not
> correctly configured.

Hi Vicente

What phy-mode do you have in device tree? Have you tried the others?

rmgii
rmgii-id
rmgii-rxid
rmgii-txid

	Andrew
