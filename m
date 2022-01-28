Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3069349FEE5
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 18:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350155AbiA1RSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 12:18:42 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60654 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343587AbiA1RSe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 12:18:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=YKisPcOSGF3xjifs1wMGTqqvENePaok9bKk7j2Jrwv0=; b=QY
        W7Ak6Mi4/gG5qKTNh4bOdA5XdsvhEqxAz/XSgabehuTBntCfli0DKmI5yCWIIv3EpZ6IIgCpcjBk4
        9xJU0ti0j3fv4LCKY7qXCxcWZdTaNBLwIlF4k+t/fAweXaDwG+HYjuv4SiYS/oUg3XPtlr5DTH6Tt
        9iYwjZ+KoIXtIY8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nDUtJ-003Cej-Is; Fri, 28 Jan 2022 18:18:29 +0100
Date:   Fri, 28 Jan 2022 18:18:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>, erkin.bozoglu@xeront.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mt7530: make NET_DSA_MT7530 select
 MEDIATEK_GE_PHY
Message-ID: <YfQlZfNmwuHvqRhH@lunn.ch>
References: <20220128170544.4131-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220128170544.4131-1-arinc.unal@arinc9.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 28, 2022 at 08:05:45PM +0300, Arınç ÜNAL wrote:
> Make MediaTek MT753x DSA driver enable MediaTek Gigabit PHYs driver to
> properly control MT7530 and MT7531 switch PHYs.
> 
> A noticeable change is that the behaviour of switchport interfaces going
> up-down-up-down is no longer there.
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
