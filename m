Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B1439A696
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbhFCREK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:04:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43652 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229753AbhFCREJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:04:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=dlLfA1/Ys0ZiRcO0YwSlr9cVr+Zsn1kL6tFU0WA6UDc=; b=blXnLtEUqpvWYpc+fj0I7crPKH
        HyY8uT4NWljWjMKlNhGEafboYZARaNzWfjhJWfJJcISwvJUDzNBBUrZP6HCaYDZxCjEVLUNgIm+FI
        pwxJvhUgDup4f9FVW0yFyR28xKLHB1Rd8GrsvnFYA9moA1vI98G9xXhvLHEkEiQjUupY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1loqja-007f4R-P5; Thu, 03 Jun 2021 19:02:18 +0200
Date:   Thu, 3 Jun 2021 19:02:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH net-next] net: ks8851: Make ks8851_read_selftest() return
 void
Message-ID: <YLkLGoJvt7EfG6PO@lunn.ch>
References: <20210603165612.2088040-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603165612.2088040-1-nathan@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 03, 2021 at 09:56:13AM -0700, Nathan Chancellor wrote:
> clang points out that ret in ks8851_read_selftest() is set but unused:
> 
> drivers/net/ethernet/micrel/ks8851_common.c:1028:6: warning: variable
> 'ret' set but not used [-Wunused-but-set-variable]
>         int ret = 0;
>             ^
> 1 warning generated.
> 
> The return code of this function has never been checked so just remove
> ret and make the function return void.
> 
> Fixes: 3ba81f3ece3c ("net: Micrel KS8851 SPI network driver")
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
