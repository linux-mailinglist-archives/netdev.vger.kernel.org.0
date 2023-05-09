Return-Path: <netdev+bounces-1003-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B95376FBCCE
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 04:00:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 975E01C20A93
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 02:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6212A38D;
	Tue,  9 May 2023 02:00:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35EF7C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 02:00:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA072C433D2;
	Tue,  9 May 2023 02:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683597637;
	bh=9MHSuy4IZwbNpLTmIOSNzbAG86M7TJ8YGI6Ot3dbBD8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IGR7vZCKE5peiS9ezikYTMTLap5LlBbO5nmTWRfpNZi2mUMI8OY3+wI3nVCe6pZeS
	 VaZNU5bAUmSSMLeItyGXpBeNQj1kXEMVOOY3XGK4bG2xxRsCitZ/OuOOF0kTNDc73t
	 KtrhAdquktLgZ6lTPdy32aVz9MViMCb2q6ErXVqmVhY7W7t9OmH8+cWSMFoThaGvnN
	 4/sBMY74Ez+FxqThj0JwiOr0mYIZTlyJ14RSW9IhU4Ed80mixjoHJ39+cx/lwFBsJv
	 +wJByvFDGvDQvKqIiyXBLRefhZkA7OrTAscF/oOXLoMRhl/PPrXeTfT+PK+lyD+PZZ
	 V5fga8hc2wjzw==
Date: Mon, 8 May 2023 19:00:35 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Siddharth Vadapalli <s-vadapalli@ti.com>
Cc: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
 <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
 <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>
Subject: Re: [PATCH net] net: phy: dp83867: add w/a for packet errors seen
 with short cables
Message-ID: <20230508190035.24b5710e@kernel.org>
In-Reply-To: <20230508070019.356548-1-s-vadapalli@ti.com>
References: <20230508070019.356548-1-s-vadapalli@ti.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Thanks for the patch! Some nit picks below..

On Mon, 8 May 2023 12:30:19 +0530 Siddharth Vadapalli wrote:
> +	err = phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_DSP_FFE_CFG, 0X0E81);

Pleas wrap this line at 80 characters, there's no reason for it 
to be this long.

And 0x prefix should not be in upper case, here and in the new define
you're adding.
-- 
pw-bot: cr

