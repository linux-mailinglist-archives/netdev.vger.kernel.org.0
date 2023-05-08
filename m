Return-Path: <netdev+bounces-868-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 381606FB0F3
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 15:11:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A7A81C209A7
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 13:11:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10C2D1362;
	Mon,  8 May 2023 13:11:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CC51361
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 13:11:32 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CFA2FA34;
	Mon,  8 May 2023 06:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=c4ZTi/fdPvEGyjWULqRCx9hYDcJ4HpkQpuJc9kjoNqA=; b=KaEvqxZnRUuaaSPLPtkGRw2LCe
	Q314eTim86fE4mSgl0M0yrjA3SkuPEtgnk0UEoM7/+yAKZYXUVSO9KCWyESH2FAQlQ3lqU+ytJxuX
	0RKPB5CLBdGzLWSYGa5NhcPcjqb+1ldqjWWQ0kHtXy98C9UWcGEZyDPeVAcKe5aKDPHo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pw0dv-00CCOL-MU; Mon, 08 May 2023 15:11:07 +0200
Date: Mon, 8 May 2023 15:11:07 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Christian Marangi <ansuelsmth@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
	Lee Jones <lee@kernel.org>, Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-leds@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 00/11] leds: introduce new LED hw control APIs
Message-ID: <e206d683-6a89-4168-b8ed-ac5b1c76f94c@lunn.ch>
References: <20230427001541.18704-1-ansuelsmth@gmail.com>
 <ZFjqKoZtgOAWrkP+@pengutronix.de>
 <6458ec16.050a0220.21ddf.3955@mx.google.com>
 <20230508125253.GW29365@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508125253.GW29365@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> I'll wait for v2 then. My ultimate goal is to implement LED trigger support
> for the DP83867 phy. It would be great if you could Cc me on v2 so I get
> a trigger once it's out.

Hi Sascha

Full hardware offload is going to take a few patch sets. The v2 to be
posted soon gives basic support. It is will be missing linking the PHY
LED to the netdev. We have patches for that. And then there is a DT
binding, which again we have patches for. It could also be my Marvell
PHY patches are a separate series. You might want those to get an
example for your DP83867 work.

I'm hoping we can move faster than last cycles, there is less LED and
more networking, so we might be closer to 3 day review cycles than 2
weeks.

	Andrew

