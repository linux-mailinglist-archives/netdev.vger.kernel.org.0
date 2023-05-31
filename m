Return-Path: <netdev+bounces-6750-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 90EC8717C5C
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 11:47:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25417281473
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 09:47:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F03712B8F;
	Wed, 31 May 2023 09:47:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0405E3D64
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 09:47:53 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D8AD9;
	Wed, 31 May 2023 02:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=bfZg92z4iIPhpCvBzweOlyp4JZTKSuNewMH/vk9aswM=; b=Hjx1z9+HzkPjEH3xjuSwSvccgV
	EY1rtgdi8wEJjb4gvbD18v5xYFe6Uo7h+hz5AyKtwU89tE6pPAyzl+HPnb7IAduqcf4z4eOVTRRwP
	nC384uSNh+ABV4I3roFGfZF9ccCS980eJk7NKAHXmuDLLe9QD+ReWsaBL1Khs8XNRp20UB8/9Tr7G
	lFP54b3E0P1f9tVdJ5WNzADihEX18fIkiythcK+6E3euvwq7plMtjTuUubOyVtpckimOEp/NaDxf6
	ftKL/KbTGkhyDuTxDLbLQfTz+K6d/kASylC7LM2aLj0GNh17NiURHe61ugqllN7tJjBbQdhXQJ41f
	raEg425Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52920)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q4IQj-0004Gx-N5; Wed, 31 May 2023 10:47:45 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q4IQf-0000Zd-0D; Wed, 31 May 2023 10:47:41 +0100
Date: Wed, 31 May 2023 10:47:40 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Jiawen Wu <jiawenwu@trustnetic.com>
Cc: 'kernel test robot' <lkp@intel.com>, netdev@vger.kernel.org,
	jarkko.nikula@linux.intel.com, andriy.shevchenko@linux.intel.com,
	mika.westerberg@linux.intel.com, jsd@semihalf.com,
	Jose.Abreu@synopsys.com, andrew@lunn.ch, hkallweit1@gmail.com,
	oe-kbuild-all@lists.linux.dev, linux-i2c@vger.kernel.org,
	linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com,
	'Piotr Raczynski' <piotr.raczynski@intel.com>
Subject: Re: [PATCH net-next v9 5/9] net: txgbe: Add SFP module identify
Message-ID: <ZHcXvFvR3H8Vmyok@shell.armlinux.org.uk>
References: <20230524091722.522118-6-jiawenwu@trustnetic.com>
 <202305261959.mnGUW17n-lkp@intel.com>
 <ZHCZ0hLKARXu3xFH@shell.armlinux.org.uk>
 <02dd01d991d2$2120fcf0$6362f6d0$@trustnetic.com>
 <03ac01d992d2$67c1ec90$3745c5b0$@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03ac01d992d2$67c1ec90$3745c5b0$@trustnetic.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 04:40:36PM +0800, Jiawen Wu wrote:
> On Monday, May 29, 2023 10:06 AM, Jiawen Wu wrote:
> > On Friday, May 26, 2023 7:37 PM, Russell King (Oracle) wrote:
> > > On Fri, May 26, 2023 at 07:30:45PM +0800, kernel test robot wrote:
> > > > Kconfig warnings: (for reference only)
> > > >    WARNING: unmet direct dependencies detected for I2C_DESIGNWARE_PLATFORM
> > > >    Depends on [n]: I2C [=n] && HAS_IOMEM [=y] && (ACPI && COMMON_CLK [=y] || !ACPI)
> > > >    Selected by [y]:
> > > >    - TXGBE [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_WANGXUN [=y] && PCI [=y]
> > > >    WARNING: unmet direct dependencies detected for SFP
> > > >    Depends on [n]: NETDEVICES [=y] && PHYLIB [=y] && I2C [=n] && PHYLINK [=y] && (HWMON [=n] || HWMON [=n]=n)
> > > >    Selected by [y]:
> > > >    - TXGBE [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_WANGXUN [=y] && PCI [=y]
> > >
> > > ... and is basically caused by "select SFP". No. Do not do this unless
> > > you look at the dependencies for SFP and ensure that those are also
> > > satisfied - because if you don't you create messes like the above
> > > build errors.
> > 
> > So how do I make sure that the module I need compiles and loads correctly,
> > rely on the user to manually select it?
> 
> When I changed the TXGBE config to:
> ...
> 	depends on SFP
> 	select PCS_XPCS
> ...
> the compilation gave an error:
> 
> drivers/net/phy/Kconfig:16:error: recursive dependency detected!
> drivers/net/phy/Kconfig:16:     symbol PHYLIB is selected by PHYLINK
> drivers/net/phy/Kconfig:6:      symbol PHYLINK is selected by PCS_XPCS
> drivers/net/pcs/Kconfig:8:      symbol PCS_XPCS is selected by TXGBE
> drivers/net/ethernet/wangxun/Kconfig:40:        symbol TXGBE depends on SFP
> drivers/net/phy/Kconfig:63:     symbol SFP depends on PHYLIB
> For a resolution refer to Documentation/kbuild/kconfig-language.rst
> subsection "Kconfig recursive dependency limitations"
> 
> Seems deleting "depends on SFP" is the correct way. But is this normal?
> How do we ensure the dependency between TXGBE and SFP?

First, I would do this:

	select PHYLINK
	select PCS_XPCS

but then I'm principled, and I don't agree that PCS_XPCS should be
selecting PHYLINK.

The second thing I don't particularly like is selecting user visible
symbols, but as I understand it, with TXGBE, the SFP slot is not an
optional feature, so there's little option.

So, because SFP requires I2C:

	select I2C
	select SFP

That is basically what I meant by "you look at the dependencies for
SFP and ensure that those are also satisfied".

Adding that "select I2C" also solves the unmet dependencies for
I2C_DESIGNWARE_PLATFORM.

However, even with that, we're not done with the evilness of select,
because there's one more permitted configuration combination that
will break.

If you build TXGBE into the kernel, that will force SFP=y, I2C=y,
PHYLINK=y, PHYLIB=y. So far so good. However, if HWMON=m, then things
will again break. So I would also suggest:

	select HWMON if TXGBE=y

even though you don't require it, it solves the build fallout from
where HWMON=m but you force SFP=y.

Maybe someone else has better ideas how to do this, but the above is
the best I can come up with.


IMHO, select is nothing but pure evil, and should be used with utmost
care and a full understanding of its ramifications, and a realisation
that it *totally* and *utterly* blows away any "depends on" on the
target of the select statement.

An option that states that it depends on something else generally does
because... oddly enough, it _depends_ on that other option. So, if
select forces an option on without its dependencies, then it's not
surprising that stuff fails to build.

Whenever a select statement is added, one must _always_ look at the
target symbol and consider any "depends on" there, and how to ensure
that those dependencies are guaranteed to always be satisfied.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

