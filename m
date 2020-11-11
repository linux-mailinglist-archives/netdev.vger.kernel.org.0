Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 190FF2AF623
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 17:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgKKQWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 11:22:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:51392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725922AbgKKQWE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 11:22:04 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F0CC20659;
        Wed, 11 Nov 2020 16:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605111724;
        bh=HAxtj1PVhA7gGIoHhM6mBjlHxkmTmNoqSrX04hzHLZc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GlIVwKUF4JBzPYHYMcpOYjNjEIllEd4V5s5D+OQC1EuklVOS3mTlAvZ+lxQI2VBve
         q01ITsB3lNED7KjdRzUqK1ccj9iBMUjV5ly5wQ4DZeQ35dsuojupyzdnsR4rZjCQf5
         F0c7VoqbmqFWIyGPM67/MrN+s6T2+ijc15cdrTvs=
Date:   Wed, 11 Nov 2020 08:22:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: stmmac: platform: use optional clk/reset
 get APIs
Message-ID: <20201111082202.577ea1e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201111101033.753555cc@xhacker.debian>
References: <20201109160855.24e911b6@xhacker.debian>
        <20201109115713.026aeb68@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20201111101033.753555cc@xhacker.debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Nov 2020 10:10:33 +0800 Jisheng Zhang wrote:
> On Mon, 9 Nov 2020 11:57:13 -0800 Jakub Kicinski wrote:
> > On Mon, 9 Nov 2020 16:09:10 +0800 Jisheng Zhang wrote:  
> > > @@ -596,14 +595,10 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
> > >               dev_dbg(&pdev->dev, "PTP rate %d\n", plat->clk_ptp_rate);
> > >       }
> > >
> > > -     plat->stmmac_rst = devm_reset_control_get(&pdev->dev,
> > > -                                               STMMAC_RESOURCE_NAME);
> > > +     plat->stmmac_rst = devm_reset_control_get_optional(&pdev->dev, STMMAC_RESOURCE_NAME);    
> > 
> > This code was wrapped at 80 chars, please keep it wrapped.
> >   
> 
> I tried to keep wrapped, since s/devm_reset_control_get/devm_reset_control_get_optional,
> to match alignment at open parenthesis on the second line, the
> "STMMAC_RESOURCE_NAME" will exceed 80 chars. How to handle this situation?

Indeed, it's 81 chars. Still one character over 80 is easier to read
than when STMMAC_RESOURCE_NAME is wrapped half way through the name.
