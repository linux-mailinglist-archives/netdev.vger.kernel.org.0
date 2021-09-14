Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1564440AE27
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbhINMuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 08:50:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40384 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232664AbhINMuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 08:50:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3R0iENPhbr0aRcLlreUU1mA+8RaF3rfMNqlBojkzVcQ=; b=Ck2zRM80L+Qxqipt4mSS11+7qw
        3wt2R/x852k76evmri64Rl9DQZdFsmxHGWtLNNG3JFK15gV8zrx6/7iALpGpohjLvyr+rLwKVCTN8
        l1q7Afhc4Zi41eTbyPEqIOXFwmNmTmUPXvQ5eYvbBVyLRSnFL2Ugg7mnkHhuQM1K99Sw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mQ7sP-006aQd-Mg; Tue, 14 Sep 2021 14:49:29 +0200
Date:   Tue, 14 Sep 2021 14:49:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rosen Penev <rosenp@gmail.com>
Subject: Re: [PATCH net-next] net: phy: at803x: add support for qca 8327
 internal phy
Message-ID: <YUCaWdyxY/aKaxqk@lunn.ch>
References: <20210914071141.2616-1-ansuelsmth@gmail.com>
 <YUCUar+c28XLOCXV@lunn.ch>
 <YUCVo4+wS3Q1Tg6Q@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUCVo4+wS3Q1Tg6Q@Ansuel-xps.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Have you tried the cable test code on this PHY?
> 
> Yes I tried, the documentation is very confusionary and with a simple
> implementation it looks like it doesn't work at all... In one
> documentation version the reg for cable test are described but by
> actually implementing and setting the correct regs nothing happen and
> the random results are reported. I honestly thing it doesn't support
> cable test at all...

O.K, thanks for testing.

     Andrew
