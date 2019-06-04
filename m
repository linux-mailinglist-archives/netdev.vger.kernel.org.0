Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C88A93476F
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 15:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfFDNA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 09:00:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54480 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727068AbfFDNAz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 09:00:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=T774Xhu5AEgwP8/6iyTFaSHGRDvTNDlOL7/DN0rnRIQ=; b=j5AfnkFWcuXQe6pq0AmkjVlEDK
        4l81uvmxs4km9vr7wC8F0IfgAxO6oOBVq5AHpyBC+NwXRwBKbKI2JtrDqbIXfN4LzzdqVbc9DwwYI
        ZM8w8aqocMEKLokEh3TtWMaqBlesO/ellSvNDv9Ll47AvrdKXWNhAguyfUNsR9g0oZ8Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hY93Z-0004V4-1p; Tue, 04 Jun 2019 15:00:49 +0200
Date:   Tue, 4 Jun 2019 15:00:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Robert Hancock <hancock@sedsystems.ca>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: add flag PHY_QUIRK_NO_ESTATEN
Message-ID: <20190604130049.GA16951@lunn.ch>
References: <e5518425-0a62-0790-8203-b011c3db69d3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5518425-0a62-0790-8203-b011c3db69d3@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 04, 2019 at 08:10:50AM +0200, Heiner Kallweit wrote:
> We have a Xilinx GBit PHY that doesn't have BMSR_ESTATEN set
> (what violates the Clause 22 standard). Instead of having the PHY
> driver to implement almost identical copies of few generic functions
> let's add a flag for this quirk to phylib.

Hi Heiner

It is a bit of a personal preference, but i would prefer the Xilinx
driver worked around broken hardware, not scatter quirks in the core.
Keep the core clean.

If we had multiple PHYs broken in the same way, then maybe a quirk.

	Andrew
