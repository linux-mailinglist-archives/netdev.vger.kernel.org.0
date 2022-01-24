Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535E0498886
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244566AbiAXSnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:43:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45316 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiAXSny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:43:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CE99614D0;
        Mon, 24 Jan 2022 18:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03F6C340E5;
        Mon, 24 Jan 2022 18:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643049833;
        bh=fjJSY7FugE5Gp1KTxk0Zobf8q54Y/LM7PG/4KE3Tjb4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UCfBDborgjCRg9qTZ252s9MeFIaljnltkwv73lPNL5IDOBRJRNujJaZuSgRc4mbMG
         Xa0zNzG/X9lqY5RF4Nk273KuNDvTD7cUsbW7F6EcmHi+g5e6xvcoezUCb9bNmDmAL9
         X4VK6HcYU6JgH3x6u+nF5Snh4+868bjkaKeI3V39m/ByQAZ5DGfPxxkm0/lCgr0Oq7
         cc3Ln3jEKVpF6mCHFSeixXap8HeV+LVZjnt0APiJ2BWiDisFipoRtdp1h9GqTn0LGb
         Ot91vltjJd38nPLkBsIyKcwnmGgmBTKAZncplUAc352I6aCDDMDajSE7BDOpWlF8G7
         rOiwv+e5EilZg==
Date:   Mon, 24 Jan 2022 10:43:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: dwmac-sun8i: fix double disable and
 unprepare "stmmaceth" clk
Message-ID: <20220124104351.2d5cab46@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220123132805.758-1-jszhang@kernel.org>
References: <20220123132805.758-1-jszhang@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 23 Jan 2022 21:28:05 +0800 Jisheng Zhang wrote:
> Fix warnings on Allwinner D1 platform:
> 
> [    1.604695] ------------[ cut here ]------------
> [    1.609328] bus-emac already disabled

Reading Samuel's feedback it sounds like the change will have to be
reposted with a different commit message (either explaining why the
fixes indeed works or as a clean up not a fix). 
Marking Changes Requested in patchwork.
