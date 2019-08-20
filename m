Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD7D395944
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 10:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbfHTIRi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 20 Aug 2019 04:17:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:51140 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729150AbfHTIRh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 04:17:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6F5DEAEA1;
        Tue, 20 Aug 2019 08:17:35 +0000 (UTC)
Date:   Tue, 20 Aug 2019 10:17:34 +0200
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        Evgeniy Polyakov <zbr@ioremap.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-input@vger.kernel.org, netdev@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH v5 15/17] mfd: ioc3: Add driver for SGI IOC3 chip
Message-Id: <20190820101734.bffe41588e0c92094b9dba3d@suse.de>
In-Reply-To: <20190820062308.GK3545@piout.net>
References: <20190819163144.3478-1-tbogendoerfer@suse.de>
        <20190819163144.3478-16-tbogendoerfer@suse.de>
        <20190820062308.GK3545@piout.net>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Aug 2019 08:23:08 +0200
Alexandre Belloni <alexandre.belloni@bootlin.com> wrote:
> On 19/08/2019 18:31:38+0200, Thomas Bogendoerfer wrote:
> > diff --git a/drivers/mfd/ioc3.c b/drivers/mfd/ioc3.c
> > new file mode 100644
> > index 000000000000..5bcb3461a189
> > --- /dev/null
> > +++ b/drivers/mfd/ioc3.c
> > @@ -0,0 +1,586 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * SGI IOC3 multifunction device driver
> > + *
> > + * Copyright (C) 2018, 2019 Thomas Bogendoerfer <tbogendoerfer@suse.de>
> > + *
> > + * Based on work by:
> > + *   Stanislaw Skowronek <skylark@unaligned.org>
> > + *   Joshua Kinard <kumba@gentoo.org>
> > + *   Brent Casavant <bcasavan@sgi.com> - IOC4 master driver
> > + *   Pat Gefre <pfg@sgi.com> - IOC3 serial port IRQ demuxer
> > + */
> > +
> > +#include <linux/delay.h>
> > +#include <linux/errno.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/mfd/core.h>
> > +#include <linux/module.h>
> > +#include <linux/pci.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/platform_data/sgi-w1.h>
> > +#include <linux/rtc/ds1685.h>
> I don't think this include is necessary.

you are right. I'll move it to the patch where IP30 systemboard gets added.

Thanks,
Thomas.

-- 
SUSE Linux GmbH
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
