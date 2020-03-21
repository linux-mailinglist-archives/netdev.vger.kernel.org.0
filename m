Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70D4418DCA5
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 01:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbgCUAn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 20:43:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48344 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbgCUAn5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 20:43:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XkSB/hvVRuWQxAws4923HJ3kZr8rCsFZjs1/QW94Ukc=; b=bpVBtlF16lcEL1HfybZ2H8zaRZ
        Vuhe5yscLCI9YuWni9PVjjHGaMBT5a4jk9UAdm6L0g/FAdo6j66lH4IEPd38iXReejrzha5bER0bJ
        jtOHPatjT3579Metq6BmAInn2ZHuF1TY2bL+SGWVwjECC6EBLQhsQTvgtx82LIxptMW0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jFSF1-0000xd-0U; Sat, 21 Mar 2020 01:43:55 +0100
Date:   Sat, 21 Mar 2020 01:43:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Roelof Berg <rberg@berg-solutions.de>
Cc:     netdev@vger.kernel.org
Subject: Re: Is my patch interesting for contribution: FixedPHY support for
 Microchip LAN743x ?
Message-ID: <20200321004355.GD2702@lunn.ch>
References: <DD2042A5-68EA-40A1-A4A9-5A1DCE4F9583@berg-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DD2042A5-68EA-40A1-A4A9-5A1DCE4F9583@berg-solutions.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 02:18:14PM +0100, Roelof Berg wrote:
> Dear Kernel-Heros,
> 
> for our custom PCB I added FixedPHY support to the Microchip lan743x driver. This allows running a combination of lan7431 (MAC) and Microchip ksz9893 (switch) via a direct MII connection, i.e. without any PHYs in between. The .config determines wether (and how) FixedPHY is used, and the patch has 100%ly no (side-)effect in the default setting.
> 
> Is such a patch interesting for the community ?
> 
> Pro:
> + Supports lan7431<->kaz9893, a cost effective way of doing: PCIe<->2x-RJ45
> + Tested
> + Can be a grep-template for others with the same issue, i.e. adding FixedPHY to their driver
> 
> Con:
> - Maybe a more general approach would be better, that allows connecting any driver to a FixedPhy ? Insread of every driver doing its own thing ?

Hi Roelof

You are welcome to post it.

So far, it has been a case of each MAC driver having its own
implementation. However, if you port the MAC driver to use phylink,
not phylib, phylink will handle the fixed PHY without any additional
code.

	Andrew
