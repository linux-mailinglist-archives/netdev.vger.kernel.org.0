Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECAF62A391B
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 02:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbgKCBXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 20:23:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:38580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728248AbgKCBXN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 20:23:13 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B16632063A;
        Tue,  3 Nov 2020 01:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604366592;
        bh=ssA16D20e+6tilasRa0zK2RKKAFIEnFFPP/i86RcQ6E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kRc+9DKORiaUyywSyf6Z5ueFh1B59QcTAEJmRNaux56Xa4QywGqS9rGO5WaXIoY9L
         os4K9T46FFEXNSSo65+u9tBQeq6dugosI/YCp5HPmuSt5Y+NV82+YgbWBM54FHhNgU
         snS71WqXQEFDQalfoTZWFecH59Y9TPOMrSuFrB7E=
Date:   Mon, 2 Nov 2020 17:23:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     YueHaibing <yuehaibing@huawei.com>, linux@armlinux.org.uk,
        hkallweit1@gmail.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sfp: Fix error handing in sfp_probe()
Message-ID: <20201102172310.40b9dc4a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201031185605.GA932026@lunn.ch>
References: <20201031031053.25264-1-yuehaibing@huawei.com>
        <20201031185605.GA932026@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 31 Oct 2020 19:56:05 +0100 Andrew Lunn wrote:
> On Sat, Oct 31, 2020 at 11:10:53AM +0800, YueHaibing wrote:
> > gpiod_to_irq() never return 0, but returns negative in
> > case of error, check it and set gpio_irq to 0.
> > 
> > Fixes: 73970055450e ("sfp: add SFP module support")
> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>  
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!
