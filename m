Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C432D3478
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729631AbgLHUo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:44:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:46830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728137AbgLHUo1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 15:44:27 -0500
Date:   Tue, 8 Dec 2020 11:24:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607455499;
        bh=5mNoZcWfwuKPbRgLdnCU2qOanlr7ktk6e/1/0j8cQQ4=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=CrAQF49l1ARyOOvycyYSU9awhGEg9HXIxCWGd/PtLR2m3swcTxc0MGO60gKGuc20p
         hyRZN8oVIZOEDAAs+RiEk6R0LfNhlSPR8f31bF5RNcojEgLLQkHTX4WB0xugu3gjkZ
         azTX4HZTKxZZ/43qQ6A7MVGKxHmYekYSyxAvAvWS4cxPo3BD44Ipnqo/2FurjwPly3
         dxsnHlNiVL2wPJEBBMe+Wq5pQ4frjo3KklASNRsJCM3KYqbVsENT1nihWMyWhCRClP
         yxota/Oqxc/zeux8uWW9zG/bIgIlq7p7SSqkMhd94zoiuo6g8o8/fsBVLGTi4rkJF9
         pYDM79jl9hxsA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: print the MTU value that could not
 be set
Message-ID: <20201208112458.53003fe6@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201205133944.10182-1-rasmus.villemoes@prevas.dk>
References: <20201205133944.10182-1-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  5 Dec 2020 14:39:44 +0100 Rasmus Villemoes wrote:
> These warnings become somewhat more informative when they include the
> MTU value that could not be set and not just the errno.
> 
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

Applied, thanks!
