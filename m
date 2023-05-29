Return-Path: <netdev+bounces-6099-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4661714D0A
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 17:31:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F32E01C209C7
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 15:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FC2C8F47;
	Mon, 29 May 2023 15:31:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651398C11
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 15:31:42 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4199C;
	Mon, 29 May 2023 08:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=bA2tpPYatFg58tl/7MGTXP6PhZ1WH2HGNdCrTzfkpX0=; b=swMMbp1PG3lSUb2lLvJru9B2gg
	Jq7YnDtcGZ2BaoXIZ0TGNjTTTz4Ti/y/6/pZSThiZ1OkKl7RD7HsNgsI2e/xBXA/R/v9xJiIP/BlZ
	HCq9TOqKB6wXblxSrfoZC4ZTHyULbRzMX+7aSsDS7/aKPvv/JoPlP1SScOwG07prwKmc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q3eqK-00EEwU-U5; Mon, 29 May 2023 17:31:32 +0200
Date: Mon, 29 May 2023 17:31:32 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-leds@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH v3 01/13] leds: add APIs for LEDs hw control
Message-ID: <ceaaf92b-a8f7-4760-a2ff-6fc5775cec07@lunn.ch>
References: <20230527112854.2366-1-ansuelsmth@gmail.com>
 <20230527112854.2366-2-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230527112854.2366-2-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 27, 2023 at 01:28:42PM +0200, Christian Marangi wrote:
> Add an option to permit LED driver to declare support for a specific
> trigger to use hw control and setup the LED to blink based on specific
> provided modes.
> 
> Add APIs for LEDs hw control. These functions will be used to activate
> hardware control where a LED will use the provided flags, from an
> unique defined supported trigger, to setup the LED to be driven by
> hardware.
> 
> Add hw_control_is_supported() to ask the LED driver if the requested
> mode by the trigger are supported and the LED can be setup to follow
> the requested modes.
> 
> Deactivate hardware blink control by setting brightness to LED_OFF via
> the brightness_set() callback.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

