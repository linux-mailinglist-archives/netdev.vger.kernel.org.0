Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6F738D921
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 07:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbhEWF3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 01:29:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:59940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229895AbhEWF3O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 May 2021 01:29:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A95EF61152;
        Sun, 23 May 2021 05:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621747669;
        bh=Rag6KRidlmF0WNk5FT8kTB/POMH9pZAxL8RY/wp8sG4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ihZ22aRisqKvm+viZJ2XWTTcRY6mRMVH7yASB4lZfaG/IPQZ4UY0nAoehfDVL5UdV
         xtZWlz35NjjG9vl/C0r6CmyyqvjW467HfjxUvfZi1M+3MR0wxQBKwrqYeFtPjlydbc
         YBjvjH1Xr4HS+zReUCeVyIQqdUtXKMXCf8DDx7hbY0rxwZXkcOjcMLfEm9GHFyq8ZR
         WpXGa4dnkI6Y8hAB1643be9IkXcyojdix4PLaCRuwIQJHV28t1phzKNTyf13Ubt7go
         AfNxBq6y0Y3n5lKRXNjM9m9oL1WbD6Mi36UJcI01crE1Yka4G3Aj9EyYzzyAK/4ou9
         eQL/aWL/bmP6A==
Date:   Sun, 23 May 2021 13:27:43 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] ARM: dts: imx53-ard: Correct Ethernet node name
Message-ID: <20210523052743.GY8194@dragon>
References: <cover.1621518686.git.geert+renesas@glider.be>
 <daf2394440a8e6aae015b561f560e443aaa246bf.1621518686.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <daf2394440a8e6aae015b561f560e443aaa246bf.1621518686.git.geert+renesas@glider.be>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 03:58:36PM +0200, Geert Uytterhoeven wrote:
> make dtbs_check:
> 
>     lan9220@f4000000: $nodename:0: 'lan9220@f4000000' does not match '^ethernet(@.*)?$'
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Applied, thanks.
