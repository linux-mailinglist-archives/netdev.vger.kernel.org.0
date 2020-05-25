Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1348E1E1854
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 01:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388298AbgEYXrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 19:47:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48906 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726555AbgEYXrq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 19:47:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6bHYJc+SLBQBcTqueWlMv7Gj9KoLy64MUOEbtIYTDE4=; b=S/Q7YLBwdt6Vc7max4QaFhfgVX
        X4Cu4OVtlv4Mmpch7R+HxVVMyVtq3ZUNhfy3JIvHd8/ftb7fx2/Na5wd7NPAB2skjaNMQFhzASM5b
        8GjzH69E4gOer/6HKV1dKSW2HNFDy1IlHqRCvVT9c4EdNHbWv3D6xD1Wzd96VTpe3YBk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jdMon-003Er7-5n; Tue, 26 May 2020 01:47:41 +0200
Date:   Tue, 26 May 2020 01:47:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, madalin.bucur@oss.nxp.com,
        calvin.johnson@oss.nxp.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC 04/11] net: phy: Handle c22 regs presence better
Message-ID: <20200525234741.GH768009@lunn.ch>
References: <20200522213059.1535892-5-jeremy.linton@arm.com>
 <20200523183731.GZ1551@shell.armlinux.org.uk>
 <f85e4d86-ff58-0ed2-785b-c51626916140@arm.com>
 <20200525100612.GM1551@shell.armlinux.org.uk>
 <63ca13e3-11ea-3ddf-e1c7-90597d4a5f8c@arm.com>
 <20200525220614.GC768009@lunn.ch>
 <8868af66-fc1a-8ec2-ab75-123bffe2d504@arm.com>
 <20200525230732.GQ1551@shell.armlinux.org.uk>
 <20200525231255.GF768009@lunn.ch>
 <73eb7471-e724-7c1c-6521-faf74607b26a@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73eb7471-e724-7c1c-6521-faf74607b26a@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 25, 2020 at 06:46:10PM -0500, Jeremy Linton wrote:
> Hi,
> 
> 
> On 5/25/20 6:12 PM, Andrew Lunn wrote:
> > > arch/powerpc/boot/dts/fsl/t4240rdb.dts: compatible = "ethernet-phy-id13e5.1002";
> > > arch/powerpc/boot/dts/fsl/t4240rdb.dts: compatible = "ethernet-phy-id13e5.1002";
> > > arch/powerpc/boot/dts/fsl/t4240rdb.dts: compatible = "ethernet-phy-id13e5.1002";
> > > arch/powerpc/boot/dts/fsl/t4240rdb.dts: compatible = "ethernet-phy-id13e5.1002";
> > > arch/powerpc/boot/dts/fsl/t2080rdb.dts: compatible = "ethernet-phy-id13e5.1002";
> > > arch/powerpc/boot/dts/fsl/t2080rdb.dts: compatible = "ethernet-phy-id13e5.1002";
> > 
> > Hi Jeremy
> > 
> > You are doing this work for NXP right? Maybe you can ask them to go
> > searching in the cellar and find you one of these boards?
> 
> Yes, thats a good idea. I've been talking to various parties to let me run
> this code on some of their "odd" devices.

O.K. great.

Then i think we should all stop emailing for a while until we know
more.

	Andrew
