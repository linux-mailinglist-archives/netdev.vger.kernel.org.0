Return-Path: <netdev+bounces-11470-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB994733333
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 16:11:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B4391C20AE1
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 14:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08F9319E46;
	Fri, 16 Jun 2023 14:11:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A7718C11
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 14:11:15 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B12270B;
	Fri, 16 Jun 2023 07:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=f2zoZFIKwsuuxQeUL2pMznNKzcRNsuLpC9DC4rq9Kd4=; b=sRbB+gm9J+k/h7tGXBoM3O32UK
	47bO4ivkcygrgnnqzkqpw1Cx628Y6DZTopXQDGrRufublNCW4vSTL3EGBfsvAQUUwAf8GL+uIN3h3
	zkd7/yLGVHuRQ+xSTOKidEs3AQHNgtgHJCuyl57pACxj/l8kWOLSuTN/cg5iw5nNT/pmqGmT0jWDm
	3ZS0rOsHB3z4i+6z3K8JyWff2DQxFAkhBLIchXxgS0SYJ8pUiyhxub4pk3oUfnHeN/+xS+P6JI7yz
	TxtXMFVzXUQXLNtPkGlO0DykpPxXZ6f/oi8sMW3PQPrsSaN5xaNRFEat4dqS20HZ1Ty7J71/I0MnX
	NDMTixZQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54156)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1qAAAP-0005Ia-TA; Fri, 16 Jun 2023 15:11:09 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1qAAAO-0002aH-HU; Fri, 16 Jun 2023 15:11:08 +0100
Date: Fri, 16 Jun 2023 15:11:08 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Jianhui Zhao <zhaojh329@gmail.com>
Cc: andrew@lunn.ch, davem@davemloft.net, edumazet@google.com,
	hkallweit1@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH V4] net: phy: Add sysfs attribute for PHY c45 identifiers.
Message-ID: <ZIxtfFTYaX2yxlFO@shell.armlinux.org.uk>
References: <20230616131246.41989-1-zhaojh329@gmail.com>
 <20230616135455.1985-1-zhaojh329@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616135455.1985-1-zhaojh329@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 09:54:55PM +0800, Jianhui Zhao wrote:
> >+	struct phy_c45_devid_attribute *devattr =
> >+		container_of(attr, struct phy_c45_devid_attribute, attr);
> 
> >+	struct phy_c45_devid_attribute *devattr =
> >+		(struct phy_c45_devid_attribute *)container_of(attr, struct device_attribute, attr);
> 
> The two conversions is not same.

You're right...

> One is convert "struct device_attribute" to "struct phy_c45_devid_attribute",
> and another one is convert "struct attribute" to "struct phy_c45_devid_attribute".
> The second one must cast "struct device_attribute" returned from container_of
> to "struct phy_c45_devid_attribute".

... but this isn't entirely correct.

Doing it properly:

	struct phy_c45_devid_attribute *devattr =
		container_of(attr, struct phy_c45_devid_attribute, attr.attr);

Number one rule with C programming: if you have to cast, you're
probably doing something wrong, so always look to see if there's an
alternative solution that doesn't involve casts.

Casts are one of the reasons why programming errors happen - it stops
the compiler being able to perform proper type checking. Always avoid
them as much as possible.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

