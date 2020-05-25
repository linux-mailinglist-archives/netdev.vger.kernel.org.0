Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF361E1828
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 01:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388823AbgEYXNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 19:13:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48848 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388013AbgEYXNC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 19:13:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lEig+Fu9W7WSBV2e/0nipchiOVkFT8CZhyvFwP+PQ3Y=; b=4yC8e6BxuwD7pR0SoWi7UbtDFH
        J520XoEk8T71u1kmcRWE9Q4BACqJVTwsAtAtfpgFcChFozjMe6aGJ23VoFUHAwEWVNJJZxD9pPNjp
        6q4zvX+12x/HzLAaQl0vZ2nZQAnYASPe6cv9hyLzsQ+uA6suUZ3f0lk7GVyKK1iBOXg0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jdMH9-003EgC-VH; Tue, 26 May 2020 01:12:55 +0200
Date:   Tue, 26 May 2020 01:12:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Jeremy Linton <jeremy.linton@arm.com>, netdev@vger.kernel.org,
        davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 04/11] net: phy: Handle c22 regs presence better
Message-ID: <20200525231255.GF768009@lunn.ch>
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-5-jeremy.linton@arm.com>
 <20200523183731.GZ1551@shell.armlinux.org.uk>
 <f85e4d86-ff58-0ed2-785b-c51626916140@arm.com>
 <20200525100612.GM1551@shell.armlinux.org.uk>
 <63ca13e3-11ea-3ddf-e1c7-90597d4a5f8c@arm.com>
 <20200525220614.GC768009@lunn.ch>
 <8868af66-fc1a-8ec2-ab75-123bffe2d504@arm.com>
 <20200525230732.GQ1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525230732.GQ1551@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> arch/powerpc/boot/dts/fsl/t4240rdb.dts: compatible = "ethernet-phy-id13e5.1002";
> arch/powerpc/boot/dts/fsl/t4240rdb.dts: compatible = "ethernet-phy-id13e5.1002";
> arch/powerpc/boot/dts/fsl/t4240rdb.dts: compatible = "ethernet-phy-id13e5.1002";
> arch/powerpc/boot/dts/fsl/t4240rdb.dts: compatible = "ethernet-phy-id13e5.1002";
> arch/powerpc/boot/dts/fsl/t2080rdb.dts: compatible = "ethernet-phy-id13e5.1002";
> arch/powerpc/boot/dts/fsl/t2080rdb.dts: compatible = "ethernet-phy-id13e5.1002";

Hi Jeremy

You are doing this work for NXP right? Maybe you can ask them to go
searching in the cellar and find you one of these boards?

	  Andrew
