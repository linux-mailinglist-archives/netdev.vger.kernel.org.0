Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E442DCA2D
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 01:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgLQAu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 19:50:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:47388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725974AbgLQAu4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 19:50:56 -0500
Date:   Wed, 16 Dec 2020 16:50:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608166215;
        bh=aMPx1BS1s58qCfJfx/6jW5tudNHYYiDs0NdSdwcgzks=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=oe4gzm2cjDvXnY4xHqmz14hHXYEjOb4ck/MdE52UGC1PWlh99IKapNZm3cFNlS2p5
         YjidQljex/vI3KZ6U66AZnCAHc+IuIn5t+T6vKZqrfEphMql1/hdZw8WqNLor+QbTo
         lCfOpA73jjM5D5wHPHdOBGgsiSgFOT4kUEqZvs1K9lRfXzfAhJXCsfmBc0TJd+QGmA
         SzsILHsKGyR5DUN4Fq2mS/37lgqLBk+AlKSt3XTH6fBkp2iVTffBk5CqRFuAbaUNp0
         frxwq675h7E90ROu4RJJQb+cwY9p0T1qtDNQoVFmx6IygbmtNkRFcPJ4ZyaVRp7RR9
         WNeQe32ehwOTg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] r8169: facilitate adding new chip versions
Message-ID: <20201216165014.7d26f963@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <d2d55677-3b6a-9918-e177-9968fc59b460@gmail.com>
References: <d2d55677-3b6a-9918-e177-9968fc59b460@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Dec 2020 17:15:05 +0100 Heiner Kallweit wrote:
> Add a constant RTL_GIGA_MAC_MAX and use it if all new chip versions
> handle a feature in a specific way. As result we have to touch less
> places when adding support for a new chip version.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Looks harmless, but also non-urgent so let's wait for net-next to open.
