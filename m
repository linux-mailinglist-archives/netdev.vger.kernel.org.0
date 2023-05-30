Return-Path: <netdev+bounces-6236-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AF5A67154D0
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:17:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D9B228106D
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 05:17:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8BE34A16;
	Tue, 30 May 2023 05:17:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597803D74
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 05:17:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703FFC433D2;
	Tue, 30 May 2023 05:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685423844;
	bh=k884gDEJ5Px9eCtShgMPs/yMOdJUjvXbTW8ERplzsfg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aki9TRTKAPGTRUcXDrGPWTWNhhpS5uaSPsrlNxHzUCuhdye9mifJEYG539XDCG/6m
	 8YVuVjYPPt3nlBoQBAVFD/gcDa/pjb6yvY5iLIxWF57y6pCv0vRbHj7HnDsu5VpoId
	 85xRV5hBTVh2VTgGPX7CSETSuQno5PWyNE6Px8ROc/yG9mCi/o4AH5L/ei/bpM6MPN
	 GRy5bUEaR1/vfVouxPLQiMNt+Res1cV0QE3tWiPdcf4tcfW5NpGfySp0QtsFBIhAkL
	 MMcVBFG1OmRYzB+lg+E08Qb1j9pcCY1d4KjsLisUfjhp4iLesQVHD91cEZgUMpqASx
	 7KqcscRQuqwTw==
Date: Mon, 29 May 2023 22:17:22 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>, Jonathan Corbet
 <corbet@lwn.net>, Andrew Lunn <andrew@lunn.ch>, Florian Fainelli
 <f.fainelli@gmail.com>, Vladimir Oltean <olteanv@gmail.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, linux-leds@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Subject: Re: [net-next PATCH v4 00/13] leds: introduce new LED hw control
 APIs
Message-ID: <20230529221722.549dfbd8@kernel.org>
In-Reply-To: <20230529163243.9555-1-ansuelsmth@gmail.com>
References: <20230529163243.9555-1-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 29 May 2023 18:32:30 +0200 Christian Marangi wrote:
> Since this series is cross subsystem between LED and netdev,
> a stable branch was created to facilitate merging process.
> 
> This is based on top of branch ib-leds-netdev-v6.5 present here [1]
> and rebased on top of net-next since the LED stable branch got merged.
> 
> This is a continue of [2]. It was decided to take a more gradual
> approach to implement LEDs support for switch and phy starting with
> basic support and then implementing the hw control part when we have all
> the prereq done.
> 
> This is the main part of the series, the one that actually implement the
> hw control API.

Just to be 100% sure - these go into netdev/net-next directly, right?
No stable branch needed?

