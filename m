Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6CEB49BADD
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 19:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245541AbiAYSBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 13:01:51 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33338 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348646AbiAYSAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 13:00:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D846FB819FC
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 18:00:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD27C340E0;
        Tue, 25 Jan 2022 18:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643133648;
        bh=SDwHqh3LuNSdJaTo7RrCtDgHVzq2pnbE3Q6Yp7Hdvn8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Rxxtkv/Q6p7xl3dxBJvwMdDZ0pAi303StWTFboNevsV9izleBtdvFIMT29hzXpoxY
         n7G5DU8YgNAKzdh96/sdd+aVxVGZd46ZTwAY69Ggn7S5Gdf0z1MvQfZsBZIO/PybHl
         M44NxbRlBLGKgcs1iiRSM5k6UEIIXTrT8FQA+1sP14G8nMkF0o3gPDT9fd0UyeROQY
         1p0vGFkCXuoW0gwYTVyDnCnWTihW12zX9mX+xvXeroAt6F/OO8AXEvVZI70Egi3I5r
         gNsm6J5EcUphFWjYQ6rgohyXgQR1zf4+Knq0cMG2OL1y0+yWibfyW8E41qv86k+uqr
         OL9z/SFobkw+g==
Date:   Tue, 25 Jan 2022 10:00:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH net-next] r8169: use new PM macros
Message-ID: <20220125100047.326634f5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <6c61ea93-2513-74e9-9e91-1c2c27c8746c@gmail.com>
References: <6c61ea93-2513-74e9-9e91-1c2c27c8746c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jan 2022 22:17:17 +0100 Heiner Kallweit wrote:
> This is based on series [0] that extended the PM core. Now the compiler
> can see the PM callbacks also on systems not defining CONFIG_PM.
> The optimizer will remove the functions then in this case.
> 
> [0] https://lore.kernel.org/netdev/20211207002102.26414-1-paul@crapouillou.net/
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks, 8fe6e670640e ("r8169: use new PM macros") in net-next.
