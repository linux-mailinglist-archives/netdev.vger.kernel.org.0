Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059221AEEB3
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 16:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgDRO2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 10:28:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46442 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgDRO2A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Apr 2020 10:28:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kqthyuF73mZXFPzFmwO4BGMkX1oZYQytgVrK8v5HwGs=; b=EtcgDxXTl61F+0rw6jPyhCryzy
        0vFrF+3OiqiuKR0l8hxg+X133aN7yXOKuMsHntVWeolILUI9ueRZZFQkXKzCp81zaTNjWT/hgb51v
        2POHCg2debFm5AUlA+1ZG5SK1kCZ3ParRUkr8Aq8euvgrDyZMZbS9Gnt79Lk3r1pwNWo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jPoRq-003T6w-Hi; Sat, 18 Apr 2020 16:27:58 +0200
Date:   Sat, 18 Apr 2020 16:27:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, fugang.duan@nxp.com,
        Chris Healy <Chris.Healy@zii.aero>
Subject: Re: [PATCH net-next v2 3/3] net: ethernet: fec: Allow the MDIO
 preamble to be disabled
Message-ID: <20200418142758.GC804711@lunn.ch>
References: <20200418000355.804617-1-andrew@lunn.ch>
 <20200418000355.804617-4-andrew@lunn.ch>
 <bde059d8-5a95-d32b-7e28-ac7385cc0415@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bde059d8-5a95-d32b-7e28-ac7385cc0415@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This is a property of the MDIO device node and the MDIO bus controller as
> well, so I would assume that it has to be treated a little it like the
> 'broken-turn-around' property and it would have to be a bitmask per MDIO
> device address that is set/clear depending on what the device support. If it
> is set for the device and your controller supports it, then you an suppress
> preamble.

Again, i don't see how this can work. You need all the devices on the
bus to support preamble suppression, otherwise you cannot use it. As
with a maximum clock frequency, we could add the complexity to check
as bus scan time that all devices have the necessary property, but i
don't think it brings anything.

    Andrew
