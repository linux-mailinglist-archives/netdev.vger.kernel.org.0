Return-Path: <netdev+bounces-4900-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BDCB70F136
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 10:40:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C98812811CC
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 08:40:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E006E8472;
	Wed, 24 May 2023 08:40:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21351C11
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:40:47 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7591996
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 01:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Zj/rj1W5GDyX6E1to52dr4HHArh9ndJwSjRT7CRzcWI=; b=xD47W7anwbtoKXOnU/FJLmzi/y
	vUMgCMwZXWA8EGjeqMDXabYrlr6qsysyu8qYLBpjWrBXvXU31TviEwJXUMGnnW0/s03EeD+a7EK8b
	t8zyursi9UuOKoQtpn23wPbkVzs+yHbOzLsJRM6mjqJfTP6IYbY9PV6d3LrdclwU0FOvWgh0RzueW
	vtsTPWPxCCMXdXxjDGzSQFygKsfa9DdL5VpBIOTZaj0Kj5yxO0oPu/4XucMliXJL9tqGdbbpDPHfa
	z1T+MXv+TejihjMOjKRXiB7U8O9YzoJU3Onqwdr5T+jpCHtf+zuuRmYx7Xluj0K5Z4SwoKdzobmpR
	BBMKXjUg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47910)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q1k2o-0001x6-RH; Wed, 24 May 2023 09:40:30 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q1k2l-0001Tm-F1; Wed, 24 May 2023 09:40:27 +0100
Date: Wed, 24 May 2023 09:40:27 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Genevieve Chan <genevieve.chan@starfivetech.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
	"ddaney@caviumnetworks.com" <ddaney@caviumnetworks.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Marvell_of_reg_init function
Message-ID: <ZG3Ne7wOo3SeSZTp@shell.armlinux.org.uk>
References: <8eb8860a698b453788c29d43c6e3f239@EXMBX172.cuchost.com>
 <907b769ca48a482eaf727b89ead56db4@EXMBX172.cuchost.com>
 <ace88928-93b3-72fe-59e5-c7b5b7527f5e@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ace88928-93b3-72fe-59e5-c7b5b7527f5e@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 08:38:43AM +0200, Heiner Kallweit wrote:
> On 24.05.2023 08:13, Genevieve Chan wrote:
> > ++
> > 
> > Hi Heiner,
> > 
> >  
> > 
> > Hope you’re doing well. I am Genevieve Chan, a linux junior software developer for RISC-V based processor. As mentioned in the email thread below, I have came across a possible issue when attempting to issue reg-init onto Page 0 Reg 4, involving advertisement register of PHY. I have stated the observation and the root cause and possible solution. Would like to ask if this proposed solution is probable and I could submit a patch for this?
> > 
> 
> Please address all phylib maintainers and the netdev mailing list.
> 
> You should start with explaining why you want to set these registers,
> and why via device tree. There should never be the need to manually
> fiddle with C22 standard registers via device tree.
> 
> If you need a specific register initialization for a particular PHY,
> then the config_init callback of the PHY driver typically is the right
> place.
> 
> And no, generic code should not query vendor-specific DT properties.

To Genevieve Chan...

Page 0 register 4 is a register that is managed by the phylib code on
behalf of the network driver. Attempting to configuring it (or any
register managed by phylib, e.g. for advertisement) via the of_reg_init
will not work as phylib will overwrite it. Doing so is intended not to
work, isn't supported, and any value written will be overwritten by
phylib or the PHY driver.

If you wish to change the advertisement, that has to be done via the
"ethtool" userspace utility.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

