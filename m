Return-Path: <netdev+bounces-6184-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96585715200
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 00:42:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B14CD280FCD
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 22:42:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE8A7C8DC;
	Mon, 29 May 2023 22:42:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB572FB3
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 22:42:16 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A349DAB
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 15:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=RLEowjX8ViZ2xZkmO6eKWeaJZv2RyGd0AigPInmTuV0=; b=WyxKWb/mnHYDKloqWLE7BGYG2h
	vMrj+ykgwx8fhxk2+RlqM8cOTEuu1i7LXakvrR7HqJ4H7qV0Jb3pHMQezxTAKW9X5A0bE6jIer3/W
	GJ0J0LlHGAIJFH3y7X2K2WqAxDhqlME6kK2jajEcxMULKVt59mYbozvfFqftDOiTqIhIVmCOBGjkb
	Y5ktZ5ubqYzbVrrDVbkEPX2IFj8VelPXL1Vb/C6TirrHtNuGRHq6P3OlLfOGIpqICAGyIgwbGBmbI
	DelCz1QFtnDCmvdHVTIVg9MuhX+7f848DTvi6Eaeal85z4ynRmTOyltG3QKJbYIbDpfXMLrCzwrQb
	v+Ki46Xg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58558)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q3lYx-0001ct-FX; Mon, 29 May 2023 23:42:03 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q3lYn-0007O3-Qf; Mon, 29 May 2023 23:41:53 +0100
Date: Mon, 29 May 2023 23:41:53 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/6] net: mdio: add mdio_device_get() and
 mdio_device_put()
Message-ID: <ZHUqMSXp2ZJOvs4n@shell.armlinux.org.uk>
References: <ZHCGZ8IgAAwr8bla@shell.armlinux.org.uk>
 <E1q2USm-008PAO-Gx@rmk-PC.armlinux.org.uk>
 <ZHD4Yaf7fgtgOgTS@surfacebook>
 <e2c558cf-430d-40df-8829-0f68560bd22f@lunn.ch>
 <CAHp75Ve3+LsLA1x+zBLCxt7M3f1tL0bUquiG3o8-=0V3gs5_pw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHp75Ve3+LsLA1x+zBLCxt7M3f1tL0bUquiG3o8-=0V3gs5_pw@mail.gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 11:34:42PM +0300, Andy Shevchenko wrote:
> On Mon, May 29, 2023 at 6:21 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > On Fri, May 26, 2023 at 09:20:17PM +0300, andy.shevchenko@gmail.com wrote:
> > > Fri, May 26, 2023 at 11:14:24AM +0100, Russell King (Oracle) kirjoitti:
> 
> ...
> 
> > > > +static inline void mdio_device_get(struct mdio_device *mdiodev)
> > > > +{
> > > > +   get_device(&mdiodev->dev);
> > >
> > > Dunno what is the practice in net, but it makes sense to have the pattern as
> > >
> > >       if (mdiodev)
> > >               return to_mdiodev(get_device(&mdiodev->dev));
> > >
> > > which might be helpful in some cases. This approach is used in many cases in
> > > the kernel.
> >
> > The device should exist. If it does not, it is a bug, and the
> > resulting opps will help find the bug.
> 
> The main point in the returned value, the 'if' can be dropped, it's
> not a big deal.

And if you do, that results in a latent bug.

The whole point of doing the above is to cater for the case when
mdiodev is NULL. If mdiodev is NULL, provided "dev" is the first member
of mdiodev, then &mdiodev->dev will also be NULL. That will mean
get_device() will see a NULL pointer and itself return NULL. The
to_mdiodev() will then convert back to a mdiodev which will also be
NULL. So everything works correctly.

If dev is not the first member, then &mdiodev->dev will no longer be
NULL, but will be offset by that amount.

get_device() will check whether that is NULL - it won't be, so it'll
try to pass &dev->kobj to kobject_get(). That will also not be a NULL
pointer. kobject_get() will likely oops the kernel.

So no, it isn't safe to drop that if().

However, count the number of places in the kernel that actually pay
attention to the return value of get_device()...

In drivers/base, which should be the prime area where things are
done correctly, there are 42 places where get_device() is called.
Of those 42 places, 13 places make use of the returned value in
some way, which mean 29 do not bother to check.

Now, what use is checking that return value? Does get_device()
ever return anything different from what was passed in?

Well, we need to delve further down into kobject_get(), which
does not - kobject_get() returns whatever it was given. Note
that kref_get() doesn't return anything, nor does refcount_inc(),
both of which post-date get_device().

So, that in turn means that get_device() will only ever return
what it was passed. So:

	ret = get_device(dev);

`ret' is _guaranteed_ to always be exactly the same was `dev' in
all cases (except if "dev" results in get_device() performing an
invalid dereference and Oopsing the kernel, by which time we won't
care about `ret'.)

Now, if we think about situations where this will be called - they
will always be called where the MDIO device already has reference
counts against it - we have to be holding at least one refcount
to already have a reference to this device. If we don't have that,
then we're in the situation where the memory pointed to by the
mdio device pointer has probably already been freed, and could
already be used for some other purpose - and using the return value
from get_device() isn't going to save you from such a racy stupidity.

If we extend this to mdio_device_get(), then we end up in exactly
the same scenario - and what benefit does it give to the code?
Does it make the code more readable? No, it makes it less readable.
Does it make the code more robust? No, it makes no difference.
Does it make the code more correct? Again, no difference.

So, I don't see any point in changing the proposal I've put forward
as mdio_device_get().

Things would be different if get_device() used kobject_get_unless_zero()
which _can_ alter the returned value, but as I've stated above, if the
refcount were to become zero at the point that mdio_device_get() may
be called, we've *already* lost.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

