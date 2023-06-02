Return-Path: <netdev+bounces-7302-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70A7F71F95B
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 06:33:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 215002819FC
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 04:33:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 531198467;
	Fri,  2 Jun 2023 04:33:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DBF8466
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 04:33:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C72C433D2;
	Fri,  2 Jun 2023 04:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685680427;
	bh=rzdbk4UoCHxqOyDCfEQSEqkhPVCF5ZhNTciUeKk4crw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=uNCNrf6TFuwuOIPyo0xPa137bdxnHl291nika4Kl3JAWUEiWFtVnDVRPvYINhy9Z2
	 ctapbpAra5CSwKsYwgfjqd7conOZJvj2mMsjP3wj2caADHk5H2iltpmaQ4i/TQ78ay
	 REBCAuQ/Log6kAsvpO1yMfeLjdAnzGWvqDfBFqqXZfbmoz/yWnGLAJvtSpL6/36PfO
	 lDvqy5i1wykQXIVGzQLwBpXzW63EnVcJhY0fu9VuMzqJdBkiaB3mAew1HWOvO9CeSE
	 D57OAMItT3jIswotPMPLQWgQn30IQiAjRjkbs2ogMADfeieelKIODmwzu2XwhZ2GEL
	 omIc8gHQgNLRg==
Date: Thu, 1 Jun 2023 21:33:45 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Dan Carpenter
 <dan.carpenter@linaro.org>, Oleksij Rempel <linux@rempel-privat.de>,
 netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phylib: fix phy_read*_poll_timeout()
Message-ID: <20230601213345.3aaee66a@kernel.org>
In-Reply-To: <E1q4kX6-00BNuM-Mx@rmk-PC.armlinux.org.uk>
References: <E1q4kX6-00BNuM-Mx@rmk-PC.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 01 Jun 2023 16:48:12 +0100 Russell King (Oracle) wrote:
> +	__ret = read_poll_timeout(__val = phy_read, val, \
                                                    ^^^
Is this not __val on purpose?

