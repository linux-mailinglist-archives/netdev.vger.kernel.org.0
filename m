Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F229D3D7B45
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 18:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhG0Qma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 12:42:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47882 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhG0Qm2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 12:42:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+0o8GfKZm1hLo/DI9On+9timairw+rR2J105HPVi7cc=; b=kElsFs/Dnu5lRpf+xXqY8/ZeZo
        4gOiJguqyJcP1vp81G8xSe+6iYMiJXShmVdI/JogR25B5b+lH7pD626r+NKPAcaGpLAxgvEuMX1Ig
        G9FB2Pw849OrTZJcQA9iE+h12nFyuQvmDnYHpGiGJBKi2H9/M4s+FwcoKjLVnvKRgnwI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m8Q9q-00F2aL-5R; Tue, 27 Jul 2021 18:42:18 +0200
Date:   Tue, 27 Jul 2021 18:42:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Michael Walle <michael@walle.cc>, anthony.l.nguyen@intel.com,
        bigeasy@linutronix.de, davem@davemloft.net,
        dvorax.fuxbrumer@linux.intel.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com, jacek.anaszewski@gmail.com, kuba@kernel.org,
        kurt@linutronix.de, linux-leds@vger.kernel.org,
        netdev@vger.kernel.org, pavel@ucw.cz, sasha.neftin@intel.com,
        vinicius.gomes@intel.com, vitaly.lifshits@intel.com
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <YQA3ao+IGgqQ2vIR@lunn.ch>
References: <YP9n+VKcRDIvypes@lunn.ch>
 <20210727081528.9816-1-michael@walle.cc>
 <20210727165605.5c8ddb68@thinkpad>
 <c56fd3dbe1037a5c2697b311f256b3d8@walle.cc>
 <20210727172828.1529c764@thinkpad>
 <8edcc387025a6212d58fe01865725734@walle.cc>
 <20210727183213.73f34141@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727183213.73f34141@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Yes, this still persists. But we really do not want to start
> introducing namespaces to the LED subsystem.

Agreed. LED names need to be globally unique, so we don't need to
worry about network name spaces.

      Andrew
