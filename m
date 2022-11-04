Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCAF619C05
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 16:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbiKDPrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 11:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232700AbiKDPqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 11:46:55 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE3F326C1;
        Fri,  4 Nov 2022 08:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=N/hzabIn0VSZXMFrKsceIMGkl0PatMhX/lChydvkt7A=; b=1IyTJYob5aKKM+j/jPx02RSEZ9
        ELKFRG4wsGm2COkHXOsnGiNTCdr5BD1Pd51dcQFpPrQ7cwhwuzwQfxcPd6NnbXDpoet/q0A1KCjHi
        b2NPljlyfbdRSsT8KPCffxEorftmsJ6X+zhLzUau8b38uAN2DdClpEViJlUnFH+KMum8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oqyu1-001RXl-Kx; Fri, 04 Nov 2022 16:46:41 +0100
Date:   Fri, 4 Nov 2022 16:46:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     richardcochran@gmail.com, bagasdotme@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH -next v3] net: ethernet: Simplify bool conversion
Message-ID: <Y2Uz4Sea8xekgpyR@lunn.ch>
References: <20221104063731.84008-1-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104063731.84008-1-yang.lee@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 02:37:31PM +0800, Yang Li wrote:
> The result of 'scaled_ppm < 0' is Boolean, and the question mark
> expression is redundant, remove it to clear the below warning:
> 
> ./drivers/net/ethernet/renesas/rcar_gen4_ptp.c:32:40-45: WARNING: conversion to bool not needed here
> 
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2729
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
> 
> change in v3:
> --According to Richard's suggestion, to preserve reverse Christmas tree order.

Don't send a new version of a patch for at least 24 hours.

https://docs.kernel.org/process/maintainer-netdev.html#tl-dr

People need time to review your patch and suggest how to make it
better.

	Andrew
