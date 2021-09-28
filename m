Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE6C41AE5E
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240524AbhI1MCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:02:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35794 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240514AbhI1MCN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 08:02:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=THuN358noEt3fQeP4VpcOCHPfZXYMNW8DrJloNvgVT4=; b=VY
        a6LHE1sW7G1eFvRUjwZiG3qkChUCGCFYwOzGXtr7i7sYHT4ckwvfKnHl48Det0NXQOBID8RvSGZUv
        We/3H8RYUkLjXRizmD04E5uQtCc/k636NYVscmrFtj0A3dP+gswxmw2hUJ95wG0BIPwAynXDWidwg
        htw5iTtEOOIG/Js=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mVBmO-008b4G-MV; Tue, 28 Sep 2021 14:00:12 +0200
Date:   Tue, 28 Sep 2021 14:00:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: mdio: mscc-miim: Fix the mdio controller
Message-ID: <YVMDzAcQSjuiqoud@lunn.ch>
References: <20210928071720.2084666-1-horatiu.vultur@microchip.com>
 <20210928085414.GA1723@LAPTOP-UKSR4ENP.internal.baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210928085414.GA1723@LAPTOP-UKSR4ENP.internal.baidu.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 04:54:14PM +0800, Cai Huoqing wrote:
> On 28 9月 21 09:17:20, Horatiu Vultur wrote:
> Hi Horatiu,
> 
> Thank for your feedback.
> 
> I'm sorry for this commit, my mistake.
> 
> After I have checked my recent submission history
> 
> the commit-
> commit fa14d03e014a130839f9dc1b97ea61fe598d873d
> drivers/net/mdio/mdio-ipq4019.c 225 line
> 
> has the same issue, an optional phy-regs
> Are you willing to fix it at the same time:)

Hi

Since it was a separate patch which broken it, it should be a separate
patch which fixes it.  Please send a fix.

You can also give a Reviewed-by: to Horatiu patch, if you think it is
correct.

Andrew
