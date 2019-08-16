Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6415990AAF
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 00:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbfHPWEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 18:04:15 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45530 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727763AbfHPWEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 18:04:15 -0400
Received: by mail-pg1-f193.google.com with SMTP id o13so3567537pgp.12
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 15:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2jts3hBzwwnHxg1iUXq8B1Z0rmV8e++y+KmKdSCHThk=;
        b=m+0+I/TpTOyQzaEQUomEUx5W96kpIKZVzID/SkVn4hAsDzIkGAvTdSA6QTt4SW2i7Y
         8Q2cpCm0spTv80IFdkK2fZewW3cKCkrBDpP0oj0xZSWmnwJorJdZfeQ1E+7RJy/wI5+C
         chhLlDXPpjvzQ1qTzVNCWZucGOIHWnxg7994o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2jts3hBzwwnHxg1iUXq8B1Z0rmV8e++y+KmKdSCHThk=;
        b=MGRlEORJ+FQ974g5MsVn78HWGkJV4A8kGX84a2O8Slg8zGuNBDeZjYY/WkXY8q8M+A
         SAQ6yIHBFuSstyIPC0/3y+Up/lIJqKQHX9t9fuqj/jYUo6am6CZkIiNAYqUAWNED+Yf4
         XHdUEGu7kMY+aqMwxbJBLj2G8DDpZD6ey9kJtzdOU+lllbbidzgY03VHPkQwpsBbNOVP
         5cukLGDNWQ9Vi7OoJKDAW/uCMg32PKmN7UUPwh5PQw/Ylhl0VzzJugHGKZzw1vPmIstJ
         rCyiZUoFGpXOBl0slYtw7qUyLZHF9u36XOn/3EoYCTjJeLFswJLNaSpXusMYCUfrTA+L
         zflA==
X-Gm-Message-State: APjAAAVCip3lKpnKfgaJRQL5JyhStVWYpfognOsGghEjhcXG0iufXMfU
        rjnh9rdvVO26LrqJASFObc+yGA==
X-Google-Smtp-Source: APXvYqzSjjQ6lUaojHffuDZVtmBKjVdYmKgcPupyNOrT/RtfpSy+MnLEpH7GklayvOJ9u1JaEveP6g==
X-Received: by 2002:a63:5550:: with SMTP id f16mr9955980pgm.426.1565993054375;
        Fri, 16 Aug 2019 15:04:14 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id t6sm5064133pjy.18.2019.08.16.15.04.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 15:04:13 -0700 (PDT)
Date:   Fri, 16 Aug 2019 15:04:11 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v6 1/4] dt-bindings: net: phy: Add subnode for LED
 configuration
Message-ID: <20190816220411.GX250418@google.com>
References: <20190813191147.19936-1-mka@chromium.org>
 <20190813191147.19936-2-mka@chromium.org>
 <20190816201338.GA1646@bug>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190816201338.GA1646@bug>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 16, 2019 at 10:13:38PM +0200, Pavel Machek wrote:
> Hi!
> 
> Please Cc led mailing lists on led issues.

sorry for missing this

> On Tue 2019-08-13 12:11:44, Matthias Kaehlcke wrote:
> > The LED behavior of some Ethernet PHYs is configurable. Add an
> > optional 'leds' subnode with a child node for each LED to be
> > configured. The binding aims to be compatible with the common
> > LED binding (see devicetree/bindings/leds/common.txt).
> > 
> > A LED can be configured to be:
> > 
> > - 'on' when a link is active, some PHYs allow configuration for
> >   certain link speeds
> >   speeds
> > - 'off'
> > - blink on RX/TX activity, some PHYs allow configuration for
> >   certain link speeds
> > 
> > For the configuration to be effective it needs to be supported by
> > the hardware and the corresponding PHY driver.
> > 
> > Suggested-by: Andrew Lunn <andrew@lunn.ch>
> > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> 
> > @@ -173,5 +217,20 @@ examples:
> >              reset-gpios = <&gpio1 4 1>;
> >              reset-assert-us = <1000>;
> >              reset-deassert-us = <2000>;
> > +
> > +            leds {
> > +                #address-cells = <1>;
> > +                #size-cells = <0>;
> > +
> > +                led@0 {
> > +                    reg = <0>;
> > +                    linux,default-trigger = "phy-link-1g";
> > +                };
> 
> Because this affects us.
> 
> Is the LED software controllable?

it might be for certain PHYs, integration with the LED framework is
not part of this series.

> Or can it do limited subset of triggers you listed?

it depends on the PHY. The one in this series (RTL8211E) only supports
a limited subset of the listed triggers.
