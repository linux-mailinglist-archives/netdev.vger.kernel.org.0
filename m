Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFACF3012AF
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 04:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbhAWDc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 22:32:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:47624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726508AbhAWDcQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 22:32:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6FDB23A79;
        Sat, 23 Jan 2021 03:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611372696;
        bh=UpdDbZmMb7GCFnFAq3x7W7JTs+dmAc/OoViEEzYNf1g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZY//hYrxgWZTdDnjKNknJCtyxW1zWYnzIawicpZQRgxbKfGYsp7H2X6FveeKHy65q
         jqan6i/9CPbBsM9ry3qY4aa/hMCHiJn0IrmoltqzhLYjwzGvNvTbtYpZEWg4063STc
         naoRR1zXR8rMWn/JCZdOW/SgbBDT+rJlUo+6826ANPL3B7WPT+BIQ7Wlgxer74NR4P
         9rYo0gYH8PehMahcMkqJffCoo25JXZ/aB2LlbZ2ptI93Mln3gXSAZS0P+74aoWirDQ
         x5oL8rfk7oyD02M/Z73jnD0MLjkNsWQp2Y+2LcuYJnnZ5BYQ+Np2LaaIoGgL4pp/ks
         PEnp2fCnQ6PSw==
Date:   Fri, 22 Jan 2021 19:31:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] dt-bindings: net: renesas,etheravb: Add r8a779a0
 support
Message-ID: <20210122193134.2da2ff29@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210121100619.5653-2-wsa+renesas@sang-engineering.com>
References: <20210121100619.5653-1-wsa+renesas@sang-engineering.com>
        <20210121100619.5653-2-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jan 2021 11:06:15 +0100 Wolfram Sang wrote:
> Document the compatible value for the RAVB block in the Renesas R-Car
> V3U (R8A779A0) SoC. This variant has no stream buffer, so we only need
> to add the new compatible and add it to the TX delay block.
> 
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Acked-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> ---
> 
> Please apply via netdev tree.

Done, thank you!
