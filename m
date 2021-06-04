Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A7039C3CA
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 01:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbhFDXUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 19:20:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhFDXUn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 19:20:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D62CF613EC;
        Fri,  4 Jun 2021 23:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622848737;
        bh=o5HZTLhP5wQ4KKFNqCChs2/Ti0SXDssVhVvBtp5dayI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CGVHiF4bMBkMEK0K/sxKjF+kBO4UDZkFoIv+fShW7RXBzZOZubgNL1d1nUFEJ/Mtv
         0mHCLhI300IJKrWQi1SS7Kfquc1CjZbdj9CleQ9O6vWITg3znvEr9YbI89YHOKJuQL
         DxlXdf6FodA1XwCH33ZFCELvVw3nsSMnjtv7NRfGzU22y1hSWyDUojZW4Pr4iPOWL1
         gDpSPDn6MmpWeXRl9F2iIYzW2LRVjqg13stVUros0lam+qXp38IwbQPJnuly3RIiZP
         CsrWC1gV8FbzhSWYvQeUJKL3wi8BtVn1RV81jlyqSdI1NshikcaMbFxhiB/WVHmLOE
         Va9GuKhvvK0Ug==
Received: by pali.im (Postfix)
        id A5169990; Sat,  5 Jun 2021 01:18:54 +0200 (CEST)
Date:   Sat, 5 Jun 2021 01:18:54 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Igal Liberman <Igal.Liberman@freescale.com>,
        Shruti Kanetkar <Shruti@freescale.com>,
        Emil Medve <Emilian.Medve@freescale.com>,
        Scott Wood <oss@buserror.net>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Camelia Alexandra Groza (OSS)" <camelia.groza@oss.nxp.com>
Subject: Re: Unsupported phy-connection-type sgmii-2500 in
 arch/powerpc/boot/dts/fsl/t1023rdb.dts
Message-ID: <20210604231854.qi3o3k4rk23jjetg@pali>
References: <20210603143453.if7hgifupx5k433b@pali>
 <YLjxX/XPDoRRIvYf@lunn.ch>
 <20210603194853.ngz4jdso3kfncnj4@pali>
 <AM6PR04MB3976B62084EC462BA02F0C4CEC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20210604192732.GW30436@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604192732.GW30436@shell.armlinux.org.uk>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 04 June 2021 20:27:33 Russell King (Oracle) wrote:
> 802.3 defined 1000base-X which is a fixed 1G speed interface using a
> 16-bit control word. Implementations of this exist where the control
> word can be disabled.
> 
> Cisco came along, took 1000base-X and augmented it to allow speeds of
> 10M and 100M by symbol repetition, and changing the format of the
> 16-bit control word. Otherwise, it is functionally compatible - indeed
> SGMII with the control word disabled will connect with 1000base-X with
> the control word disabled. I've done it several times.
> 
> There exists 2500base-X, which is 1000base-X clocked faster, and it
> seems the concensus is that it has the AN disabled - in other words,
> no control word.

Thank you for a nice explanation! I think that this information should
be part of documentation as it could help also other people to
understand differences between these modes.
