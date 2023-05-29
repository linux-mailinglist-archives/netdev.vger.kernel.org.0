Return-Path: <netdev+bounces-6096-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FB19714CFD
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 17:28:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16456280DE1
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 15:28:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 752968C1F;
	Mon, 29 May 2023 15:28:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF803FD4
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 15:28:41 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F3FC9
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 08:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=XHJisE1g0D9vZUCnXFJqsOy7gtmJsuqlOH/iNJtjoBM=; b=Cf2L4F047R8sF8mNY6qh2nNvND
	UA8w/4dhoFnrzI4o7VFPdod5U1hndbOZvdGi+07nbqRf2B90YQg7Y/BC033ghNy/OPPBQRqRdaKLY
	UIjriruH3rowMhW/DU0ZEHrjete9GfoNiKJJIYY0wm3cq849jzKXwmUmCEufj0nMnp0g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q3enL-00EEu2-Qc; Mon, 29 May 2023 17:28:27 +0200
Date: Mon, 29 May 2023 17:28:27 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Simon Horman <simon.horman@corigine.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/6] net: pcs: lynx: add
 lynx_pcs_create_mdiodev()
Message-ID: <00b6e91b-c9e3-492c-ad47-4a67f9ca99a5@lunn.ch>
References: <ZHCGZ8IgAAwr8bla@shell.armlinux.org.uk>
 <E1q2UT1-008PAg-RS@rmk-PC.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1q2UT1-008PAg-RS@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 11:14:39AM +0100, Russell King (Oracle) wrote:
> Add lynx_pcs_create_mdiodev() to simplify the creation of the mdio
> device associated with lynx PCS. In order to allow lynx_pcs_destroy()
> to clean this up, we need to arrange for lynx_pcs_create() to take a
> refcount on the mdiodev, and lynx_pcs_destroy() to put it.
> 
> Adding the refcounting to lynx_pcs_create()..lynx_pcs_destroy() will
> be transparent to existing users of these interfaces.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

