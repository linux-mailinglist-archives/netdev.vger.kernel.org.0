Return-Path: <netdev+bounces-5800-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 31740712C62
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 20:23:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DBB591C210F2
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 18:23:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6584C29103;
	Fri, 26 May 2023 18:23:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B45815BD
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 18:23:03 +0000 (UTC)
Received: from fgw21-7.mail.saunalahti.fi (fgw21-7.mail.saunalahti.fi [62.142.5.82])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64AFD3
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 11:23:01 -0700 (PDT)
Received: from localhost (88-113-26-95.elisa-laajakaista.fi [88.113.26.95])
	by fgw21.mail.saunalahti.fi (Halon) with ESMTP
	id 577a6faa-fbf2-11ed-abf4-005056bdd08f;
	Fri, 26 May 2023 21:22:59 +0300 (EEST)
From: andy.shevchenko@gmail.com
Date: Fri, 26 May 2023 21:22:58 +0300
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
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
Message-ID: <ZHD5Am8TUyzYI87H@surfacebook>
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
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
	SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fri, May 26, 2023 at 11:14:39AM +0100, Russell King (Oracle) kirjoitti:
> Add lynx_pcs_create_mdiodev() to simplify the creation of the mdio
> device associated with lynx PCS. In order to allow lynx_pcs_destroy()
> to clean this up, we need to arrange for lynx_pcs_create() to take a
> refcount on the mdiodev, and lynx_pcs_destroy() to put it.
> 
> Adding the refcounting to lynx_pcs_create()..lynx_pcs_destroy() will
> be transparent to existing users of these interfaces.

...

> +	mdio_device_get(mdio);
>  	lynx->mdio = mdio;

Just for the sake of example of how it can be used (taking into account my
previous comment):

  	lynx->mdio = mdio_device_get(mdio);

-- 
With Best Regards,
Andy Shevchenko



