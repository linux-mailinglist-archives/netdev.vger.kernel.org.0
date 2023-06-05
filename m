Return-Path: <netdev+bounces-8223-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 702D7723278
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 23:45:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA8161C20D43
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:45:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DED327702;
	Mon,  5 Jun 2023 21:45:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80FC271E6
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 21:45:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E862CC433D2;
	Mon,  5 Jun 2023 21:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686001503;
	bh=KFXw32cPDNNnIK/7hhnlFMPPfkd6tPmyWt92f/5b6nw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=a5WzR13FOYJnMfM3sD0pbqRI4pyhT3HY8Il/3DpCZQlVNBA+S+UIlkugSqBwpXlFl
	 tIW9LNavviuhHUvvNB0zFgH5834y5p5x6xtxKIJ3qQ2Em7ylN+D+3at0+fzWXZl/6X
	 hg58A+Wp5Uw7HX+YwKtvuOsvyN5OJeiyjT013b8H15PkGJe4YUSJw8P8xv6vczRIZD
	 CPCZq2OVP02sm/w1dKH4KvnlYEdgtj7HdsUFOHC1rXdf5IK+auj8EuoN1hFWF6A7ZX
	 8owkXy4AkQ4xgwg/QKFEZ0eqTSk/4R4fdD0iwiL1p/aSP0hKSnf/iuTdWThMmA14jd
	 IVQKxx5AdJA0w==
Date: Mon, 5 Jun 2023 14:45:01 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Detlev Casanova <detlev.casanova@collabora.com>
Cc: linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>, Heiner
 Kallweit <hkallweit1@gmail.com>, Russell King <linux@armlinux.org.uk>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Rob Herring
 <robh+dt@kernel.org>, Krzysztof Kozlowski
 <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>,
 Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
 devicetree@vger.kernel.org
Subject: Re: net: phy: realtek: Support external PHY clock
Message-ID: <20230605144501.31f49920@kernel.org>
In-Reply-To: <20230605151953.48539-1-detlev.casanova@collabora.com>
References: <20230605151953.48539-1-detlev.casanova@collabora.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  5 Jun 2023 11:19:50 -0400 Detlev Casanova wrote:
> Some PHYs can use an external clock that must be enabled before
> communicating with them.

Please add a [PATCH v4 0/0] prefix to the subject of the cover letter
(or use --cover-letter with git format-patch to generate the template).
Otherwise patchwork doesn't realize this is a cover letter.

