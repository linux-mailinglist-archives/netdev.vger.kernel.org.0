Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8423541947D
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 14:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbhI0Moe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 08:44:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33652 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234408AbhI0Mod (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 08:44:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=t0upMTnZFAdEwNDHfxPY3nlX3H3hdRe4wLUvN1lec+M=; b=oa5I1bDpcLJ3yfJKyPCJo+sENE
        CS80YDV/uH4TEPjOHYVZv5GplUFpodMdUwE859k8D+8AqPV+E52O63oc1PgOFnUJivmcdpfXMJkoC
        4qsr5X2O658p+9KheocpGCBtRuiIkqZSW8rz3PJSFg3wcTRHjTAn5zXJvWU/CJiPhgJY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mUpy8-008RB5-4V; Mon, 27 Sep 2021 14:42:52 +0200
Date:   Mon, 27 Sep 2021 14:42:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Xu Liang <lxu@maxlinear.com>
Cc:     hkallweit1@gmail.com, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, vee.khee.wong@linux.intel.com,
        linux@armlinux.org.uk, hmehrtens@maxlinear.com,
        tmohren@maxlinear.com, mohammad.athari.ismail@intel.com
Subject: Re: [PATCH v2] net: phy: enhance GPY115 loopback disable function
Message-ID: <YVG8TPEXz9nREye1@lunn.ch>
References: <20210927070302.27956-1-lxu@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210927070302.27956-1-lxu@maxlinear.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 27, 2021 at 03:03:02PM +0800, Xu Liang wrote:
> GPY115 need reset PHY when it comes out from loopback mode if the firmware
> version number (lower 8 bits) is equal to or below 0x76.
> 
> Fixes: 7d901a1e878a ("net: phy: add Maxlinear GPY115/21x/24x driver")
> Signed-off-by: Xu Liang <lxu@maxlinear.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
