Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4742F04FA
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 04:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbhAJDsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 22:48:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:34468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726132AbhAJDsE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 22:48:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6503922CF8;
        Sun, 10 Jan 2021 03:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610250443;
        bh=raEhoI19UPJzeVLAWkonsYk5GEhEQX5kJoN/lHy21vw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VTrX8Rcpn3FRGnTKMyB/5lJtWX8ePR5tVZiR+EDOfj4dAe/bWNQZqJurqqyklHNPc
         QI3jrhC/G9nhIn0gFZUhpmS3ZKoZnWd7gPwFRXDBBgxhLOdrxU5+kAdjQ/qyDOgdR0
         jmOy6iWIWeaNTB0bnPPQQzjKtInstisIueaoIHQ653mS1Gn7yddh0VONorRU9pjQ87
         RONRe0iqOzYkSte6oW7aG1Dyhqmlw53S0o0ZUrKSahOWhxqe8qUEazrbxdjRYYYhVd
         nSWYsKMbuPXvPH1mppWtkMUfOsciUEiJyL0wMrn2WmcEYt9ZhXs3iPfkLShnmbeQjm
         9MjE99+SExW4Q==
Date:   Sat, 9 Jan 2021 19:47:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: renesas,etheravb: RZ/G2H needs
 tx-internal-delay-ps
Message-ID: <20210109194722.64c64aa4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210105151516.1540653-1-geert+renesas@glider.be>
References: <20210105151516.1540653-1-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  5 Jan 2021 16:15:16 +0100 Geert Uytterhoeven wrote:
> The merge resolution of the interaction of commits 307eea32b202864c
> ("dt-bindings: net: renesas,ravb: Add support for r8a774e1 SoC") and
> d7adf6331189cbe9 ("dt-bindings: net: renesas,etheravb: Convert to
> json-schema") missed that "tx-internal-delay-ps" should be a required
> property on RZ/G2H.
> 
> Fixes: 8b0308fe319b8002 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

I don't see this in linux-next so applied to net, thanks!
