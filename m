Return-Path: <netdev+bounces-11288-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC5097326B5
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 07:41:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A56DF1C20E3A
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 05:41:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B32F8EBD;
	Fri, 16 Jun 2023 05:41:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606237C
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 05:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733A3C433C8;
	Fri, 16 Jun 2023 05:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686894065;
	bh=eYR/ym1NZSFPGTIefjm02LzIa+aRYuH8daOwAd9pBJI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kQSUDUNsBQWXcpjGVDNgq7Y9x3FnYcyznzjUPNVExCXJ9ivLd5b2+IJEcXwS4uDEO
	 Yoqx2WCPA+GB3YqPghPOmBy9uG6QjQXV4lYeQzPG8NbfIzY0qv6yFiLWsjzeZEmy13
	 +t6b7Gpokz1RQAofBgFYu1qg2rLMcrh5GuVfmx8kCm1MF1YHkdsM4/2mVM7xRFAcE6
	 KBDvLKs4MSRs/HaLcjOobxBAEkIW7xgsEQGYfl5Pwerm6Ad7d75iiO+4FrUpyV8ett
	 HJM8nbzM45y6VnRQOHIZt49b4aoLcvV7AB6RnwEaGO1ZYBeF6SHpI5Xx6+nOyu6fcj
	 erzEbm+x2sXyA==
Date: Thu, 15 Jun 2023 22:41:04 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jianhui Zhao <zhaojh329@gmail.com>, andrew@lunn.ch,
 linux@armlinux.org.uk
Cc: hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] net: phy: Add sysfs attribute for PHY c45
 identifiers.
Message-ID: <20230615224104.2b9f3adf@kernel.org>
In-Reply-To: <20230614134522.11169-1-zhaojh329@gmail.com>
References: <20230614134522.11169-1-zhaojh329@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jun 2023 21:45:22 +0800 Jianhui Zhao wrote:
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Russell King <linux@armlinux.org.uk>

Did Andrew and Russell give review tags on the list ?
I don't see any given to v2.

