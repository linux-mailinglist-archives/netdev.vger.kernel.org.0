Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23870381954
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 16:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbhEOOXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 10:23:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41774 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229504AbhEOOXY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 May 2021 10:23:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=MR2LQGbgBi0HImk/cE0GxhBMBr8Hg8A3/15wpk/C67Y=; b=q5toZA1N3iZvmAK1Rx6K/vZeIg
        dhiAH3CazC4iShurImTFUvyMEABnX8itWvGA5mpIu6X6PdRMxq5y2CSukvhqLiBAwh4i//OJ5NrBv
        uQlyYen59A1d9vvflj1vv5jlUeeGBnVpQdBIUpPx7GgwJuE23mBePk/5OU80992r3WRs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lhvAx-004Knz-V8; Sat, 15 May 2021 16:21:55 +0200
Date:   Sat, 15 May 2021 16:21:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yang Shen <shenyang39@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Snook <chris.snook@gmail.com>
Subject: Re: [PATCH 02/34] net: atheros: atl1c: Fix wrong function name in
 comments
Message-ID: <YJ/ZA+InkRASSWAX@lunn.ch>
References: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
 <1621076039-53986-3-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1621076039-53986-3-git-send-email-shenyang39@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 15, 2021 at 06:53:27PM +0800, Yang Shen wrote:
> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/ethernet/atheros/atl1c/atl1c_main.c:442: warning: expecting prototype for atl1c_set_mac(). Prototype was for atl1c_set_mac_addr() instead
>  drivers/net/ethernet/atheros/atl1c/atl1c_main.c:969: warning: expecting prototype for atl1c_setup_mem_resources(). Prototype was for atl1c_setup_ring_resources() instead
>  drivers/net/ethernet/atheros/atl1c/atl1c_main.c:1375: warning: expecting prototype for atl1c_configure(). Prototype was for atl1c_configure_mac() instead
> 
> Cc: Chris Snook <chris.snook@gmail.com>
> Signed-off-by: Yang Shen <shenyang39@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
