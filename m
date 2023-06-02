Return-Path: <netdev+bounces-7279-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0450271F82E
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 03:48:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE014281998
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 01:48:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E656D10FA;
	Fri,  2 Jun 2023 01:48:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91B810E3
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 01:48:45 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A323297;
	Thu,  1 Jun 2023 18:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=2FfI2CGt5OAyLnPlwE0+qVBCnJpNryj1RGeDDNRa1ps=; b=wfk+KV8WqWyawOQOczdqtPXpzN
	0fc/6LgQIhnF59Y/63v2SxhWWIn2Q9I8/7ENu42jKIr3keJdfGAXHPrHLcU3gHphF9dbJr/MLLOGb
	mXq8xCMyOIEzjQFPZ7n/hcMvFh+L2F3zWvj2U/XmjEWAxUspwbusJCgGn4nF+cYEThk4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q4tto-00EdAD-49; Fri, 02 Jun 2023 03:48:16 +0200
Date: Fri, 2 Jun 2023 03:48:16 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: msmulski2@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, simon.horman@corigine.com,
	kabel@kernel.org, Michal Smulski <michal.smulski@ooma.com>
Subject: Re: [PATCH net-next v5 1/1] net: dsa: mv88e6xxx: implement USXGMII
 mode for mv88e6393x
Message-ID: <324df285-d042-4cc7-9304-d8ccffc624e2@lunn.ch>
References: <20230601215251.3529-1-msmulski2@gmail.com>
 <20230601215251.3529-2-msmulski2@gmail.com>
 <ZHke6JqvcWZsOdX5@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHke6JqvcWZsOdX5@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> It would be nice to wait until we've converted 88e6xxx to phylink PCS
> before adding this support, which is something that's been blocked for
> a few years but should be unblocked either at the end of this cycle,
> or certainly by 6.5-rc1. Andrew, would you agree?

I don't think merging this will make it any harder to convert the code
to a PCS driver.

As far as i know, all the DT changes should already be in linux-next,
so i think 6.5-rc1 is a reasonable target.

   Andrew

