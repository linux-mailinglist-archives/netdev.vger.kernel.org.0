Return-Path: <netdev+bounces-8172-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 729A3722F62
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:12:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 169572813FC
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 19:12:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B06124129;
	Mon,  5 Jun 2023 19:12:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F820DDC0
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 19:12:01 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2C8EA
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=pJJYHVGQ3fVJUJRKnTPjNeQSbYHbdjK8jOS2CxdCyck=; b=pZ/fM6ghSVx460AAmsJQ5dQleT
	xLw6mpoYV/HQI3gIoWgWKjwj2/hTt1nbtG3A1Ip3fJ7Hf5tnsa9ZwwDaxA3zEMgdzwSMZpJk4McIp
	St3ezotyFKttIlBZH5LnGxzzc4IFsMYjaDzeSuD9tihaqr1arw/BugvH95iI7XUnucbA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q6FcB-00EvrF-Aw; Mon, 05 Jun 2023 21:11:39 +0200
Date: Mon, 5 Jun 2023 21:11:39 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Fernando Eckhardt Valle <fevalle@ipt.br>
Cc: davem@davemloft.net, jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH] igc: enable Mac Address Passthrough in Lenovo
 Thunderbolt 4 Docks
Message-ID: <09c32c5a-73b4-456f-97f9-685820f3ba25@lunn.ch>
References: <20230605185407.5072-1-fevalle@ipt.br>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605185407.5072-1-fevalle@ipt.br>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 03:54:07PM -0300, Fernando Eckhardt Valle wrote:
> In order for the Mac Address Passthrough to work with the igc
> driver and the Lenovo Thunderbolt 4 dock station, it is necessary
> to wait for a minimum time of 600ms for the Laptop's MAC address
> to be copied to the Dock. To avoid always waiting for this 600ms
> time, a parameter was created to enable the Mac Address PT and
> also another parameter to modify the waiting time if necessary
> in the future.

Module parameters are very much frowned upon. Please try to find
another solution.

What does the copy of the MAC address? Can it signal when it is done,
and when there is nothing to do?

    Andrew

