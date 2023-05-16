Return-Path: <netdev+bounces-2951-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC465704ACA
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:35:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A5CC28175B
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:35:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3655D209B1;
	Tue, 16 May 2023 10:31:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1FC261E8
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 10:31:57 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0F8558D;
	Tue, 16 May 2023 03:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=7BbKaGK0k3mMet6w52ykKHKxgzU5is36rQuBtebxFzY=; b=GQ9oVxlA9O4SkwGrcpKP1ccZLQ
	/82beaQrLsALoQv6tV+/5hCmu5PPVr4n6y12QOkzOblA6MW/ZCdugnKbOxjJx2AWUlBPg6qo0+PfS
	PDEB89Be3IvidOhxWpuojouKGQQzZjUTLP4l0hy7RuLzt4XKs+LlJZMjZJk8MC+1DIl1w4gzr03Lq
	a20bWszy5itdO7hyeKoMC/jjpVh2Y/8JLwQB8rVOzYqTOVlGswoIdtGoVxmZLVYB4O3b+LYDZylxl
	4BbcFxdlUBFyLXoUYRq1seXpu7Zg3DXAo3L5eHrb1vE9zLwdf8J9d3FdJFx0dLdr3nqR8QZfD7w1i
	7PN4pQAQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34894)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1pyrxg-0005Yd-45; Tue, 16 May 2023 11:31:20 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1pyrxX-0000jQ-Q8; Tue, 16 May 2023 11:31:11 +0100
Date: Tue, 16 May 2023 11:31:11 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
	Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org,
	jarkko.nikula@linux.intel.com, andriy.shevchenko@linux.intel.com,
	mika.westerberg@linux.intel.com, jsd@semihalf.com,
	Jose.Abreu@synopsys.com, andrew@lunn.ch, hkallweit1@gmail.com,
	linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
	mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v8 6/9] net: txgbe: Support GPIO to SFP socket
Message-ID: <ZGNbb2Oe9aLIT04p@shell.armlinux.org.uk>
References: <20230515063200.301026-1-jiawenwu@trustnetic.com>
 <20230515063200.301026-7-jiawenwu@trustnetic.com>
 <ZGH-fRzbGd_eCASk@surfacebook>
 <00cd01d9879f$8e444950$aaccdbf0$@trustnetic.com>
 <CAHp75VdthEZL6GvT5Q=f7rbcDfA5XX=7-VLfVz1kZmBFem_eCA@mail.gmail.com>
 <aed598bbe094633859f477dd99ff7d086261b071.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aed598bbe094633859f477dd99ff7d086261b071.camel@redhat.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 11:39:08AM +0200, Paolo Abeni wrote:
> On Tue, 2023-05-16 at 10:12 +0300, Andy Shevchenko wrote:
> > On Tue, May 16, 2023 at 5:39 AM Jiawen Wu <jiawenwu@trustnetic.com> wrote:
> > 
> > ...
> > 
> > > > > +   struct gpio_irq_chip *girq;
> > > > > +   struct wx *wx = txgbe->wx;
> > > > > +   struct gpio_chip *gc;
> > > > > +   struct device *dev;
> > > > > +   int ret;
> > > > 
> > > > > +   dev = &wx->pdev->dev;
> > > > 
> > > > This can be united with the defintion above.
> > > > 
> > > >       struct device *dev = &wx->pdev->dev;
> > > > 
> > > 
> > > This is a question that I often run into, when I want to keep this order,
> > > i.e. lines longest to shortest, but the line of the pointer which get later
> > > is longer. For this example:
> > > 
> > >         struct wx *wx = txgbe->wx;
> > >         struct device *dev = &wx->pdev->dev;
> > 
> > So, we locate assignments according to the flow. I do not see an issue here.
> 
> That would break the reverse x-mass tree order.
> 
> > > should I split the line, or put the long line abruptly there?
> > 
> > The latter is fine.
> 
> This is minor, but I have to disagree. My understanding is that
> respecting the reversed x-mass tree is preferred. In case of dependent
> initialization as the above, the preferred style it the one used by
> this patch.

Meanwhile, I've been told something completely different, and therefore
I do something else, namely:


	struct device *dev;
	struct wx *wx;

	wx = txgbe->wx;
	dev = &wx->pdev->dev;

	...

I've been lead to believe that this is preferred in netdev to breaking
the reverse christmas-tree due to dependent initialisations.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

