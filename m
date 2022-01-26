Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292B649CA4C
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 14:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232492AbiAZNDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 08:03:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbiAZNDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 08:03:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2DEC06161C;
        Wed, 26 Jan 2022 05:03:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B071161A5C;
        Wed, 26 Jan 2022 13:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8E8C340E3;
        Wed, 26 Jan 2022 13:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643202188;
        bh=I/sYGDx/XyXGayEEK+UDUv1Ro8EyPNYU+/FL/SgC0Sg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g6G36H1ZimcP9WAjchnqyB2PyL54aAfm39ckwcon06tV5/ptTzm/2apZmy/O6RjNf
         TFEUhRiJwoRCpD4Z+lJo5MrDdRbAk7rfrCPrA/BjsxASCDl/GvY31eU9XTdj9bFwbQ
         9XYHDFnyEOlJjgFFsf8fLqIPEluFCORQGtZthfBx1CfdeeoaPu+11NH8FctU0bcHdy
         C2inkqMMlPQLRzyuX63QBHaZAmKKr0nacprXc9NiQApbL/OGlennI0xjUhQue2PWa9
         Z/rgytKkbx7fDkTRiVB7vw+oIK7MkczCy2N4LuxIBB1xqbNuwm1TNuBBTdM7DvLN7b
         F3JRQOB1zwVdg==
Date:   Wed, 26 Jan 2022 20:55:22 +0800
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: don't stop RXC during LPI
Message-ID: <YfFEulZJKzuRQfeG@xhacker>
References: <20220123141245.1060-1-jszhang@kernel.org>
 <Ye15va7tFWMgKPEE@lunn.ch>
 <Ye19bHxcQ5Plx0v9@xhacker>
 <Ye2SznI2rNKAUDIq@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Ye2SznI2rNKAUDIq@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 23, 2022 at 06:39:26PM +0100, Andrew Lunn wrote:
> > I think this is a common issue because the MAC needs phy's RXC for RX
> > logic. But it's better to let other stmmac users verify. The issue
> > can easily be reproduced on platforms with PHY_POLL external phy.
> 
> What is the relevance of PHY polling here? Are you saying if the PHY
> is using interrupts you do not see this issue?

I tried these two days, if the PHY is using interrupts, I can't
reproduce the issue. It looks a bit more complex. Any suggestions?

Thanks in advance
