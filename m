Return-Path: <netdev+bounces-4112-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45AFA70AE88
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 17:24:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F7E3280C98
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 15:24:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FFEE4A20;
	Sun, 21 May 2023 15:24:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F533D6B
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 15:24:04 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6843CBB
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 08:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=IPDpHxn0QkUs8ryaIxSPsVSl7iod8FVc+k/R2OiOBTk=; b=mkevAJVGYnKxZRYq01H3fJDTvc
	goF6FRL/lRam/nFfDAk+e0b7bYZyDl8i3G4iUHLt+U/Gljn4nEx/NIeI9h07ETpnpzKElY6zur4RC
	B5wBdVkJibUI2iQqddOw1OWPFDCCX05RwKrQPMfozUaiXweeJqm7bHpDl3Yp3yX/1NF4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q0kua-00DSr4-Bj; Sun, 21 May 2023 17:23:56 +0200
Date: Sun, 21 May 2023 17:23:56 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phylink: require supported_interfaces to
 be filled
Message-ID: <b88c83c0-afdb-4ab8-abb2-9ba5936e9fe6@lunn.ch>
References: <E1q0K1u-006EIP-ET@rmk-PC.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1q0K1u-006EIP-ET@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 20, 2023 at 11:41:42AM +0100, Russell King (Oracle) wrote:
> We have been requiring the supported_interfaces bitmap to be filled in
> by MAC drivers that have a mac_select_pcs() method. Now that all MAC
> drivers fill in the supported_interfaces bitmap, it is time to enforce
> this. We have already required supported_interfaces to be set in order
> for optical SFPs to be configured in commit f81fa96d8a6c ("net: phylink:
> use phy_interface_t bitmaps for optical modules").
> 
> Refuse phylink creation if supported_interfaces is empty, and remove
> code to deal with cases where this mask is empty.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

> I believe what I've said above is indeed the case, but there is always
> the chance that something has been missed and this will cause breakage.
> I would post as RFC and ask for testing, but in my experience that is
> a complete waste of time as it doesn't result in any testing feedback.
> So, it's probably better to get it merged into net-next and then wait
> for any reports of breakage.

Agreed.

    Andrew

