Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A7E3F6C60
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 01:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235933AbhHXXyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 19:54:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:59428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233909AbhHXXyP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 19:54:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5548960E73;
        Tue, 24 Aug 2021 23:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629849210;
        bh=5PrZ337fz2o/HBYemiPOBpaodeXb86aUnW/V5+872+4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HCVTxTNFiHnYBIvv3ZvBYfk71jCvU4q1oueHNUrAVa7/9rKO4ZsC27+BBt1Zg/FUi
         i8olo7oyDfBARkZsTuweM41K6w0JVy0hf2q3pwBW5zBCdXmA7yRcJljNaheF6+kE1O
         c8jzcNsVSHEmTdpbNnHw86L8gcH74JDINVu53TUkRBiibuyboSIPvBztFhSr7VJouo
         m0xKlASWFNYyp4HMxs2zDo1/H7iCYLc2FHRSvolbi439/JYgMzPzOC2J9ipvSlCCfw
         pRWIG98Bp/sk5h6cKjnaG1wnpmrS8hEajiVffaOIEsF06IDNvPExdmdgX7ZLh/XONN
         cihFgtsR1KRtQ==
Date:   Tue, 24 Aug 2021 16:53:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>, DENG Qingfang <dqfext@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "open list:ETHERNET PHY LIBRARY" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH net] net: phy: mediatek: add the missing suspend/resume
 callbacks
Message-ID: <20210824165329.7318588d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YSOb2P43svWca9IJ@lunn.ch>
References: <20210823044422.164184-1-dqfext@gmail.com>
        <YSOb2P43svWca9IJ@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Aug 2021 15:00:08 +0200 Andrew Lunn wrote:
> On Mon, Aug 23, 2021 at 12:44:21PM +0800, DENG Qingfang wrote:
> > Without suspend/resume callbacks, the PHY cannot be powered down/up
> > administratively.
> > 
> > Fixes: e40d2cca0189 ("net: phy: add MediaTek Gigabit Ethernet PHY driver")
> > Signed-off-by: DENG Qingfang <dqfext@gmail.com>  
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!
