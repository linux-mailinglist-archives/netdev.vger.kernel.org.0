Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5847238B299
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 17:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242806AbhETPJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 11:09:48 -0400
Received: from elvis.franken.de ([193.175.24.41]:41345 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232452AbhETPJq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 11:09:46 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1ljkHS-0001VG-01; Thu, 20 May 2021 17:08:10 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 47969C101E; Thu, 20 May 2021 17:07:42 +0200 (CEST)
Date:   Thu, 20 May 2021 17:07:42 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] MIPS: SEAD3: Correct Ethernet node name
Message-ID: <20210520150742.GB22843@alpha.franken.de>
References: <cover.1621518686.git.geert+renesas@glider.be>
 <b708fdb009912cf247ef257dce519c52889688d8.1621518686.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b708fdb009912cf247ef257dce519c52889688d8.1621518686.git.geert+renesas@glider.be>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 03:58:38PM +0200, Geert Uytterhoeven wrote:
> make dtbs_check:
> 
>     eth@1f010000: $nodename:0: 'eth@1f010000' does not match '^ethernet(@.*)?$'
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  arch/mips/boot/dts/mti/sead3.dts | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
