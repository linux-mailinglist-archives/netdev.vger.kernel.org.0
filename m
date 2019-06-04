Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 128EB35266
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbfFDV65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:58:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56574 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbfFDV65 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 17:58:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=h3JAfqSg7iqMuIs8awkVYrF7cSZC61gKfGBj+mQwcSk=; b=Ne3dG4wRhSOwUTXYwli39hQ5Um
        pi+Za3gf0o53TJ/f0z1CUHM/w08235V7FJxBzbRXo27Yf5Jqrkos3hgC4ERx5D+Pq04oQJU0xYefz
        nVuBj2OMMe5LE0mWzCgx0iAk8c/KOsNX3ZmbZE20DXnFHbjr8KL1UwGOhIkABImCUP5Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hYHSI-0000Ls-Ra; Tue, 04 Jun 2019 23:58:54 +0200
Date:   Tue, 4 Jun 2019 23:58:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org, anirudh@xilinx.com, John.Linn@xilinx.com
Subject: Re: [PATCH net-next v3 00/19] Xilinx axienet driver updates (v3)
Message-ID: <20190604215854.GY19627@lunn.ch>
References: <1559684626-24775-1-git-send-email-hancock@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559684626-24775-1-git-send-email-hancock@sedsystems.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 04, 2019 at 03:43:27PM -0600, Robert Hancock wrote:
> This is a series of enhancements and bug fixes in order to get the mainline
> version of this driver into a more generally usable state, including on
> x86 or ARM platforms. It also converts the driver to use the phylink API
> in order to provide support for SFP modules.
> 
> Changes since v2:
> -Fixed MDIO bus parent detection as suggested by Andrew Lunn
> -Use clock framework to detect AXI bus clock rather than having to explicitly
>  specify MDIO clock divisor
> -Hold MDIO bus lock around device resets to avoid concurrent MDIO accesses
> -Fix bug in "Make missing MAC address non-fatal" patch

Hi Robert

When you repost, please include all reviewed-by, acked-by tags etc.

     Andrew
