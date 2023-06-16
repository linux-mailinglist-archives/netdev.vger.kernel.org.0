Return-Path: <netdev+bounces-11477-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2CA37333F2
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 16:49:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E09021C20D69
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 14:49:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F06BF13AC9;
	Fri, 16 Jun 2023 14:49:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DD63D62
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 14:49:46 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA8930F1;
	Fri, 16 Jun 2023 07:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=VO5W5mFkgLXJm6gyeqxnjpMRqTtw3g3R0G84ncCKgdE=; b=ypHqV6En7mX+pLKENt2maPqGdc
	vDyiKOGPmCbVwmIJptuuNzLqUDoF76l9WKuTKUK6b2uiU+dKiNMmz1Vj2k8gGVxQVdEo8A4+aLaBu
	OMv1XAl78qNpGmLshByifOhrcY4l/sXbGuPf9CxPqizt9eFSaAv/hxg6S0H3ciCzgTSg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qAAlY-00GjHv-Sf; Fri, 16 Jun 2023 16:49:32 +0200
Date: Fri, 16 Jun 2023 16:49:32 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Jianhui Zhao <zhaojh329@gmail.com>
Cc: hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5] net: phy: Add sysfs attribute for PHY c45 identifiers.
Message-ID: <661044f3-9447-45c7-8bda-b9f6a667385a@lunn.ch>
References: <20230616144017.12483-1-zhaojh329@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616144017.12483-1-zhaojh329@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 10:40:17PM +0800, Jianhui Zhao wrote:
> If a phydevice use c45, its phy_id property is always 0, so
> this adds a c45_ids sysfs attribute group contains mmd id
> attributes from mmd0 to mmd31 to MDIO devices. Note that only
> mmd with valid value will exist. This attribute group can be
> useful when debugging problems related to phy drivers.
> 
> Likes this:
> /sys/bus/mdio_bus/devices/mdio-bus:05/c45_ids/mmd1
> /sys/bus/mdio_bus/devices/mdio-bus:05/c45_ids/mmd2
> ...
> /sys/bus/mdio_bus/devices/mdio-bus:05/c45_ids/mmd31
> 
> Signed-off-by: Jianhui Zhao <zhaojh329@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Russell King <linux@armlinux.org.uk>

Did you read Russells comments? And Jakubs? Please don't ignore them.

    Andrew

---
pw-bot: cr

