Return-Path: <netdev+bounces-1825-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EAA7D6FF392
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:06:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6BE81C20F5B
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:06:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDE6A19E7A;
	Thu, 11 May 2023 14:06:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA2F1F920
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 14:06:04 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082E010FF;
	Thu, 11 May 2023 07:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=MtnwjUGQMTg1yfTTLU9Z+2ghB5SIPLEsC/rY/cUh02I=; b=hly3rb5w639+90+1SucuCz1Ifm
	3WCHiSXMIRtwdCiXL5a5D0qYmHL5SsocwYX5WuffMZ0XFnbpLrH4IMYW+iVaZ21wW+UjgX2aebOax
	9YXZSz4Und/V0E+W8F80Y396RNt0EGZ0K27Caxf3HHdohA+CZWPru/AWHQzJxDFb0VzY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1px6vN-00CYvh-P7; Thu, 11 May 2023 16:05:41 +0200
Date: Thu, 11 May 2023 16:05:41 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Harini Katakam <harini.katakam@amd.com>
Cc: hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
	kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
	vladimir.oltean@nxp.com, wsa+renesas@sang-engineering.com,
	simon.horman@corigine.com, mkl@pengutronix.de,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	harinikatakamlinux@gmail.com, michal.simek@amd.com,
	radhey.shyam.pandey@amd.com
Subject: Re: [PATCH net-next v3 1/3] phy: mscc: Use PHY_ID_MATCH_VENDOR to
 minimize PHY ID table
Message-ID: <428db3e5-fb22-45a3-8d75-85cfbf67fe56@lunn.ch>
References: <20230511120808.28646-1-harini.katakam@amd.com>
 <20230511120808.28646-2-harini.katakam@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511120808.28646-2-harini.katakam@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 05:38:06PM +0530, Harini Katakam wrote:
> All the PHY devices variants specified have the same mask and
> hence can be simplified to one vendor look up for 0x00070400.
> Any individual config can be identified by PHY_ID_MATCH_EXACT
> in the respective structure.
> 
> Signed-off-by: Harini Katakam <harini.katakam@amd.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

