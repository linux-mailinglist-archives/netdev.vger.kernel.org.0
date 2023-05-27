Return-Path: <netdev+bounces-5903-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 03F927134F5
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 15:24:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36E7D281674
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 13:24:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA29311CAD;
	Sat, 27 May 2023 13:24:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01307F9E2
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 13:24:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DA1C433D2;
	Sat, 27 May 2023 13:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685193877;
	bh=Tix1mEImZIxw546tGQTWI98NNlHLRecUbbAC3g6gPqE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IjCetacPZdPr4psaecD+POBLloaOIz+6u2FvwK8fiRNkKl4WulJuMf/cDGbAr6Lcg
	 zcdFIEkAXLhAFssRooOi7tLxrnf0n5udNW3/krVBrfQqZdPoEWeJbqbdEHX0UDfmG7
	 X9IFSRKISJZhM5AgO1ucGVX5F32pS4BLxl0PzytynrwWam+P67cIBR+qWaTVA8qhqJ
	 JXtOwVhwQHaN7tqw/+r49r3hroCxaQb6caAch4Y8QzcjO7d/ClL9rH3QYap34BdUfW
	 5Ot79B6011kXQaACtvvQMFitS3J0buXI0hpo3bRzUdaax8ktH1U5iEJUyJ+wp30c3k
	 jKfg5Q4oE+TJw==
Date: Sat, 27 May 2023 21:24:27 +0800
From: Shawn Guo <shawnguo@kernel.org>
To: Andrew Lunn <andrew@lunn.ch>
Cc: s.hauer@pengutronix.de, Russell King <rmk+kernel@armlinux.org.uk>,
	Vladimir Oltean <vladimir.oltean@nxp.com>, arm@kernel.org,
	netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: dts: vf610: ZII: Add missing phy-mode and fixed
 links
Message-ID: <20230527132427.GE560301@dragon>
References: <20230525182606.3317923-1-andrew@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230525182606.3317923-1-andrew@lunn.ch>

On Thu, May 25, 2023 at 08:26:06PM +0200, Andrew Lunn wrote:
> The DSA framework has got more picky about always having a phy-mode
> for the CPU port. The Vybrid FEC is a Fast Ethrnet using RMII.
> 
> Additionally, the cpu label has never actually been used in the
> binding, so remove it.
> 
> Lastly, for DSA links between switches, add a fixed-link node
> indicating the expected speed/duplex of the link.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!

