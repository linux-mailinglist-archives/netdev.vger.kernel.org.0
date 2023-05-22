Return-Path: <netdev+bounces-4433-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 97CC770CC9B
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 23:37:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 317FE1C20BDD
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 21:36:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D3C2174E6;
	Mon, 22 May 2023 21:36:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5F1174D3
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 21:36:57 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0355D9B;
	Mon, 22 May 2023 14:36:55 -0700 (PDT)
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="381289254"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="381289254"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 14:36:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="706697813"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="706697813"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga007.fm.intel.com with ESMTP; 22 May 2023 14:36:51 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
	(envelope-from <andy.shevchenko@gmail.com>)
	id 1q1DCz-000Eqx-33;
	Tue, 23 May 2023 00:36:49 +0300
Date: Tue, 23 May 2023 00:36:49 +0300
From: 'Andy Shevchenko' <andy.shevchenko@gmail.com>
To: Jiawen Wu <jiawenwu@trustnetic.com>
Cc: 'Andrew Lunn' <andrew@lunn.ch>, 'Michael Walle' <michael@walle.cc>,
	'Shreeya Patel' <shreeya.patel@collabora.com>,
	netdev@vger.kernel.org, jarkko.nikula@linux.intel.com,
	mika.westerberg@linux.intel.com, jsd@semihalf.com,
	Jose.Abreu@synopsys.com, hkallweit1@gmail.com,
	linux@armlinux.org.uk, linux-i2c@vger.kernel.org,
	linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v8 6/9] net: txgbe: Support GPIO to SFP socket
Message-ID: <ZGvgcdXPBy53y4mn@smile.fi.intel.com>
References: <00cd01d9879f$8e444950$aaccdbf0$@trustnetic.com>
 <CAHp75VdthEZL6GvT5Q=f7rbcDfA5XX=7-VLfVz1kZmBFem_eCA@mail.gmail.com>
 <016701d9886a$f9b415a0$ed1c40e0$@trustnetic.com>
 <90ef7fb8-feac-4288-98e9-6e67cd38cdf1@lunn.ch>
 <025b01d9897e$d8894660$899bd320$@trustnetic.com>
 <1e1615b3-566c-490c-8b1a-78f5521ca0b0@lunn.ch>
 <028601d989f9$230ee120$692ca360$@trustnetic.com>
 <f0b571ab-544b-49c3-948f-d592f931673b@lunn.ch>
 <005a01d98c8b$e48d2b60$ada78220$@trustnetic.com>
 <005e01d98c9c$5181fb00$f485f100$@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <005e01d98c9c$5181fb00$f485f100$@trustnetic.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_SOFTFAIL,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 06:58:19PM +0800, Jiawen Wu wrote:
> On Monday, May 22, 2023 5:01 PM, Jiawen Wu wrote:
> > On Friday, May 19, 2023 9:13 PM, Andrew Lunn wrote:
> > > > I have one MSI-X interrupt for all general MAC interrupt (see TXGBE_PX_MISC_IEN_MASK).
> > > > It has 32 bits to indicate various interrupts, GPIOs are the one of them. When GPIO
> > > > interrupt is determined, GPIO_INT_STATUS register should be read to determine
> > > > which GPIO line has changed state.
> > >
> > > So you have another interrupt controller above the GPIO interrupt
> > > controller. regmap-gpio is pushing you towards describing this
> > > interrupt controller as a Linux interrupt controller.
> > >
> > > When you look at drivers handling interrupts, most leaf interrupt
> > > controllers are not described as Linux interrupt controllers. The
> > > driver interrupt handler reads the interrupt status register and
> > > internally dispatches to the needed handler. This works well when
> > > everything is internal to one driver.
> > >
> > > However, here, you have two drivers involved, your MAC driver and a
> > > GPIO driver instantiated by the MAC driver. So i think you are going
> > > to need to described the MAC interrupt controller as a Linux interrupt
> > > controller.
> > >
> > > Take a look at the mv88e6xxx driver, which does this. It has two
> > > interrupt controller embedded within it, and they are chained.
> > 
> > Now I add two interrupt controllers, the first one for the MAC interrupt,
> > and the second one for regmap-gpio. In the second adding flow,
> > 
> > 	irq = irq_find_mapping(txgbe->misc.domain, TXGBE_PX_MISC_GPIO_OFFSET);
> > 	err = regmap_add_irq_chip_fwnode(fwnode, regmap, irq, 0, 0,
> > 					 chip, &chip_data);
> > 
> > and then,
> > 
> > 	config.irq_domain = regmap_irq_get_domain(chip_data);
> > 	gpio_regmap = gpio_regmap_register(&config);
> > 
> > "txgbe->misc.domain" is the MAC interrupt domain. I think this flow should
> > be correct, but still failed to get gpio_irq from gpio_desc with err -517.
> > 
> > And I still have doubts about what I said earlier:
> > https://lore.kernel.org/netdev/20230515063200.301026-1-
> > jiawenwu@trustnetic.com/T/#me1be68e1a1e44426ecc0dd8edf0f6b224e50630d
> > 
> > There really is nothing wrong with gpiochip_to_irq()??
> 
> There is indeed something wrong in gpiochip_to_irq(), since commit 5467801 ("gpio:
> Restrict usage of GPIO chip irq members before initialization"):
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit?id=5467801f1fcbdc46bc7298a84dbf3ca1ff2a7320
> 
> When I use gpio_regmap_register() to add gpiochip, gpiochip_add_irqchip() will just
> return 0 since irqchip = NULL, then gc->irq.initialized = false.

As far as I understood your hardware, you need to provide an IRQ chip for your
GPIOs. The driver that provides an IRQ chip for GPIO and uses GPIO regmap is
drivers/gpio/gpio-sl28cpld.c.

So, you need to create a proper IRQ domain tree before calling for GPIO
registration.

>  Cc the committer: Shreeya Patel.

You meant "author", right?

-- 
With Best Regards,
Andy Shevchenko



