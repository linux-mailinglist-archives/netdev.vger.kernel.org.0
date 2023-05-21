Return-Path: <netdev+bounces-4111-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DCC670AE84
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 17:21:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27E74280EB2
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 15:21:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C39F46B9;
	Sun, 21 May 2023 15:21:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB432597
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 15:21:34 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8E0B5
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 08:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=5540YD9s96vWVytsu7Wc3w8wfAywcd4CZEaRDDDRZaw=; b=OdYgPyrvkvI5EOUqgbzxMPT74E
	3SjhI/aFWk2TrZ/jEaoqDzn0byoPRFGAsc+pI8Q3d2M4VCu+OeMLQgOZ7awuPosEzCwe5udo3SmJF
	KQon2HTUjGE7kxo3GVBxxxNUEcMrnd/T2iFbrnK356E4RJEScBtJDomlXv2OeU/iNEyw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q0ks7-00DSpy-8y; Sun, 21 May 2023 17:21:23 +0200
Date: Sun, 21 May 2023 17:21:23 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
	Josua Mayer <josua@solid-run.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: sfp: add support for a couple of copper
 multi-rate modules
Message-ID: <704110c2-9c46-484c-92c8-9190b740ffc3@lunn.ch>
References: <E1q0JfS-006Dqc-8t@rmk-PC.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1q0JfS-006Dqc-8t@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 20, 2023 at 11:18:30AM +0100, Russell King (Oracle) wrote:
> Add support for the Fiberstore SFP-10G-T and Walsun HXSX-ATRC-1
> modules. Internally, the PCB silkscreen has what seems to be a part
> number of WT_502. Fiberstore use v2.2 whereas Walsun use v2.6.
> 
> These modules contain a Marvell AQrate AQR113C PHY, accessible through
> I2C 0x51 using the "rollball" protocol. In both cases, the PHY is
> programmed to use 10GBASE-R with pause-mode rate adaption.
> 
> Unlike the other rollball modules, these only need a four second delay
> before we can talk to the PHY.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

