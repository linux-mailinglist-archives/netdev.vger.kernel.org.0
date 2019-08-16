Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19DE090B18
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 00:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727862AbfHPWkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 18:40:15 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41130 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727736AbfHPWkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 18:40:15 -0400
Received: by mail-pg1-f195.google.com with SMTP id x15so3612241pgg.8
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 15:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4isWOpXxrzUvNme/KCgMCxUh6xJ4ndIEmHXD23Gkt60=;
        b=VPlnuRvnp4Gy3Kcy4Aa01BccZtnwXkpsFKyQtfLlkt8r5BLx1mqm3OUNzv1S1MCVr8
         kMAPwdTQeUwIdVopqKrH2e38F7ZChox4T0C7YWND7ZZrSl8Hk2qBiVCQgYVup4W3iJjc
         J8iXwOx114xHwEVVzn5UUt/qY9hoUFQrOMJbs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4isWOpXxrzUvNme/KCgMCxUh6xJ4ndIEmHXD23Gkt60=;
        b=uG5tCv3n0JdRKYjmffOIY6lPoSL0BqOztGg80EazPAFRBQ5xriyp7UD5lIGM+EiZdv
         7P+Y913aoThJwopr1gEtnyWOzTGsuysM+bJRX48hd62ceflFZMkxt1ihOlBwpR7Wiy+J
         XskWmFKCM9g9XI9arHDtt7ta+nwUtB90+WVrxdLMVqrcgHoKtGjNGkVdRknyX68YBq/t
         szkK/1C302xScULTAeQm/8yu+yp8c+ycwYy/2M2PDj38GrgNIWe2SVzCMhAuXj/WsogC
         pyUwq01rA0YXZ0AgGErFglrQSfHKVtOTuru8Oizy6oDlJJoa9Tn4JCPRAxpPxcTBIDo7
         uOBA==
X-Gm-Message-State: APjAAAXlRMlFdeCIRJgdqFUG7J91QUg7qtm7vaGijpTCObmg7hnuUT9P
        PqYZqRUTY3HWHsVjoKDDwstVIQ==
X-Google-Smtp-Source: APXvYqwPZMpFzJcNDgtXSglJwyeoPaqBu5+IeIbMG0rnKOkYBqlA3hM1tNAHo+48LQZW0UAQnXzd4A==
X-Received: by 2002:a17:90a:30ad:: with SMTP id h42mr9234947pjb.31.1565995214058;
        Fri, 16 Aug 2019 15:40:14 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id p5sm7395219pfg.184.2019.08.16.15.40.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 15:40:13 -0700 (PDT)
Date:   Fri, 16 Aug 2019 15:40:11 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Pavel Machek <pavel@ucw.cz>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v6 4/4] net: phy: realtek: Add LED configuration support
 for RTL8211E
Message-ID: <20190816224011.GY250418@google.com>
References: <20190813191147.19936-1-mka@chromium.org>
 <20190813191147.19936-5-mka@chromium.org>
 <20190816201342.GB1646@bug>
 <20190816212728.GW250418@google.com>
 <31dc724d-77ba-3400-6abe-4cf2e3c2a20a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <31dc724d-77ba-3400-6abe-4cf2e3c2a20a@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 16, 2019 at 03:12:47PM -0700, Florian Fainelli wrote:
> On 8/16/19 2:27 PM, Matthias Kaehlcke wrote:
> > On Fri, Aug 16, 2019 at 10:13:42PM +0200, Pavel Machek wrote:
> >> On Tue 2019-08-13 12:11:47, Matthias Kaehlcke wrote:
> >>> Add a .config_led hook which is called by the PHY core when
> >>> configuration data for a PHY LED is available. Each LED can be
> >>> configured to be solid 'off, solid 'on' for certain (or all)
> >>> link speeds or to blink on RX/TX activity.
> >>>
> >>> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> >>
> >> THis really needs to go through the LED subsystem,
> > 
> > Sorry, I used what get_maintainers.pl threw at me, I should have
> > manually cc-ed the LED list.
> > 
> >> and use the same userland interfaces as the rest of the system.
> > 
> > With the PHY maintainers we discussed to define a binding that is
> > compatible with that of the LED one, to have the option to integrate
> > it with the LED subsystem later. The integration itself is beyond the
> > scope of this patchset.
> > 
> > The PHY LED configuration is a low priority for the project I'm
> > working on. I wanted to make an attempt to upstream it and spent
> > already significantly more time on it than planned, if integration
> > with the LED framework now is a requirement please consider this
> > series abandonded.
> 
> While I have an appreciation for how hard it can be to work in a
> corporate environment while doing upstream first and working with
> virtually unbounded goals (in time or scope) due to maintainers and
> reviewers, that kind of statement can hinder your ability to establish
> trust with peers in the community as it can be read as take it or leave it.

I'm really just stating the reality here. We strongly prefer landing
patches upstream over doing custom hacks, and depending on the
priority of a given feature/sub-system and impact on schedule we can
allocate more time on it or less. In some cases/at some point a
downstream patch is just good enough.

I definitely don't intend to get a patchset landed if it isn't deemed
ready or suitable at all. In this case I just can't justify to spend
significantly more time on it. IMO it is better to be clear on this,
not to pressure maintainers to take a patch, but so people know what
to expect. This information can also help if someone comes across this
patchset in the future and wonders about its status.

btw, a birdie told me there will be a talk next week at ELC in San
Diego on how Chrome OS works with upstream, discussing pros and
cons for both the project and upstream. For those who are intersted
in the topic but can't make it to the conference, the slides are
already online and IMO have good information:
https://static.sched.com/hosted_files/ossna19/9c/ELC19_ChromeOSAndUpstream.pdf

Cheers

Matthias
