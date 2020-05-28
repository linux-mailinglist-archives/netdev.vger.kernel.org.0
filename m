Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8881A1E5A95
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 10:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgE1ISX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 04:18:23 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:46215 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbgE1ISW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 04:18:22 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id F301223E40;
        Thu, 28 May 2020 10:18:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1590653900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HdBYkATTc//+jNMYSOCSa3ZZwhXDoB0+st0QSPzxGZ0=;
        b=oOn0/+f1TNm8FGMmDaeBQk5OjsSNGaOfDDzN/gWc7Vx2ZYAGVgZt1HLU0fQheq83QY2Fvc
        3nIBiIAU/2jIEyriF/xycIxcvoHswY1EP3BOgm19NdjRdcCgfTfbfPTzQ4cNKT3qPcUO6O
        kDeQG1aqOGlRdY9XiPmBsADtO1XQzHo=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 28 May 2020 10:18:19 +0200
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Heiko Thiery <heiko.thiery@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v3 0/3] net: enetc: remove bootloader dependency
In-Reply-To: <20200528063847.27704-1-michael@walle.cc>
References: <20200528063847.27704-1-michael@walle.cc>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <0130cb1878a47efc23f23cf239d0380f@walle.cc>
X-Sender: michael@walle.cc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2020-05-28 08:38, schrieb Michael Walle:
> These patches were picked from the following series:
> https://lore.kernel.org/netdev/1567779344-30965-1-git-send-email-claudiu.manoil@nxp.com/
> They have never been resent. I've picked them up, addressed Andrews
> comments, fixed some more bugs and asked Claudiu if I can keep their 
> SOB
> tags; he agreed. I've tested this on our board which happens to have a
> bootloader which doesn't do the enetc setup in all cases. Though, only
> SGMII mode was tested.
> 
> changes since v2:
>  - removed SOBs from "net: enetc: Initialize SerDes for SGMII and 
> USXGMII
>    protocols" because almost everything has changed.
>  - get a phy_device for the internal PCS PHY so we can use the phy_
>    functions instead of raw mdiobus writes

mhh after reading,
https://lore.kernel.org/netdev/CA+h21hoq2qkmxDFEb2QgLfrbC0PYRBHsca=0cDcGOr3txy9hsg@mail.gmail.com/
this seems to be the wrong way of doing it.

-michael
