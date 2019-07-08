Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3F6629E4
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 21:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404723AbfGHTsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 15:48:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33190 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727163AbfGHTsj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 15:48:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sGbPfoaC6Sqy+fAOtotKG4RG4E/xEK5XD4Zeoq9Oa4g=; b=0KoAoNTMKAdwOtdRPJQCvsTS1O
        CCz05sOmiHQIlODseSvjYwap+NReQO0CUO93/Tsjqr3M/ewRdOz9lMP5ImcSLdHe3FoG675HVw/Gb
        8AgJgN6SQXE7Cv7yyZ5zz5WMoSnDyV0nETa5gGqEf+AbSZHxDy9R9UDQPPticWD8tIjY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hkZco-0004bw-EL; Mon, 08 Jul 2019 21:48:34 +0200
Date:   Mon, 8 Jul 2019 21:48:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v3 6/7] dt-bindings: net: realtek: Add property to
 configure LED mode
Message-ID: <20190708194834.GI9027@lunn.ch>
References: <20190708192459.187984-1-mka@chromium.org>
 <20190708192459.187984-7-mka@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708192459.187984-7-mka@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 08, 2019 at 12:24:58PM -0700, Matthias Kaehlcke wrote:
> The LED behavior of some Realtek PHYs is configurable. Add the
> property 'realtek,led-modes' to specify the configuration of the
> LEDs.
> 
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>

Hi Matthias

Humm. I thought you were going to drop this and the next patch?

      Andrew
