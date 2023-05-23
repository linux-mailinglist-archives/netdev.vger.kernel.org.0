Return-Path: <netdev+bounces-4564-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BC6070D3CB
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 08:16:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 840A01C20C29
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 06:16:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76A371C748;
	Tue, 23 May 2023 06:16:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4DF1C745
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 06:16:35 +0000 (UTC)
X-Greylist: delayed 68964 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 22 May 2023 23:16:19 PDT
Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CFC130
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 23:16:19 -0700 (PDT)
X-QQ-mid:Yeas53t1684822370t593t46247
Received: from 3DB253DBDE8942B29385B9DFB0B7E889 (jiawenwu@trustnetic.com [122.235.247.1])
X-QQ-SSF:00400000000000F0FNF000000000000
From: =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 4582806537518009441
To: "'Andrew Lunn'" <andrew@lunn.ch>,
	"'Michael Walle'" <michael@walle.cc>,
	"'Andy Shevchenko'" <andy.shevchenko@gmail.com>
Cc: <netdev@vger.kernel.org>,
	<jarkko.nikula@linux.intel.com>,
	<andriy.shevchenko@linux.intel.com>,
	<mika.westerberg@linux.intel.com>,
	<jsd@semihalf.com>,
	<Jose.Abreu@synopsys.com>,
	<hkallweit1@gmail.com>,
	<linux@armlinux.org.uk>,
	<linux-i2c@vger.kernel.org>,
	<linux-gpio@vger.kernel.org>,
	<mengyuanlou@net-swift.com>
References: <20230515063200.301026-1-jiawenwu@trustnetic.com> <20230515063200.301026-7-jiawenwu@trustnetic.com> <ZGH-fRzbGd_eCASk@surfacebook> <00cd01d9879f$8e444950$aaccdbf0$@trustnetic.com> <CAHp75VdthEZL6GvT5Q=f7rbcDfA5XX=7-VLfVz1kZmBFem_eCA@mail.gmail.com> <016701d9886a$f9b415a0$ed1c40e0$@trustnetic.com> <90ef7fb8-feac-4288-98e9-6e67cd38cdf1@lunn.ch> <025b01d9897e$d8894660$899bd320$@trustnetic.com> <1e1615b3-566c-490c-8b1a-78f5521ca0b0@lunn.ch> <028601d989f9$230ee120$692ca360$@trustnetic.com> <f0b571ab-544b-49c3-948f-d592f931673b@lunn.ch> <005a01d98c8b$e48d2b60$ada78220$@trustnetic.com>
In-Reply-To: <005a01d98c8b$e48d2b60$ada78220$@trustnetic.com>
Subject: RE: [PATCH net-next v8 6/9] net: txgbe: Support GPIO to SFP socket
Date: Tue, 23 May 2023 14:12:49 +0800
Message-ID: <011c01d98d3d$99e6c6e0$cdb454a0$@trustnetic.com>
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
Thread-Index: AQHvj8QD3pC+6Aq9H9h6P1+q5LrHRgMH5FTyAkITzAABJU2Y7wJ7xjhgAYjDQqsBr+FHUgDJ87o1AYTHtNcC/cxtnwIXsv+OAc8FI2CukHcOoA==
Content-Language: zh-cn
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
	RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> > > > If you are getting errors when removing the driver it means you are
> > > > missing some level of undoing what us done in probe. Are you sure
> > > > regmap_del_irq_chip() is being called on unload?
> > >
> > > I used devm_* all when I registered them.
> >
> > Look at the ordering. Is regmap_del_irq_chip() being called too late?
> > I've had problems like this with the mv88e6xxx driver and its
> > interrupt controllers. I ended up not using devm_ so i had full
> > control over the order things got undone. In that case, the external
> > devices was PHYs, with the PHY interrupt being inside the Ethernet
> > switch, which i exposed using a Linux interrupt controller.
> 
> I use no devm_ functions to add regmap irq chip, register gpio regmap,
> and call their del/unregister functions at the position corresponding to
> release. irq_domain_remove() call trace still exist.
> 
> [  104.553182] Call Trace:
> [  104.553184]  <TASK>
> [  104.553185]  irq_domain_remove+0x2b/0xe0
> [  104.553190]  regmap_del_irq_chip.part.0+0x8a/0x160
> [  104.553196]  txgbe_remove_phy+0x57/0x80 [txgbe]
> [  104.553201]  txgbe_remove+0x2a/0x90 [txgbe]
> [  104.553205]  pci_device_remove+0x36/0xa0
> [  104.553208]  device_release_driver_internal+0xaa/0x140
> [  104.553213]  driver_detach+0x44/0x90
> [  104.553215]  bus_remove_driver+0x69/0xf0
> [  104.553217]  pci_unregister_driver+0x29/0xb0
> [  104.553220]  __x64_sys_delete_module+0x145/0x240
> [  104.553223]  ? exit_to_user_mode_prepare+0x3c/0x1a0
> [  104.553226]  do_syscall_64+0x3b/0x90
> [  104.553230]  entry_SYSCALL_64_after_hwframe+0x72/0xdc

I think this problem is caused by a conflict calling of irq_domain_remove()
between the two functions gpiochip_irqchip_remove() and regmap_del_irq_chip().
The front one is called by gpio_regmap_unregister().

I adjusted the order of release functions, regmap_del_irq_chip() first, then
gpio_regmap_unregister(). Log became:

[  383.261168] Call Trace:
[  383.261169]  <TASK>
[  383.261170]  irq_domain_remove+0x2b/0xe0
[  383.261174]  gpiochip_irqchip_remove+0xf0/0x210
[  383.261177]  gpiochip_remove+0x4a/0x110
[  383.261181]  gpio_regmap_unregister+0x12/0x20 [gpio_regmap]
[  383.261186]  txgbe_remove_phy+0x57/0x80 [txgbe]
[  383.261190]  txgbe_remove+0x2a/0x90 [txgbe]

irq_domain_remove() just free the memory of irq_domain, but its pointer address
still exists. So it will be called twice.



