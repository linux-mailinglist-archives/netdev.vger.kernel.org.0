Return-Path: <netdev+bounces-4467-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A335D70D0D4
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 04:10:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E90A1C20BFF
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 02:10:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29A431C38;
	Tue, 23 May 2023 02:10:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1276D1C35
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:10:47 +0000 (UTC)
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B29CD
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 19:10:45 -0700 (PDT)
X-QQ-mid:Yeas47t1684807693t352t56282
Received: from 3DB253DBDE8942B29385B9DFB0B7E889 (jiawenwu@trustnetic.com [122.235.247.1])
X-QQ-SSF:00400000000000F0FNF000000000000
From: =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 17576591825519533520
To: "'Andy Shevchenko'" <andy.shevchenko@gmail.com>
Cc: "'Andrew Lunn'" <andrew@lunn.ch>,
	"'Michael Walle'" <michael@walle.cc>,
	"'Shreeya Patel'" <shreeya.patel@collabora.com>,
	<netdev@vger.kernel.org>,
	<jarkko.nikula@linux.intel.com>,
	<mika.westerberg@linux.intel.com>,
	<jsd@semihalf.com>,
	<Jose.Abreu@synopsys.com>,
	<hkallweit1@gmail.com>,
	<linux@armlinux.org.uk>,
	<linux-i2c@vger.kernel.org>,
	<linux-gpio@vger.kernel.org>,
	<mengyuanlou@net-swift.com>
