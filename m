Return-Path: <netdev+bounces-5036-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9159670F7BC
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:36:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 55D221C20CE6
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 13:36:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3306182BF;
	Wed, 24 May 2023 13:36:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989D11774E
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 13:36:47 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A6A132;
	Wed, 24 May 2023 06:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ECySvPIgegu4Sj8aDCP+tqf0nmw3GutStZtWX6wbB84=; b=UYd7xh000gsUuibwqVs1szml7Z
	vGZFhPeHkV+3BtYtd4HsKZNqPTLJ37fCK2L1aq4uw4d5dbhT0Zc4uUBgtPjy7MWj8bAndzB0qr7Iw
	89JcoBSaVz8XvdaG+5zqM/UedcJk9nex+rUfRNXXlY8xbi6rkLCmvqEfIv/niX4UEQMikLwAM0RP6
	gUL1zB+55T5WDv+m/ZGvWth27dn+qxWhknT/czUqPYPZ6P/PI1Iddc91G9CPX7pTIOCBS/TEJA471
	v2uX1oAHT4RjDUrT0X2M/vEi1Z4wne2vOj+5yCNwu/iGEACRL3VWYcMeiJa3WKGlrycYgZ3hwqAHL
	E+DSVxnQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45404)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q1ofH-0002R4-W4; Wed, 24 May 2023 14:36:32 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q1ofG-0001fJ-0V; Wed, 24 May 2023 14:36:30 +0100
Date: Wed, 24 May 2023 14:36:29 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Alexis =?iso-8859-1?Q?Lothor=E9?= <alexis.lothore@bootlin.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, devicetree@vger.kernel.org,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	paul.arola@telus.com, scott.roberts@telus.com,
	Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH net-next v3 7/7] net: dsa: mv88e6xxx: enable support for
 88E6361 switch
Message-ID: <ZG4S3QuT6ava3U72@shell.armlinux.org.uk>
References: <20230524130127.268201-1-alexis.lothore@bootlin.com>
 <20230524130127.268201-8-alexis.lothore@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230524130127.268201-8-alexis.lothore@bootlin.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 03:01:27PM +0200, Alexis Lothoré wrote:
> diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
> index 3c9fc17abdd2..56dfa9d3d4e0 100644
> --- a/drivers/net/dsa/mv88e6xxx/port.h
> +++ b/drivers/net/dsa/mv88e6xxx/port.h
> @@ -138,6 +138,7 @@
>  #define MV88E6XXX_PORT_SWITCH_ID_PROD_6141	0x3400
>  #define MV88E6XXX_PORT_SWITCH_ID_PROD_6341	0x3410
>  #define MV88E6XXX_PORT_SWITCH_ID_PROD_6352	0x3520
> +#define MV88E6XXX_PORT_SWITCH_ID_PROD_6361	0x2610
>  #define MV88E6XXX_PORT_SWITCH_ID_PROD_6350	0x3710
>  #define MV88E6XXX_PORT_SWITCH_ID_PROD_6351	0x3750
>  #define MV88E6XXX_PORT_SWITCH_ID_PROD_6390	0x3900

This list is ordered by the value in the register. The value you are
adding is 0x2610, which is not ordered between 0x3520 and 0x3710.
Please move this to be after the definition for
MV88E6XXX_PORT_SWITCH_ID_PROD_6250. Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

