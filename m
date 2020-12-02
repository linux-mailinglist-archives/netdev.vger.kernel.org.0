Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F242CB21B
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 02:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgLBBKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 20:10:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:40424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726903AbgLBBKe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 20:10:34 -0500
Date:   Tue, 1 Dec 2020 17:09:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606871393;
        bh=iqAnsZ8dXIIAkSNAlw8bQD25545w7qecf5AhMC1Bgc8=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xoj/sZX9+bVS3rRuY8YzxAzy+Hc4hDZpvKFFD3PCmABIVQUXc2wKPUc768Q+OFO0C
         JoTKaJV0trupTkurIXV1izeggHUxDoX3++dMtwKtm42Ldh129a4pni2mgh/bD+aeyG
         APYh2ByOwL6wTWJA9fVWlmoWANDdK1KTB7YRjGuM=
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yejune Deng <yejune.deng@gmail.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell: replace phy_modify()
Message-ID: <20201201170952.5693a9d9@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <1606732895-9136-1-git-send-email-yejune.deng@gmail.com>
References: <1606732895-9136-1-git-send-email-yejune.deng@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Nov 2020 18:41:35 +0800 Yejune Deng wrote:
> a set of phy_set_bits() looks more neater
> 
> Signed-off-by: Yejune Deng <yejune.deng@gmail.com>

Looks like that's what those helpers are for so applied to net-next,
thanks.
