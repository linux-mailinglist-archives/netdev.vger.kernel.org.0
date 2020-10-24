Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14B4297A39
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 03:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1759129AbgJXBpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 21:45:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758589AbgJXBpo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 21:45:44 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8C4624248;
        Sat, 24 Oct 2020 01:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603503944;
        bh=2kucWq6fIPZuQcW+Bh9h6RNN0nO1xpFidJTTDqAqhEQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xSt1b31Lvzcc0WIbFkjImUmzJW/wJyfgR6TZDFKtipoEciHyi/V24K3EUw3HA5xKQ
         XDSNDRL5KkSFvnkzOW5MJ3H58NeL53JswhmLyDerWf4aiP+vZw4h7mc0lf+YWg4aZ3
         OOhCc7OBjXGyhv8U+JQrZixHDY4aT3Qc29YYLScs=
Date:   Fri, 23 Oct 2020 18:45:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     linuxppc-dev@ozlabs.org, netdev@vger.kernel.org,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        leoyang.li@nxp.com
Subject: Re: [PATCH] net: ucc_geth: Drop extraneous parentheses in
 comparison
Message-ID: <20201023184543.5b0a95c7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201023033236.3296988-1-mpe@ellerman.id.au>
References: <20201023033236.3296988-1-mpe@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Oct 2020 14:32:36 +1100 Michael Ellerman wrote:
> Clang warns about the extra parentheses in this comparison:
> 
>   drivers/net/ethernet/freescale/ucc_geth.c:1361:28:
>   warning: equality comparison with extraneous parentheses
>     if ((ugeth->phy_interface == PHY_INTERFACE_MODE_SGMII))
>          ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> It seems clear the intent here is to do a comparison not an
> assignment, so drop the extra parentheses to avoid any confusion.
> 
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

Applied, thanks!
