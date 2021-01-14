Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F612F5C3A
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 09:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbhANIKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 03:10:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:60084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727155AbhANIKj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 03:10:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D036233FD;
        Thu, 14 Jan 2021 08:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610611799;
        bh=h8yz1GRa6ZXiQMpcgDtQNAWbWiKhEQmrV0RpuC4UJLA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tAgvgz2ZR4RFMrrL0NJU8F37WSrtjufQ7SLTf3fZIWi4NHW7NaoTANw2X9taug/Aa
         Hb8g0x3iNvgkUOCKOEikM0AfnaOzmfhsyQzc3EWXIX2dHF7KoxYZ68L463c+HUb6Nl
         MpdUpQ3uozTb23OC3IFrg544rYU+hC27zwpRjH60gB13ueIo2h4kvYQCYz4rcutQuG
         R+VXZEHuYzmtm0raL5kfzcbtHB5Ax9kCS0gz2Gv3JdOakS5OHtFiE5TMPalZrxjwDJ
         EnY1n+GtV0nUanFitZIOVH6P7s3WZml7a8969q+D465B3Ch2mJ+6huS28niJhH9TrC
         AMjN/Uvg22kKw==
Date:   Thu, 14 Jan 2021 13:39:37 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Gwendal Grignou <gwendal@chromium.org>,
        linux-iio <linux-iio@vger.kernel.org>
Subject: Re: [PATCH v1 1/1] time64.h: Consolidated PSEC_PER_SEC definition
Message-ID: <20210114080937.GA2771@vkoul-mobl>
References: <20210112153709.1074-1-andriy.shevchenko@linux.intel.com>
 <20210113193900.69b69a7c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAHp75VeeRRjm=bnyXGgf3j=bKB2wH-v=aDzH3OrQ0dO3BMTrDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VeeRRjm=bnyXGgf3j=bKB2wH-v=aDzH3OrQ0dO3BMTrDA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14-01-21, 09:10, Andy Shevchenko wrote:
> On Thursday, January 14, 2021, Jakub Kicinski <kuba@kernel.org> wrote:
> 
> > On Tue, 12 Jan 2021 17:37:09 +0200 Andy Shevchenko wrote:
> > > We have currently three users of the PSEC_PER_SEC each of them defining
> > it
> > > individually. Instead, move it to time64.h to be available for everyone.
> > >
> > > There is a new user coming with the same constant in use. It will also
> > > make its life easier.
> > >
> > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> >
> > Which tree will you send the new user to? I'm not sure who you're
> > expecting to take this patch :S
> 
> 
> I think PHY tree is the best candidate with providing an immutable branch
> for others.

Sure I can do that, I would wait for other folks to ack this

Thanks
-- 
~Vinod