References: <00cd01d9879f$8e444950$aaccdbf0$@trustnetic.com> <CAHp75VdthEZL6GvT5Q=f7rbcDfA5XX=7-VLfVz1kZmBFem_eCA@mail.gmail.com> <016701d9886a$f9b415a0$ed1c40e0$@trustnetic.com> <90ef7fb8-feac-4288-98e9-6e67cd38cdf1@lunn.ch> <025b01d9897e$d8894660$899bd320$@trustnetic.com> <1e1615b3-566c-490c-8b1a-78f5521ca0b0@lunn.ch> <028601d989f9$230ee120$692ca360$@trustnetic.com> <f0b571ab-544b-49c3-948f-d592f931673b@lunn.ch> <005a01d98c8b$e48d2b60$ada78220$@trustnetic.com> <005e01d98c9c$5181fb00$f485f100$@trustnetic.com> <ZGvgcdXPBy53y4mn@smile.fi.intel.com>
In-Reply-To: <ZGvgcdXPBy53y4mn@smile.fi.intel.com>
Subject: RE: [PATCH net-next v8 6/9] net: txgbe: Support GPIO to SFP socket
Date: Tue, 23 May 2023 10:08:12 +0800
Message-ID: <007701d98d1b$6d9decc0$48d9c640$@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQElTZjva91B8RKPJxABTESLbvgbBwJ7xjhgAYjDQqsBr+FHUgDJ87o1AYTHtNcC/cxtnwIXsv+OAc8FI2ACJJqqegMG4Q+ssC78MhA=
Content-Language: zh-cn
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tuesday, May 23, 2023 5:37 AM, Andy Shevchenko wrote:
> On Mon, May 22, 2023 at 06:58:19PM +0800, Jiawen Wu wrote:
> > On Monday, May 22, 2023 5:01 PM, Jiawen Wu wrote:
> > > On Friday, May 19, 2023 9:13 PM, Andrew Lunn wrote:
> > > > > I have one MSI-X interrupt for all general MAC interrupt (see TXGBE_PX_MISC_IEN_MASK).
> > > > > It has 32 bits to indicate various interrupts, GPIOs are the one of them. When GPIO
> > > > > interrupt is determined, GPIO_INT_STATUS register should be read to determine
> > > > > which GPIO line has changed state.
> > > >
> > > > So you have another interrupt controller above the GPIO interrupt
> > > > controller. regmap-gpio is pushing you towards describing this
> > > > interrupt controller as a Linux interrupt controller.
> > > >
> > > > When you look at drivers handling interrupts, most leaf interrupt
> > > > controllers are not described as Linux interrupt controllers. The
> > > > driver interrupt handler reads the interrupt status register and
> > > > internally dispatches to the needed handler. This works well when
> > > > everything is internal to one driver.
> > > >
> > > > However, here, you have two drivers involved, your MAC driver and a
> > > > GPIO driver instantiated by the MAC driver. So i think you are going
> > > > to need to described the MAC interrupt controller as a Linux interrupt
> > > > controller.
> > > >
> > > > Take a look at the mv88e6xxx driver, which does this. It has two
> > > > interrupt controller embedded within it, and they are chained.
> > >
> > > Now I add two interrupt controllers, the first one for the MAC interrupt,
> > > and the second one for regmap-gpio. In the second adding flow,
> > >
> > > 	irq = irq_find_mapping(txgbe->misc.domain, TXGBE_PX_MISC_GPIO_OFFSET);
> > > 	err = regmap_add_irq_chip_fwnode(fwnode, regmap, irq, 0, 0,
> > > 					 chip, &chip_data);
> > >
> > > and then,
> > >
> > > 	config.irq_domain = regmap_irq_get_domain(chip_data);
> > > 	gpio_regmap = gpio_regmap_register(&config);
> > >
> > > "txgbe->misc.domain" is the MAC interrupt domain. I think this flow should
> > > be correct, but still failed to get gpio_irq from gpio_desc with err -517.
> > >
> > > And I still have doubts about what I said earlier:
> > > https://lore.kernel.org/netdev/20230515063200.301026-1-
> > > jiawenwu@trustnetic.com/T/#me1be68e1a1e44426ecc0dd8edf0f6b224e50630d
> > >
> > > There really is nothing wrong with gpiochip_to_irq()??
> >
> > There is indeed something wrong in gpiochip_to_irq(), since commit 5467801 ("gpio:
> > Restrict usage of GPIO chip irq members before initialization"):
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit?id=5467801f1fcbdc46bc7298a84dbf3ca1ff2a7320
> >
> > When I use gpio_regmap_register() to add gpiochip, gpiochip_add_irqchip() will just
> > return 0 since irqchip = NULL, then gc->irq.initialized = false.
> 
> As far as I understood your hardware, you need to provide an IRQ chip for your
> GPIOs. The driver that provides an IRQ chip for GPIO and uses GPIO regmap is
> drivers/gpio/gpio-sl28cpld.c.
> 
> So, you need to create a proper IRQ domain tree before calling for GPIO
> registration.

I've already created it. There is the full code snippet:

+static int txgbe_gpio_init(struct txgbe *txgbe)
+{
+       struct regmap_irq_chip_data *chip_data;
+       struct gpio_regmap_config config = {};
+       struct gpio_regmap *gpio_regmap;
+       struct fwnode_handle *fwnode;
+       struct regmap_irq_chip *chip;
+       struct regmap *regmap;
+       struct pci_dev *pdev;
+       struct device *dev;
+       unsigned int irq;
+       struct wx *wx;
+       int err;
+
+       wx = txgbe->wx;
+       pdev = wx->pdev;
+       dev = &pdev->dev;
+       fwnode = software_node_fwnode(txgbe->nodes.group[SWNODE_GPIO]);
+
+       regmap = devm_regmap_init(dev, NULL, wx, &gpio_regmap_config);
+       if (IS_ERR(regmap)) {
+               wx_err(wx, "failed to init GPIO regmap\n");
+               return PTR_ERR(regmap);
+       }
+
+       chip = devm_kzalloc(dev, sizeof(*chip), GFP_KERNEL);
+       if (!chip)
+               return -ENOMEM;
+
+       chip->name = "txgbe-gpio-irq";
+       chip->irq_drv_data = wx;
+       chip->num_regs = 1;
+       chip->irqs = txgbe_gpio_irqs;
+       chip->num_irqs = ARRAY_SIZE(txgbe_gpio_irqs);
+       chip->status_base = WX_GPIO_INTSTATUS;
+       chip->ack_base = WX_GPIO_EOI;
+       chip->mask_base = WX_GPIO_INTMASK;
+       chip->get_irq_reg = txgbe_get_irq_reg;
+       chip->handle_post_irq = txgbe_handle_post_irq;
+
+       irq = irq_find_mapping(txgbe->misc.domain, TXGBE_PX_MISC_GPIO_OFFSET);
+       err = regmap_add_irq_chip_fwnode(fwnode, regmap, irq, 0, 0,
+                                        chip, &chip_data);
+       if (err) {
+               wx_err(wx, "GPIO IRQ register failed\n");
+               return err;
+       }
+
+       txgbe->gpio_irq = irq;
+       txgbe->gpio_data = chip_data;
+
+       config.label = devm_kasprintf(dev, GFP_KERNEL, "txgbe_gpio-%x",
+                                     (pdev->bus->number << 8) | pdev->devfn);
+       config.parent = dev;
+       config.regmap = regmap;
+       config.fwnode = fwnode;
+       config.drvdata = txgbe;
+       config.ngpio = 6;
+       config.reg_mask_xlate = txgbe_reg_mask_xlate;
+       config.reg_dat_base = WX_GPIO_EXT;
+       config.reg_set_base = WX_GPIO_DR;
+       config.reg_dir_out_base = WX_GPIO_DDR;
+       config.irq_domain = regmap_irq_get_domain(chip_data);
+
+       gpio_regmap = gpio_regmap_register(&config);
+       if (IS_ERR(gpio_regmap)) {
+               wx_err(wx, "GPIO regmap register failed\n");
+               regmap_del_irq_chip(irq, chip_data);
+               return PTR_ERR(gpio_regmap);
+       }
+
+       txgbe->gpio_regmap = gpio_regmap;
+
+       return 0;
+}

> 
> >  Cc the committer: Shreeya Patel.
> 
> You meant "author", right?

Yes, author.
I think "gpiochip_add_data" does not take gpio-regmap case into account.



