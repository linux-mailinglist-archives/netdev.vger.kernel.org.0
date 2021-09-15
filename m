Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE1240CDDC
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 22:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbhIOUVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 16:21:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43020 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231766AbhIOUVP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 16:21:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=g8aS/xkGAi+vDTBvZLmhQHUMkhsVOhjWnP9/XA4zI8w=; b=ioLUW4wT3oJjzjtiwN2aY3fHwD
        zkES/hsPaaiOjLAgCHjgIduxav+YaVI65maksMyCZqIE271TIyWwlW/8tpe9Ulo7b+3mLd4GrxYle
        RRlX1Wxt4rOBGJf3lD9D7oYbnkPhE7+8ZF2KrAIAxaNCBMsTUtOab6Yxy8zm5Zc1imG4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mQbNo-006no5-9W; Wed, 15 Sep 2021 22:19:52 +0200
Date:   Wed, 15 Sep 2021 22:19:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Asmaa Mnebhi <asmaa@nvidia.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        David Thompson <davthompson@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Liming Sun <limings@nvidia.com>
Subject: Re: [PATCH v1 5/6] TODO: gpio: mlxbf2: Introduce IRQ support
Message-ID: <YUJVaMkjmbuDGGOE@lunn.ch>
References: <20210816115953.72533-1-andriy.shevchenko@linux.intel.com>
 <20210816115953.72533-6-andriy.shevchenko@linux.intel.com>
 <CH2PR12MB3895ACF821C8242AA55A1DCDD7FD9@CH2PR12MB3895.namprd12.prod.outlook.com>
 <YR0UPG2451aGt9Xg@smile.fi.intel.com>
 <CH2PR12MB3895E8CDC7DC1AD0144E1416D7DB9@CH2PR12MB3895.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH2PR12MB3895E8CDC7DC1AD0144E1416D7DB9@CH2PR12MB3895.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 07:27:51PM +0000, Asmaa Mnebhi wrote:
> Hi Andy, Hi Andrew,
> 
> I have a question regarding patch submission. I am going to mimic what Andy has done for v5/6 and v6/6 and send 2 patches in a bundle as follows:
> /* for the cover letter */ : Subject: [PATCH v1 0/2] gpio: mlxbf2: Introduce proper interrupt handling
> Subject: [PATCH v1 1/2] gpio: mlxbf2: Introduce IRQ support
> Subject: [PATCH v1 2/2] net: mellanox: mlxbf_gige: Replace non-standard interrupt handling
> 
> Questions:
> 1) do the subject lines look ok? i.e. sending patches that target "net" as opposed to "net-next"
> 2) would you like me to add a "Fixes" tag to each patch as follows? I am not sure if you consider this a bug?
> Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")

You are posting patches which go into two different subsystems. So you
need to pay special care here. Pick a maintainer you want to merge
this, and make sure you Cc: the other maintainer. Make it clear in
patch 0/X which maintainer you would like to take the patch series,
and that the other should give an Acked-by if they are happy with the
patches.

I don't think this should be considered a bug, so no need for a Fixes:
tag.

The subject lines look O.K.

Also, please fix your mailer to wrap lines at about 75 characters.

      Andrew
