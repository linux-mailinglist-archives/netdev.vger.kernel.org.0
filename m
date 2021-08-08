Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021D43E3B24
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 17:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbhHHPkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 11:40:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38858 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229923AbhHHPkN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 11:40:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=CETo8NjZMwKXksccsf2bL/g9DbtIS4iyesheXI7oxOY=; b=1mhfKsKHTrBhqB7XjBZBqtRTbu
        uuMoMCgDuWghEKWrCEWLCtQQJzHNbf6Oz+KlwkOZwudZpevwZ7yAh6EzSfr2uuVAbFnA7mZ+/fDjX
        DOkTD3AjS9fGMO+ht3yi2hFyPBFaRj0QChkL4RWmZ4FefgRww5oiTQme2Kcv5qF9N2o8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mCkty-00Gapj-H7; Sun, 08 Aug 2021 17:39:50 +0200
Date:   Sun, 8 Aug 2021 17:39:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [Resend v1 0/2] net: mdio: Add IPQ MDIO reset related function
Message-ID: <YQ/6xmRplrWUUQB/@lunn.ch>
References: <20210808120018.2480-1-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210808120018.2480-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 08, 2021 at 08:00:16PM +0800, Luo Jie wrote:
> This patch series add the MDIO reset features, which includes
> configuring MDIO clock source frequency and indicating CMN_PLL that
> ethernet LDO has been ready, this ethernet LDO is dedicated in the
> IPQ5018 platform.
> 
> Specify more chipset IPQ40xx, IPQ807x, IPQ60xx and IPQ50xx supported by
> this MDIO driver.
> 
> The PHY reset with GPIO and PHY reset with reset controller are covered
> by the phylib code, so remove the PHY reset related code from the
> initial patch series. 

Why did you resend?

To the patchbot: I replied with comments on the first send. Do not
merge.

	Andrew
