Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDFD4A9A91
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 15:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359208AbiBDOCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 09:02:09 -0500
Received: from relay5.hostedemail.com ([64.99.140.38]:17760 "EHLO
        relay5.hostedemail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359209AbiBDOCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 09:02:08 -0500
Received: from omf17.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay02.hostedemail.com (Postfix) with ESMTP id C1E642183A;
        Fri,  4 Feb 2022 14:02:07 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf17.hostedemail.com (Postfix) with ESMTPA id A72A11B;
        Fri,  4 Feb 2022 14:01:08 +0000 (UTC)
Message-ID: <7cb1ce88cbf977801f2519178c270c1271100ac6.camel@perches.com>
Subject: Re: [PATCH] HPE BMC GXP SUPPORT
From:   Joe Perches <joe@perches.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     nick.hawkins@hpe.com, verdun@hpe.com,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Corey Minyard <minyard@acm.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>, Lee Jones <lee.jones@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        soc@kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Stanislav Jakubek <stano.jakubek@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Hao Fang <fanghao11@huawei.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Wang Kefeng <wangkefeng.wang@huawei.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date:   Fri, 04 Feb 2022 06:01:44 -0800
In-Reply-To: <Yf0cihUQ1byjnh3d@shell.armlinux.org.uk>
References: <nick.hawkins@hpe.com>
         <20220202165315.18282-1-nick.hawkins@hpe.com>
         <Yf0Wm1kOV1Pss9HJ@shell.armlinux.org.uk>
         <ad56e88206a8d66b715035362abe16ece0bde7d3.camel@perches.com>
         <Yf0cihUQ1byjnh3d@shell.armlinux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A72A11B
X-Spam-Status: No, score=-2.03
X-Stat-Signature: c3yzg6zcu4cpdcebaczubogb94ck3gqq
X-Rspamd-Server: rspamout07
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+KwoOMBfXWPFnO9qh3WITIVuG9hjhnLgA=
X-HE-Tag: 1643983268-605794
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-02-04 at 12:31 +0000, Russell King (Oracle) wrote:
> On Fri, Feb 04, 2022 at 04:18:24AM -0800, Joe Perches wrote:
> > On Fri, 2022-02-04 at 12:05 +0000, Russell King (Oracle) wrote:
> > > On Wed, Feb 02, 2022 at 10:52:50AM -0600, nick.hawkins@hpe.com wrote:
> > > > +	if (readb_relaxed(timer->control) & MASK_TCS_TC) {
> > > > +		writeb_relaxed(MASK_TCS_TC, timer->control);
> > > > +
> > > > +		event_handler = READ_ONCE(timer->evt.event_handler);
> > > > +		if (event_handler)
> > > > +			event_handler(&timer->evt);
> > > > +		return IRQ_HANDLED;
> > > > +	} else {
> > > > +		return IRQ_NONE;
> > > > +	}
> > > > +}
> > 
> > It's also less indented code and perhaps clearer to reverse the test
> > 
> > 	if (!readb_relaxed(timer->control) & MASK_TCS_TC)
> 
> This will need to be:
> 
>  	if (!(readb_relaxed(timer->control) & MASK_TCS_TC))

right, thanks.


