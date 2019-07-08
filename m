Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF33F62AB7
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 23:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405230AbfGHVN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 17:13:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33304 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732264AbfGHVN6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 17:13:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kVBtLbkINWvlTaGTq38NgH/b+sbR3POZZynsOuPsgtE=; b=3jrtUlxZNKj/cwvh4a1fNTDRZk
        rcahj82j43oxKvZsnovj5siqLRx2LW1ZgPKkv8N6I6kQ3lN/Hts+DEe9KECBdddR46Mj3qsfop3vd
        drEzaUtPmw9eT97zJNslXKtvGkN4zfsRlfm8upPiZmHiBo/u8ZEAoqohkeZvUrrnQeRY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hkaxI-0004xc-6U; Mon, 08 Jul 2019 23:13:48 +0200
Date:   Mon, 8 Jul 2019 23:13:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v3 1/7] dt-bindings: net: Add bindings for Realtek PHYs
Message-ID: <20190708211348.GA17857@lunn.ch>
References: <20190708192459.187984-1-mka@chromium.org>
 <20190708192459.187984-2-mka@chromium.org>
 <20190708194615.GH9027@lunn.ch>
 <20190708200136.GM250418@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708200136.GM250418@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 08, 2019 at 01:01:36PM -0700, Matthias Kaehlcke wrote:
> On Mon, Jul 08, 2019 at 09:46:15PM +0200, Andrew Lunn wrote:
> > On Mon, Jul 08, 2019 at 12:24:53PM -0700, Matthias Kaehlcke wrote:
> > > Add the 'realtek,eee-led-mode-disable' property to disable EEE
> > > LED mode on Realtek PHYs that support it.
> > > 
> > > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > > ---
> > > TODO: adapt PHY core to deal with optional compatible strings
> > 
> > Yes. Does this even work at the moment? I would expect
> > of_mdiobus_child_is_phy() to return false, indicating the device is
> > not actually a PHY.
> 
> Indeed, it currently doesn't work atm. I found that removing the check
> for dev->of_node in of_mdiobus_link_mdiodev() helps, but I imagine
> doing (only) this might have undesired side-effects.

O.K.

Please put RFC in patches like this which don't actually work and so
should not be merged. We don't want David accidentally merging them!

       Andrew
