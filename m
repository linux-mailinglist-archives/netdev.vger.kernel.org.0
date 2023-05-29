Return-Path: <netdev+bounces-6100-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2C75714D0C
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 17:32:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 797A71C209EA
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 15:32:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F03FC8F4B;
	Mon, 29 May 2023 15:32:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16008C1F
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 15:32:30 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38569C;
	Mon, 29 May 2023 08:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=m08sdZiiSWYdCbM5OkMaV4gXe9Pwbr7hRmDqovZeq34=; b=AAQ3c9f+7ncbOmYiPq/Sc2pNDq
	4ObJATKcP3kAMmJF7ns5gALpCxPCGdccpgQ0DhhUKJEpTc4nqNxvFqcJLVdp2fVwIQnEOWBI39Lgc
	se/d8u+TtiVPHpD+zHIJLu7gOatGth1D00qj7yIghcb47TROcS9u1VpiFDNQb8H4YZTw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q3er7-00EExO-HE; Mon, 29 May 2023 17:32:21 +0200
Date: Mon, 29 May 2023 17:32:21 +0200
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
Subject: Re: [net-next PATCH v3 05/13] leds: trigger: netdev: introduce check
 for possible hw control
Message-ID: <6ce434f5-dfa7-4ef5-800f-7bb328ec5070@lunn.ch>
References: <20230527112854.2366-1-ansuelsmth@gmail.com>
 <20230527112854.2366-6-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230527112854.2366-6-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 27, 2023 at 01:28:46PM +0200, Christian Marangi wrote:
> Introduce function to check if the requested mode can use hw control in
> preparation for hw control support. Currently everything is handled in
> software so can_hw_control will always return false.
> 
> Add knob with the new value hw_control in trigger_data struct to
> set hw control possible. Useful for future implementation to implement
> in set_baseline_state() the required function to set the requested mode
> using LEDs hw control ops and in other function to reject set if hw
> control is currently active.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

