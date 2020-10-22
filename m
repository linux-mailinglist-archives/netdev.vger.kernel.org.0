Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE492955F4
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 03:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894597AbgJVBNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 21:13:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2894585AbgJVBNT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 21:13:19 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E10222206;
        Thu, 22 Oct 2020 01:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603329198;
        bh=hRSK5jgPP6SQkhADwi5D+5wcZXb/oB5ihs9bdluPud8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pT4iXXRK0wWPsL/2GD4C2/kT6vtSr9y6ITMg9VGLRB6f2KvkFteJWVUrkztiZEjdW
         tIlNOSKvpFhK3PHeJ4se4VRAsauQOgKAoUrxNdRJTQRmpVDC3nJJajv0d/kzGn0wO7
         UA0vktFp65M0llBp2/FhZk1xJwg8LDtprE2FCS5Y=
Date:   Wed, 21 Oct 2020 18:13:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: mtk-star-emac: select REGMAP_MMIO
Message-ID: <20201021181316.78bc9700@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201020073515.22769-1-brgl@bgdev.pl>
References: <20201020073515.22769-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 09:35:15 +0200 Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> The driver depends on mmio regmap API but doesn't select the appropriate
> Kconfig option. This fixes it.
> 
> Fixes: 8c7bd5a454ff ("net: ethernet: mtk-star-emac: new driver")
> Cc: <stable@vger.kernel.org>

No need, we queue all fixes from the networking tree to stable, anyway.

> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Applied, thanks!
