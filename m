Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9702A0C17
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 18:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgJ3RHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 13:07:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726259AbgJ3RHJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 13:07:09 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9088320756;
        Fri, 30 Oct 2020 16:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604077122;
        bh=NQHYM8GVLTc+Q27yNaiylvcsHI8eawqNkhk71989hxU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xTLlkjIx4w09PWulJixzUroOxf9p9t7uJZJoFEYSFSwnio/kgEvB1ISxtBfQ1XhQO
         CRonLlZtssrPFgKEqQDY0FuLA2qFvQfABK9owZaFrp0BCvur10RUbShdg33TeWq6Jt
         2NvO1IKjbZJwiA1TSwxzMSnux5FGzrLMgp9HcKps=
Date:   Fri, 30 Oct 2020 09:58:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH] net: stmmac: Fix channel lock initialization
Message-ID: <20201030095840.5e999a1b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201029185011.4749-1-m.szyprowski@samsung.com>
References: <CGME20201029185023eucas1p21872d74eeb62643a3ff364af7cf2c6eb@eucas1p2.samsung.com>
        <20201029185011.4749-1-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 19:50:11 +0100 Marek Szyprowski wrote:
> Commit 0366f7e06a6b ("net: stmmac: add ethtool support for get/set
> channels") refactored channel initialization, but during that operation,
> the spinlock initialization got lost. Fix this. This fixes the following
> lockdep warning:
 
> Fixes: 0366f7e06a6b ("net: stmmac: add ethtool support for get/set channels")
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Applied to net, thanks!
