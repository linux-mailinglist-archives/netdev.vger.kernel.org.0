Return-Path: <netdev+bounces-11316-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E0BB73293B
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 09:50:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ECCF2281678
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 07:50:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CFC08F7D;
	Fri, 16 Jun 2023 07:50:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B341100
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 07:50:37 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77F21FC3;
	Fri, 16 Jun 2023 00:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ZtPn0twBoFsnVfWw9nAvMqjyBKH58YZo1t1Zt+alCr4=; b=OGkP/TjU/gFkmMnUXyi8TBMVNM
	1L7FJ+1kx3qq+7DB+aMtRKkfZEEudpGP9USyLr9YedYgfNJqUA20MKYmxAnx+F3YSYiV0xainiFO8
	U7s3OgDHC438hWkVGqD9KyGGX1NYWjXAQsyx3JraMOrxT3P012Lw15OxKBBe1TkuviCLZhNqzWosK
	PSBS+tOkJkcYn3Ik4r8Mdm96wiOvHpgE3qdEiGFe27gCyy4JovWZdOBbxW4fWxuYr+ftOhG/Q81H6
	o4/s35zFdnDN1ZMXuJIhA4ucL2J69Zm6We+NLj/KBhm1MTSz8AMN7BK9HzRrFVrMVzxGvZ84V0JVW
	6n6B9iWg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59058)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1qA4E4-0004VS-CG; Fri, 16 Jun 2023 08:50:32 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1qA4E3-0002Ku-Nu; Fri, 16 Jun 2023 08:50:31 +0100
Date: Fri, 16 Jun 2023 08:50:31 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Jianhui Zhao <zhaojh329@gmail.com>, andrew@lunn.ch,
	hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] net: phy: Add sysfs attribute for PHY c45 identifiers.
Message-ID: <ZIwUR4UvJ96yE/OV@shell.armlinux.org.uk>
References: <20230614134522.11169-1-zhaojh329@gmail.com>
 <20230615224104.2b9f3adf@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615224104.2b9f3adf@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 10:41:04PM -0700, Jakub Kicinski wrote:
> On Wed, 14 Jun 2023 21:45:22 +0800 Jianhui Zhao wrote:
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > Reviewed-by: Russell King <linux@armlinux.org.uk>
> 
> Did Andrew and Russell give review tags on the list ?
> I don't see any given to v2.

Well spotted, I did not. I merely made a suggestion that the author has
picked up. The tel-tale is that my r-b line doesn't include "(Oracle)"
in this instance. That r-b will need to be removed whatever the outcome
of my further suggestion I've just sent.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

