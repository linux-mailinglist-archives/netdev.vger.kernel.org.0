Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6503E3ED153
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 11:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235502AbhHPJzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 05:55:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235336AbhHPJzL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 05:55:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5935461B72;
        Mon, 16 Aug 2021 09:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629107679;
        bh=rPHYIXTB11jTLUaw8xSCpjfzdCFfMm8VFV2GzvAfkb4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VRO2j5/pJm8WYPaiWFwt+7bLKrzguPBjC5t2HwDyEw/hO9mS9lnlYzT30/siBqKmo
         fihZOGhDsy5WPhwnCQb4NXdCmrYAmtUagg709AtqRy2ihFBZQGgsffrxZlUj8NLx/a
         kXEgVTEmul7EsrDKemw5iroi+8ats8kZgUx994kjA2aG13639FbgtrlStAyR8VAx2h
         iTWDF6Qrvj5lmxHw9qxl9y4PabIWaicc+p+vRnb7gl/EZE0uJsAiR61kDQN/NWnNrL
         yrlb3m1Puph3mSkyWDHLEOgCs21qyJBlOa+lGV818PHpLDgcsLkJ9oXz+g6StasqSc
         AQFxuyWZkbalg==
Date:   Mon, 16 Aug 2021 11:54:35 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     "Song, Yoong Siang" <yoong.siang.song@intel.com>
Cc:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/1] net: phy: marvell10g: Add WAKE_PHY support
 to WOL event
Message-ID: <20210816115435.664d921b@dellmb>
In-Reply-To: <PH0PR11MB49509E7A82947DCB6BB48203D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
References: <20210813084536.182381-1-yoong.siang.song@intel.com>
        <20210814172656.GA22278@shell.armlinux.org.uk>
        <YRgFxzIB3v8wS4tF@lunn.ch>
        <20210814194916.GB22278@shell.armlinux.org.uk>
        <PH0PR11MB4950652B4D07C189508767F1D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
        <YRnmRp92j7Qpir7N@lunn.ch>
        <PH0PR11MB4950F854C789F610ECD88E6ED8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
        <20210816071419.GF22278@shell.armlinux.org.uk>
        <PH0PR11MB495065FCAFD90520684810F7D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
        <20210816081812.GH22278@shell.armlinux.org.uk>
        <PH0PR11MB49509E7A82947DCB6BB48203D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Aug 2021 08:56:36 +0000
"Song, Yoong Siang" <yoong.siang.song@intel.com> wrote:

> Yes, you are right. I missed the effect of get_wol.
> Is it needed in future to implement link change interrupt in phy
> driver? Cause I dint see much phy driver implement link change
> interrupt.

If there is a board that has interrupt pin wired correctly from the
PHY and the interrupt controller is safe to use (i.e. it is not a
PCA953x which cannot handle interrupt storms correctly), then I think
the PHY driver should use the interrupt, instead of polling.

Marek
