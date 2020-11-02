Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE51C2A370C
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 00:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgKBXRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 18:17:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:60376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725831AbgKBXRJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 18:17:09 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E53092225E;
        Mon,  2 Nov 2020 23:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604359029;
        bh=biCUf2cUK9m86UfR7bxkBHVCbJwZo+y2Vceg1KkmJrE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=grXap7UGdDL0yZ+h8E49WNyBO5LPij3L+M4P3YIH+ydYIXCIyzh2Rfem111ZJ+O4p
         5/Lug/TrJtvI53zgv++REM9yEppgNTVZ84dv5xdRO18CNGyXN0V8N2MiQDU32jet4n
         7n5Gd9EKREM6l0ey61fAG6guIO6tLmv0QJqmWCAk=
Date:   Mon, 2 Nov 2020 15:17:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jonathan McDowell <noodles@earth.li>,
        DENG Qingfang <dqfext@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: qca8k: Fix port MTU setting
Message-ID: <20201102151707.2357185b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201030184733.GB1042051@lunn.ch>
References: <20201030183315.GA6736@earth.li>
        <20201030184733.GB1042051@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 19:47:33 +0100 Andrew Lunn wrote:
> On Fri, Oct 30, 2020 at 06:33:15PM +0000, Jonathan McDowell wrote:
> > The qca8k only supports a switch-wide MTU setting, and the code to take
> > the max of all ports was only looking at the port currently being set.
> > Fix to examine all ports.
> > 
> > Reported-by: DENG Qingfang <dqfext@gmail.com>
> > Fixes: f58d2598cf70 ("net: dsa: qca8k: implement the port MTU callbacks")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Jonathan McDowell <noodles@earth.li>  
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!
