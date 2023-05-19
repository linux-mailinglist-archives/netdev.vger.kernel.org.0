Return-Path: <netdev+bounces-3937-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D42E709A41
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 16:44:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDA18280FCA
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 14:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0E67C2D8;
	Fri, 19 May 2023 14:44:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E278B5679
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 14:44:02 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855FC1712;
	Fri, 19 May 2023 07:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=SrYt/TmXcYSZJ0qc+BU3zpQlSOXKm50XV33yjSp/Dhw=; b=VNLQPDrEVMNa2yj65Ly2Lsbf+q
	SpBw1GZAzHirj99IDNnfNDZdUZfegYrwuWCUxVEtOBDQdYrdAcujm/YJqCWGYVhaeqksCLldNWMo9
	fm/l8Bx89JscJtEK9UUjeo9dNarhVO4AGVMDcJw5MyEi0ZXHg7K4xMTQaHhk5UIb4qFenYQUurCfT
	gBXXOj1lm8G3aGYHamkfdLmI/ELAdiIMpocsaafneGR/dIBAvLHLCKe+H6Ancj/X7F3BITxZE+NtJ
	kjUOCNRudWOV+578xkIwNMwEhBXwv31KKEN06lN0eMnwHd6x5lxq35K8DlKFqdu6+11pe7j3B8+8m
	KjlO6oSQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41190)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q01KM-00031X-VB; Fri, 19 May 2023 15:43:30 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q01KL-0004hb-EB; Fri, 19 May 2023 15:43:29 +0100
Date: Fri, 19 May 2023 15:43:29 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: alexis.lothore@bootlin.com
Cc: Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>, netdev@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	thomas.petazzoni@bootlin.com, paul.arola@telus.com,
	scott.roberts@telus.com,
	Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH net-next v2 7/7] net: dsa: mv88e6xxx: enable support for
 88E6361 switch
Message-ID: <ZGeLEbcCHzOASasC@shell.armlinux.org.uk>
References: <20230519141303.245235-1-alexis.lothore@bootlin.com>
 <20230519141303.245235-8-alexis.lothore@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230519141303.245235-8-alexis.lothore@bootlin.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 04:13:03PM +0200, alexis.lothore@bootlin.com wrote:
> From: Alexis Lothoré <alexis.lothore@bootlin.com>
> 
> Marvell 88E6361 is an 8-port switch derived from the
> 88E6393X/88E9193X/88E6191X switches family. It can benefit from the
> existing mv88e6xxx driver by simply adding the proper switch description in
> the driver. Main differences with other switches from this
> family are:
> - 8 ports exposed (instead of 11): ports 1, 2 and 8 not available
> - No 5GBase-x nor SFI/USXGMII support
> 
> ---
> Changes since v1:
> - define internal phys offset
> - enforce 88e6361 features in mv88e6393x_phylink_get_caps
> - enforce 88e6361 features in mv88e6393x_port_set_speed_duplex
> - enforce 88e6361 features in mv88e6393x_port_max_speed_mode

Not exactly related to this patch, but please do not rely on this "max
speed mode" - please always ensure that you specify the phy-mode and
fixed-link settings for CPU and DSA ports in firmware. Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

