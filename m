Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036E82B30A4
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 21:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgKNUgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 15:36:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:33582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbgKNUgO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 15:36:14 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BD43223EA;
        Sat, 14 Nov 2020 20:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605386174;
        bh=ZdY8nPUPIIA8CI/+vJjOcvrkMUrXAxTH/bkxfEqtSek=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wnMlnHXLQG7hL0zyMjIGXQf07Bdddqg1nXbCrnxR1d2yZ2/rUaTIQDMHEYqqrvyVW
         0EqXmJHLp+vnBZeYVuTS3zcA1/hB76ZKk9qImTI8V/GUDyERN70HoAhE3fSUej2KQm
         nISzOh6dXJ9ed95RMmb4t2M75m0dzAJaDMsvHN4M=
Date:   Sat, 14 Nov 2020 12:36:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <harini.katakam@xilinx.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: macb: Fix passing zero to 'PTR_ERR'
Message-ID: <20201114123613.2e52fb49@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201112144936.54776-1-yuehaibing@huawei.com>
References: <20201112144936.54776-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 22:49:36 +0800 YueHaibing wrote:
> Check PTR_ERR with IS_ERR to fix this.
> 
> Fixes: cd5afa91f078 ("net: macb: Add null check for PCLK and HCLK")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Looks like a cleanup PTR_ERR() should return 0 for NULL AFAICS.

Applied to net-next, thanks!
