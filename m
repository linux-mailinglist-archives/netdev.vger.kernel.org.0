Return-Path: <netdev+bounces-11478-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D1EF7333FC
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 16:52:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 071132817CB
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 14:52:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A6BB13AD1;
	Fri, 16 Jun 2023 14:52:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1DE79E5
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 14:52:12 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777D9E76;
	Fri, 16 Jun 2023 07:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ijpUNgur+eQNTCOoDuLd+kFQm+/If3QgrxUzhIu13as=; b=hXpJnhhwvBkhi7JNGG/oo6nWyN
	Fn3gyQas3fwxByMQHUutNh2mowMwhyoM5PkiKEvNMoIJVp6pS/OMWTPYVb2Ep2HGj5Sb/UireUsXv
	IvqABa2Pnnx63JUo5d4wMuKJlFPOwj9eWP/vfN/TDd7hT1VmBoBfyOjEUF36JLva3iOzyIVyTXQAO
	LmBeGJb9l7i/dbNpYZmzGd7HjCpxXAKGVtWpFoPDjxVfIOEHw8JhRelecYilvBCP1C1A7SZqoz2mD
	a4LnJksCe0HTzt0HgGSsc9OncSw3lq6/yHXo2Xq8SrjrPtSQO4wBd/nUl3op/HMPA1lDM/a3PSY/r
	2oOD+NVw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42698)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1qAAo1-0005M4-Rs; Fri, 16 Jun 2023 15:52:05 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1qAAnz-0002bh-TF; Fri, 16 Jun 2023 15:52:03 +0100
Date: Fri, 16 Jun 2023 15:52:03 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Jianhui Zhao <zhaojh329@gmail.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5] net: phy: Add sysfs attribute for PHY c45 identifiers.
Message-ID: <ZIx3E/KAU0aHSxqg@shell.armlinux.org.uk>
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
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
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

NAK, because you haven't listened to all of the feedback that's been
given to you.

1. You haven't taken on my suggestion for reformatting the if().
2. You haven't updated my Reviewed-by, which in any case was conditional
   on the acceptance of all of my review comments.
3. You haven't removed Andrew's reviewed-by which he hasn't given you,
   and thus your commit message is a lie.
4. You haven't obeyed the "do not repost in under 24 hours"

I do not expect to see you post a V6 before at the very earliest Monday,
and if you do, I will NAK it purely on that point, and you will get an
even stronger email from me.

Stop adding unnecessarily to reviewers workloads.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

