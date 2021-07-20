Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A97323CFD9D
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 17:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241103AbhGTOwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:52:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239529AbhGTOXu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 10:23:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2895E6023B;
        Tue, 20 Jul 2021 15:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626793468;
        bh=p48Umejfa60qY+3hohcbuARxyJOE0wpRN9qh5yycDRo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u/SERsCvrDKPRrXoPYgtu3Opts7Yo/B1mehA+n/+7NXy3R49/V8yeC2ZmBCuGCruQ
         Tu9wQBtMV/yoeBnzIQ6SS7EAgcQNdqczmF2D0TkZyfFblcraY2/5oikHArtxOpzsAT
         AQ4TEgNt2eUfE8UVrmPjyAL09pC7RLMb3Vq2Zl2oe/qOynmMPumGosJRaxwulB+eWJ
         M5WVvXilmtDvrn5Y7o1E1FF4K8d/ZkmpKA8poUHDtxjmO9xuX88JpLOrzGlt8O8ltg
         Qqkz0W59qzXsUUtJwtF7Q9m5zRsNVyDlt+2rR49S2CqrVUY7uoPfnP2fm5MIVsKC8A
         O07psYvhj+tMA==
Date:   Tue, 20 Jul 2021 17:04:24 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH RFC net-next] net: phy: marvell10g: add downshift
 tunable support
Message-ID: <20210720170424.07cba755@dellmb>
In-Reply-To: <E1m5pwy-0003uX-Pf@rmk-PC.armlinux.org.uk>
References: <E1m5pwy-0003uX-Pf@rmk-PC.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Tue, 20 Jul 2021 14:38:20 +0100
Russell King <rmk+kernel@armlinux.org.uk> wrote:

> Add support for the downshift tunable for the Marvell 88x3310 PHY.
> Downshift is only usable with firmware 0.3.5.0 and later.

mv3310_{g,s}et_features are also used for 88E211x, but there is no such
register in the documentation for these PHYs. (Also firmware versions on
those are different, the newest is 8.3.0.0, but thats not important.)
My solution would be to rename the current methods prefix to mv211x_ and
and add new mv3310_{g,s}et_tunable methods.

Marek
