Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E0F2A1A2D
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 19:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbgJaS4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 14:56:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56642 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726627AbgJaS4U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 14:56:20 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYw2n-004XiQ-Re; Sat, 31 Oct 2020 19:56:05 +0100
Date:   Sat, 31 Oct 2020 19:56:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     linux@armlinux.org.uk, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sfp: Fix error handing in sfp_probe()
Message-ID: <20201031185605.GA932026@lunn.ch>
References: <20201031031053.25264-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201031031053.25264-1-yuehaibing@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 31, 2020 at 11:10:53AM +0800, YueHaibing wrote:
> gpiod_to_irq() never return 0, but returns negative in
> case of error, check it and set gpio_irq to 0.
> 
> Fixes: 73970055450e ("sfp: add SFP module support")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
