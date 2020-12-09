Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE612D4AB2
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 20:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387880AbgLITnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 14:43:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:43206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387857AbgLITms (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 14:42:48 -0500
Date:   Wed, 9 Dec 2020 11:42:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607542923;
        bh=yQXE05cdLb/dLO1CFMaMF1kDgHxY35e7OwT9CiVhJ7w=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=T1/DVTzmn/Z1a91aubV5zifgLYnHyksvMSMD6h8kzP2ptHa0ZjACbfAh/xg12LTC0
         bki/GcsoW98tGxfLnR/2ajk6XjpzrbpL0tae4aBUvR2PKY4mrL11VqCJgpnkOPeMwS
         fmAEqFW6DfCxKACE1zMPfdS7JWIgY0JOXlYd6tmt99SFLvmSGPMya05Ba8mA0GLBII
         3r4ncXuq8HO870nL+FgxM6ss/1i8BKHGSDLLvfSmUjcgMfzuPfF/mnXqdsSmm62Osw
         m5Io5nZDotZ7O6TyLrXTfeZYzZXpBA0gLUBhcgNhh4Fn2dIIsTNLlCgyHPkUO6elfX
         sP00n0Cn0+WEA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <olteanv@gmail.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next] net: sja1105: simplify the return
 sja1105_cls_flower_stats()
Message-ID: <20201209114202.4f2b27bf@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201209092504.20470-1-zhengyongjun3@huawei.com>
References: <20201209092504.20470-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Dec 2020 17:25:04 +0800 Zheng Yongjun wrote:
> Simplify the return expression.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Looks like this one doesn't apply cleanly to net-next.
