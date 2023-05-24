Return-Path: <netdev+bounces-4843-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D7B270EBE6
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 05:32:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3033A1C20AC6
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 03:32:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F8A215B0;
	Wed, 24 May 2023 03:32:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E12EC2
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 03:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F3CC433D2;
	Wed, 24 May 2023 03:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684899163;
	bh=YgsyuTaG2HS/cCFKOvPCnWA0FKkNUnDfel1neHERp7c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qCYYR2vd3Pd2a2mSnVE5PsD2IgslHVX/rTMAF6v4LhxRFYwvBDDxxEGlSz0RKd2MU
	 i5FMuAZRrP0bPv6+QoWYcY2mevBDqXRjA9zBdIlC+rguXVOs1UdeLHVdSoRgHjetdc
	 grjR4K6y3g00EKIDfpSPeaZxUS8sTMVOe55A45Qiu7M8EZBiPXg0lhQ/CZQc5vXHnH
	 gh20f5Ht+IAbVbvLRMh+JYjp2zJC/tI8DzVVh1ZGDt8ie8mbd93FnXWPCvu/l8ukbA
	 yiliSSGKFN+XQHjSFMeclRpShEF42panbznBXnHDuYV2jayVBCWPM2EGm1AU/JivKe
	 fZss3EB0z89Tw==
Date: Tue, 23 May 2023 20:32:40 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: <andrew@lunn.ch>, <vladimir.oltean@nxp.com>
Cc: Harini Katakam <harini.katakam@amd.com>, <hkallweit1@gmail.com>,
 <linux@armlinux.org.uk>, <davem@davemloft.net>, <edumazet@google.com>,
 <pabeni@redhat.com>, <wsa+renesas@sang-engineering.com>,
 <simon.horman@corigine.com>, <netdev@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <harinikatakamlinux@gmail.com>,
 <michal.simek@amd.com>, <radhey.shyam.pandey@amd.com>
Subject: Re: [PATCH net-next v4 2/2] phy: mscc: Add support for RGMII delay
 configuration
Message-ID: <20230523203240.32519af8@kernel.org>
In-Reply-To: <20230522122829.24945-3-harini.katakam@amd.com>
References: <20230522122829.24945-1-harini.katakam@amd.com>
	<20230522122829.24945-3-harini.katakam@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 May 2023 17:58:29 +0530 Harini Katakam wrote:
> Add support for optional rx/tx-internal-delay-ps from devicetree.
> - When rx/tx-internal-delay-ps is/are specified, these take priority
> - When either is absent,
> 1) use 2ns for respective settings if rgmii-id/rxid/txid is/are present
> 2) use 0.2ns for respective settings if mode is rgmii
> 
> Signed-off-by: Harini Katakam <harini.katakam@amd.com>

PHY folks, looks good?

