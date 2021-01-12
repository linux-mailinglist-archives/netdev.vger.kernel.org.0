Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42962F3D62
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407041AbhALViU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:38:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:40916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437140AbhALVRS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 16:17:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB0AE23117;
        Tue, 12 Jan 2021 21:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610486197;
        bh=1Ds6BzSz0RX0akbNYRF0Ga5MOlANI7871nVvvTqKb/0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GlSJKpFivlnprIt3qSTwbXOAxjPqt28oRh6tVLqA9sXD0HtNjCPRcX7dChs8qC0+v
         /GqquO+pxuS4HBFK8yPY2e33juvUlvk/FztFxw5/5vHEnAVQnoMuNzrbAyhNZ4xQLL
         W0+aJhJh5FtuW+JGUNF5gh9InkG2pfp0bIWyDCcRKDXxRKkrCRFWuHBmz4OvaoKID1
         zQ5YHoEyZmkbW2MsyGt2mCVdz8TrAqu6Q9mwh0dNGtNG+epInS+mVXp05e8bhbzFt3
         OtcsLQV1gLNzGoOQiI2Vv1pTq3/hIiuECEc4zqui9NSh9M01nTXC3BZLcuarOOm8/B
         zPqiF6nbh5a3g==
Date:   Tue, 12 Jan 2021 22:16:32 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        lkp@intel.com, davem@davemloft.net, ashkan.boldaji@digi.com,
        andrew@lunn.ch, Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v15 5/6] net: dsa: mv88e6xxx: Add support for
 mv88e6393x family of Marvell
Message-ID: <20210112221632.611c8a7e@kernel.org>
In-Reply-To: <20210112203808.4mkryi3tcut7mvz7@skbuf>
References: <20210112195405.12890-1-kabel@kernel.org>
        <20210112195405.12890-6-kabel@kernel.org>
        <20210112203808.4mkryi3tcut7mvz7@skbuf>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021 22:38:08 +0200
Vladimir Oltean <olteanv@gmail.com> wrote:

> > +		phylink_set(mask, 10000baseT_Full);
> > +		phylink_set(mask, 10000baseCR_Full);
> > +		phylink_set(mask, 10000baseSR_Full);
> > +		phylink_set(mask, 10000baseLR_Full);
> > +		phylink_set(mask, 10000baseLRM_Full);
> > +		phylink_set(mask, 10000baseER_Full);  
> 
> Why did you remove 1000baseKR_Full from here?

I am confused now. Should 1000baseKR_Full be here? 10g-kr is 10g-r with
clause 73 autonegotiation, so they are not compatible, or are they?

Marek
