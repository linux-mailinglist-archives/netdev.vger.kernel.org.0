Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBBED46EAFB
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 16:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235374AbhLIPX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 10:23:57 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:35664 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234646AbhLIPX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 10:23:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5B692CE1FD9
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 15:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DAF6C004DD;
        Thu,  9 Dec 2021 15:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639063219;
        bh=G3CzW9YqMDQ85hcLBMmtpdLygjuszqwcoSMdVLvx2XE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lEwdULs5lXfMxQLZ66fWp5tq+My2tvHGY7a2eXdk1sFJnHVfTSqtstDClOAuEasGE
         42E5sgO9u6V+jQ6tI0+MElCjL+appzKwnv34mP3gw3oC4f9c2vAlLUJGn9IYXluLsk
         HC+5PEQ0bfAYc6zkNQf22BA7q7HVURwGna6yeLNndRZ8sEazr8DOOAv8Hy1flCdW1W
         vzT6xCxxaRR81G5jOkQg7dy5s16K2Hy93eMaLy0hKyVrDrv2YiK97CRPmR/g9loFIx
         LET5f/uDOX8IOf8Z0hdq1FYIerjnKTrhVI7n24l38Pkyz6X3V7Cm7upBrfTq8m9P0n
         lqS7Ub5bliEUQ==
Date:   Thu, 9 Dec 2021 07:20:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Chris Snook <chris.snook@gmail.com>, Felix Fietkau <nbd@nbd.name>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] net: phylink: add legacy_pre_march2020
 indicator
Message-ID: <20211209072018.6f0413ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YbIBT7/6b0evemPB@shell.armlinux.org.uk>
References: <DGaGmGgWrlVkW@shell.armlinux.org.uk>
        <E1mucmf-00EyCl-KA@rmk-PC.armlinux.org.uk>
        <YbIBT7/6b0evemPB@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Dec 2021 13:14:55 +0000 Russell King (Oracle) wrote:
> This series was incorrectly threaded to its cover letter; the patches
> have now been re-sent with the correct message-ID for their cover
> letter. Sadly, this mistake was not obvious until I looked at patchwork
> to work out why they haven't been applied yet.

Hm, I think they were showing up fine in patchwork, I just didn't 
get to them, yet. I'll apply as soon as I'm done with the weekly PR.
