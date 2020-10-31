Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBAC2A1B43
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 00:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgJaXg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 19:36:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbgJaXg0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 19:36:26 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACD742087E;
        Sat, 31 Oct 2020 23:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604187385;
        bh=3K6DkpyVcrGY03TfsKBQAIW/tBOE9eiOOULl2PkDCfM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HubWiz5Mt2NshFVt4I0A+kJetq783jq7Xwt0OfMhnx5m+aFWltyQ6RjYaBydST7xh
         PeWds99aV+S2yTlN6tqkQGJaACkLvozPHUl94N5y3y8TCnRwTKQAhzq9QopGL8plx6
         sRkegZejaR2wuBnVEZ9iP3Vkll4q8DjOupRxVFFY=
Date:   Sat, 31 Oct 2020 16:36:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] r8169: remove unneeded memory barrier in
 rtl_tx
Message-ID: <20201031163624.170499bd@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <2264563a-fa9e-11b0-2c42-31bc6b8e2790@gmail.com>
References: <2264563a-fa9e-11b0-2c42-31bc6b8e2790@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 18:56:06 +0100 Heiner Kallweit wrote:
> tp->dirty_tx isn't changed outside rtl_tx(). Therefore I see no need
> to guarantee a specific order of reading tp->dirty_tx and tp->cur_tx.
> Having said that we can remove the memory barrier.
> In addition use READ_ONCE() when reading tp->cur_tx because it can
> change in parallel to rtl_tx().
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks!
