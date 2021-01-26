Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6CE303544
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388032AbhAZFi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:38:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:40192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731970AbhAZCeR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 21:34:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2368522E03;
        Tue, 26 Jan 2021 02:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611628415;
        bh=CXSDmasxYWoFE33utykb2dQIYbJuGpoyGl2Cl9gp4Uo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZAUeJ0v1ugUS/fH6cXmUKDukqYBofneog+ZPN2jI2C+TiCICvl40Si+V61jGJLgaT
         kKh40TW8UP6Mfy7Gtx3yXSJUR04OYenEKkOe7Wicl7MzB9ONv8d9vKHjLd3eDjO3/E
         OISnHJX5nb70f8SQtLYqCYuSDQe7hLO/Ki5rM8qU7tfgNKDNbZ9E2R76AVnE+33IbC
         OrodICqTBXi5iKAW7I0e9Nrgy9Uxi0BMsnCxLz9PvTjEegYAESopf3PXIWacws0RkC
         zveeBIak+CSkQzBE39JcpNeMBflKnrujy8QnlI9h/q6Uy6E52NVPrNpqPHi5SD+/o+
         KNxjzDKgJCYLg==
Date:   Mon, 25 Jan 2021 18:33:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>, DENG Qingfang <dqfext@gmail.com>
Cc:     netdev@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Frank Wunderlich <frank-w@public-files.de>,
        David Woodhouse <dwmw2@infradead.org>,
        =?UTF-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>
Subject: Re: [PATCH net-next v2] net: ethernet: mediatek: support setting
 MTU
Message-ID: <20210125183334.7ad8ca00@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YA7BERdgmzKcAYus@lunn.ch>
References: <20210125042046.5599-1-dqfext@gmail.com>
        <YA7BERdgmzKcAYus@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 14:01:05 +0100 Andrew Lunn wrote:
> On Mon, Jan 25, 2021 at 12:20:46PM +0800, DENG Qingfang wrote:
> > MT762x HW, except for MT7628, supports frame length up to 2048
> > (maximum length on GDM), so allow setting MTU up to 2030.
> > 
> > Also set the default frame length to the hardware default 1518.
> > 
> > Signed-off-by: DENG Qingfang <dqfext@gmail.com>  
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!
