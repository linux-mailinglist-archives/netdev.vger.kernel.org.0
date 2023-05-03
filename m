Return-Path: <netdev+bounces-53-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DF7F6F4EE7
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 04:47:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33021280D9B
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 02:46:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FC3A7F4;
	Wed,  3 May 2023 02:46:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41AE7E9
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 02:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234CAC433D2;
	Wed,  3 May 2023 02:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683082015;
	bh=k4GsXcb5/LxuYCE43eHt0iFQuQ3l/Ck81cTTFkYzGcE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qrbMaogE3c/lfx9KwpxMKBl6Iysq8Cn1Gfe2eLI3xxQwEPvgPw0eTObgLCBu/oJVV
	 oNpIVAk2oWH940w+709dZIkszRyFMn+UkiaoxLY8A3j0ID7ZrxU7okwLIipk+LfZVE
	 3+9ne1doiBwzb3XW221++xy9Da7G7OV4nrQRGm7KLrUfG1ZEhGdvE377MH+nzAEGzs
	 wPw2FRB3Ad1OlH/sIz/1e2/P5FN4GX3d9vvq2MiUvlF1WJ9wtIelZPrZ4BMQgvM6Qk
	 Azxf/R0XnDrdba8mwOiT96DUKRPGSxf5spEEAKmd3xrwvmp/TXT1zt9lDMASwWvzDl
	 s8ZSJvlPmsTiA==
Date: Tue, 2 May 2023 19:46:54 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Devang Vyas <devangnayanbhai.vyas@amd.com>
Cc: Andrew Lunn <andrew@lunn.ch>, hkallweit1@gmail.com,
 linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: aquantia: Add 10mbps support
Message-ID: <20230502194654.093afb13@kernel.org>
In-Reply-To: <7ae81127-a2aa-4f02-8c07-b8f158e0ef83@lunn.ch>
References: <20230426081612.4123059-1-devangnayanbhai.vyas@amd.com>
	<7ae81127-a2aa-4f02-8c07-b8f158e0ef83@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 26 Apr 2023 14:54:01 +0200 Andrew Lunn wrote:
> On Wed, Apr 26, 2023 at 01:46:12PM +0530, Devang Vyas wrote:
> > This adds support for 10mbps speed in PHY device's
> > "supported" field which helps in autonegotiating
> > 10mbps link from PHY side where PHY supports the speed
> > but not updated in PHY kernel framework.  
> 
> Are you saying it is not listed in BMSR that the PHY supports 10 Mbps?
> Bits BMSR_10HALF and BMSR_10FULL are not set?

I didn't see any reply to Andrew's question so dropping this 
from patchwork for now. It feels like -next material too, so
please hold off any reposting until Monday.
-- 
pw-bot: defer

