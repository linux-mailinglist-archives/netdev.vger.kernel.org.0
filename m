Return-Path: <netdev+bounces-5571-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 995DB7122C6
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:56:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C00C1C20FD1
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 08:56:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D579101F3;
	Fri, 26 May 2023 08:56:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926CA523D
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 08:56:09 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7E4119
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 01:56:07 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1q2TEz-0001sL-EN; Fri, 26 May 2023 10:56:05 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1q2TEy-0005Q7-SM; Fri, 26 May 2023 10:56:04 +0200
Date: Fri, 26 May 2023 10:56:04 +0200
From: Oleksij Rempel <o.rempel@pengutronix.de>
To: Andrew Lunn <andrew@lunn.ch>
Cc: netdev <netdev@vger.kernel.org>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [RFC/RFTv3 00/24] net: ethernet: Rework EEE
Message-ID: <20230526085604.GA21891@pengutronix.de>
References: <20230331005518.2134652-1-andrew@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230331005518.2134652-1-andrew@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Andrew,

On Fri, Mar 31, 2023 at 02:54:54AM +0200, Andrew Lunn wrote:
> Most MAC drivers get EEE wrong. The API to the PHY is not very
> obvious, which is probably why. Rework the API, pushing most of the
> EEE handling into phylib core, leaving the MAC drivers to just
> enable/disable support for EEE in there change_link call back, or
> phylink mac_link_up callback.
> 
> MAC drivers are now expect to indicate to phylib/phylink if they
> support EEE. If not, no EEE link modes are advertised. If the MAC does
> support EEE, on phy_start()/phylink_start() EEE advertisement is
> configured.
> 
> v3
> --
 
I was able to test some drivers and things seems to work ok so far. Do you
need more tests for a non RFC version?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

