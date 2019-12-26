Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A17412ABC5
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 12:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfLZLI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 06:08:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40468 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbfLZLI1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Dec 2019 06:08:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ukIw4m4IWdjtDk5tl+vpdhk2AgnUFvsYekg7tTbNV58=; b=ZHTiyIfdFWcU9Q83bJaMbTRwx0
        M4IA11fwoXIwj+IX+Q+MvfwepBiRNPyZ0DNNx24Pb9fQyhMXBKOgzgNrUxVXy+sir+VNST6I8WNqk
        nw+E/Mf+hL4eKIOC3YpaoTfGqlK5aBGy6lVC6fXQBBrdeKlW7lyzzuLRh2F6r+L7txKo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ikR09-0001I2-2q; Thu, 26 Dec 2019 12:08:21 +0100
Date:   Thu, 26 Dec 2019 12:08:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
Cc:     "maxime.ripard@bootlin.com" <maxime.ripard@bootlin.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC] obsolete references to
 Documentation/devicetree/bindings/net/ethernet.txt
Message-ID: <20191226110821.GE1480@lunn.ch>
References: <VI1PR04MB5567BBD2827A5DDDFD0D82B7EC2E0@VI1PR04MB5567.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB5567BBD2827A5DDDFD0D82B7EC2E0@VI1PR04MB5567.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 09:00:50AM +0000, Madalin Bucur (OSS) wrote:
> Hi,
> 
> this patch removed the ethernet.txt content and added the information found in
> it in the ethernet-controller.yaml (Documentation/devicetree/bindings/net):
> 
>   commit 9d3de3c58347623b5e71d554628a1571cd3142ad
>   Author: Maxime Ripard <maxime.ripard@bootlin.com>
>   Date:   Thu Jun 27 17:31:43 2019 +0200
> 
>       dt-bindings: net: Add YAML schemas for the generic Ethernet options
> 
>       The Ethernet controllers have a good number of generic options that can be
>       needed in a device tree. Add a YAML schemas for those.
> 
>       Reviewed-by: Rob Herring <robh@kernel.org>
>       Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
>       Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>       Signed-off-by: Rob Herring <robh@kernel.org>
> 
> There are still many references to the previous ethernet.txt document:
> 
>   $ grep ethernet.txt Documentation/devicetree/bindings/net/ -r | wc -l
>   96
> 
> Should those be updated too or it's enough to rely on the current content
> of the previous ethernet.txt file:
> 
>   $ cat Documentation/devicetree/bindings/net/ethernet.txt
>   This file has moved to ethernet-controller.yaml.

Hi Madalin

Feel free to fix the references if you want. Probably a perl one liner
should do most of the work.

       Thanks
	Andrew
