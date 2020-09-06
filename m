Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6948525F01B
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 21:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbgIFT2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 15:28:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725833AbgIFT2b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 15:28:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB4E82080A;
        Sun,  6 Sep 2020 19:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599420511;
        bh=bearzM1U4IFMhUlsgLo+w3efAp+241PGZewjVhAyVAw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LUBYwLHb75JoO0bJrrcEvWuqCiV9aczaj4robV9XVnnNifehkOrGDBr2EGYNumGaO
         Rvq1WV8BPK8kokMsmjKwUYty8XgWDgEeU5ZzKdd7+kt/MniDFHHQAn88k3Y00qGydg
         PzmW1wiZgd9E8hGQX4mkzjdkCIiI9fMJHW0B983A=
Date:   Sun, 6 Sep 2020 12:28:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3] net: gemini: Clean up phy registration
Message-ID: <20200906122829.4a8503bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200906192113.53801-1-linus.walleij@linaro.org>
References: <20200906192113.53801-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  6 Sep 2020 21:21:13 +0200 Linus Walleij wrote:
> It's nice if the phy is online before we register the netdev
> so try to do that first.
> 
> Stop trying to do "second tried" to register the phy, it
> works perfectly fine the first time.
> 
> Stop remvoving the phy in uninit. Remove it when the
> driver is remove():d, symmetric to where it is added, in
> probe().
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Reported-by: David Miller <davem@davemloft.net>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v2->v3:
> - Fix a goto on the errorpath noticed by Jakub.
> ChangeLog v1->v2:
> - Do a deeper clean-up and remove the confusion around
>   how the phy is registered.

Applied, thanks!
