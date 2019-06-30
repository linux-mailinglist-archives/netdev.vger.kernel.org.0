Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77B2F5B111
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 19:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfF3R4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 13:56:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44020 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726641AbfF3R4u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jun 2019 13:56:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5HnU4RkXqv2UDhG4AKi+OzYDwjQOslTNmPEk3LnsgoM=; b=cuV2DLAjNbpPvEytGxwlCT3zs/
        4fymv+/DHo91wXxE6BTPqfKgXynxsgU4A8nyDa1rajhBPiKzKgDfa1K4wjazCEUcuupfFlO8sVvaP
        /8S0oOu0l7b3wUfsDOwtc9NfPgcKZRKci/sbCRBiW/wjXZ3Yy25RkE+it/SPKOmkaVZg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hhe49-0002Rd-Oz; Sun, 30 Jun 2019 19:56:41 +0200
Date:   Sun, 30 Jun 2019 19:56:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Karsten Wiborg <karsten.wiborg@web.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, nic_swsd@realtek.com,
        romieu@fr.zoreil.com, netdev@vger.kernel.org
Subject: Re: r8169 not working on 5.2.0rc6 with GPD MicroPC
Message-ID: <20190630175641.GB5330@lunn.ch>
References: <0a560a5e-17f2-f6ff-1dad-66907133e9c2@web.de>
 <85548ec0-350b-118f-a60c-4be2235d5e4e@gmail.com>
 <4437a8a6-73f0-26a7-4a61-b215c641ff20@web.de>
 <b104dbf2-6adc-2eee-0a1a-505c013787c0@gmail.com>
 <62684063-10d1-58ad-55ad-ff35b231e3b0@web.de>
 <20190630145511.GA5330@lunn.ch>
 <3825ebc5-15bc-2787-4d73-cccbfe96a0cc@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3825ebc5-15bc-2787-4d73-cccbfe96a0cc@web.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The vendor part of my MAC is 6e:69:73 which is interesting because
> according to some Vendor-Lookup-pages the vendor is unknown.

0x6e = 0110 1110b. Bit 1 is the Locally Administered bit. Meaning this
is not an MAC address from a vendor pool, but one generated locally.

http://www.noah.org/wiki/MAC_address

If linux were to generate a random MAC address it would also set bit
1.

What is interesting is that you say you get the same value each
time. So it most either be stored somewhere, or it is generated from
something, the board serial number, etc.

	   Andrew
