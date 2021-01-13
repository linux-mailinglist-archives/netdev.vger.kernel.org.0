Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C7B2F4183
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 03:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbhAMCMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 21:12:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:36542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726011AbhAMCMG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 21:12:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 995B622EBE;
        Wed, 13 Jan 2021 02:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610503885;
        bh=Wqu/1Kbcsg7ThXLCO1QT+/hELhNuEWSAaPQADAwMci0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QIdR8l5W+/cpSnR7pXi/Xg32ncFZgV8xxKCL+15vpIBht3izZas3vElA2z1n3GLO1
         4mtoYp3GQr6sam7ybqDY52nQ/S1k1k8HEu1sK175XRRaeGE7tDEYxlLvoAUu+dl4fN
         ioZ/Km/czfwf9yiwSGfr+23WK+Y191NM8j+9Mqdw4z99ho+xuKgqE/8M04PGRFq+qi
         LmJ0zkjr+s7TlgX2UsPrUHoamhAK4mnvbIUDyfPoiAGHO2QhFvXy1rEfTjVyoUB6W2
         fwqTr31NL034PmK6ksxbcsv/9ETAZoECoxQTOlRjZDx4jnIUKkctvApAAi1xQi81cY
         98B4Uv6HdwBBA==
Date:   Tue, 12 Jan 2021 18:11:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Atish Patra <atish.patra@wdc.com>
Cc:     netdev@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: Re: [PATCH net v2] net: macb: Add default usrio config to default
 gem config
Message-ID: <20210112181124.11af8020@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210112014728.3788473-1-atish.patra@wdc.com>
References: <20210112014728.3788473-1-atish.patra@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jan 2021 17:47:28 -0800 Atish Patra wrote:
> There is no usrio config defined for default gem config leading to
> a kernel panic devices that don't define a data. This issue can be
> reprdouced with microchip polar fire soc where compatible string
> is defined as "cdns,macb".
> 
> Fixes: edac63861db7 ("net: macb: Add default usrio config to default gem config")
> Signed-off-by: Atish Patra <atish.patra@wdc.com>
> ---
> Changes from v1->v2:
> 1. Fixed that fixes tag.

Still needs a little bit of work:

Fixes tag: Fixes: edac63861db7 ("net: macb: Add default usrio config to default gem config")
Has these problem(s):
	- Subject does not match target commit subject
	  Just use
		git log -1 --format='Fixes: %h ("%s")'


Please make sure to keep Nic's Ack when reposting.
