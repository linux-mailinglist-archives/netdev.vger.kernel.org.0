Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A7B2AA81E
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 22:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbgKGVYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 16:24:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:44088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgKGVYq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 16:24:46 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EFFD206DB;
        Sat,  7 Nov 2020 21:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604784285;
        bh=BFT8AiDGiOnrBrmOkHYjI06IqPwJCXPQDbVnQeOlgNY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BoVgnF4d72DKMOD5u+iPh1O00tp9JieqvGf7mPhR9R5y5EHBkBr6Z745QSffNLF+7
         0XCVsgGRZJlveuGY0cLehzgp6cq+T+4y/OXDe+aR/wZmBoEFokmkJvCVVoaIAOaboe
         QPWbApSj2o15qv0rNX/P3+o3DHHG6NsDVFuJma3s=
Date:   Sat, 7 Nov 2020 13:24:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nicolas Ferre <nicolas.ferre@microchip.com>
Cc:     Parshuram Thombare <pthombar@cadence.com>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <Claudiu.Beznea@microchip.com>, <Santiago.Esteban@microchip.com>,
        <andrew@lunn.ch>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <harini.katakam@xilinx.com>, <michal.simek@xilinx.com>
Subject: Re: [RESEND PATCH] net: macb: fix NULL dereference due to no
 pcs_config method
Message-ID: <20201107132444.560cc7c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <22c6b5ff-d19e-2af8-d601-341a2101d6ef@microchip.com>
References: <1604599113-2488-1-git-send-email-pthombar@cadence.com>
        <22c6b5ff-d19e-2af8-d601-341a2101d6ef@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 Nov 2020 10:26:59 +0100 Nicolas Ferre wrote:
> On 05/11/2020 at 18:58, Parshuram Thombare wrote:
> > This patch fixes NULL pointer dereference due to NULL pcs_config
> > in pcs_ops.
> > 
> > Reported-by: Nicolas Ferre <Nicolas.Ferre@microchip.com>
> > Link: https://lore.kernel.org/netdev/2db854c7-9ffb-328a-f346-f68982723d29@microchip.com/
> > Signed-off-by: Parshuram Thombare <pthombar@cadence.com>  
> 
> Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Applied.

I brought back the fixes tag from the first posting. It's entirely
reasonable to add fixes tags from the tree you're targeting as long 
as that tree guarantees commit hashes are stable and won't change on
their way upstream. Which is the case for net and net-next trees.

Thanks!
