Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187882453FC
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 00:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729734AbgHOWKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 18:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729660AbgHOWKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 18:10:42 -0400
Received: from mail.pqgruber.com (mail.pqgruber.com [IPv6:2a05:d014:575:f70b:4f2c:8f1d:40c4:b13e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D5CC03D1C1
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 13:53:48 -0700 (PDT)
Received: from workstation.tuxnet (213-47-165-233.cable.dynamic.surfer.at [213.47.165.233])
        by mail.pqgruber.com (Postfix) with ESMTPSA id 0D0D3C68644;
        Sat, 15 Aug 2020 22:53:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pqgruber.com;
        s=mail; t=1597524822;
        bh=Lua7YyQnw6DCGxCH5phKsnRXx8B6j2fWvfhPW+0mH3k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z3GYENDqlorwLOG4MYXlOEXBnpXu4EnU5+c6wW3dWNdpaTn69fAVfCYU62M7WJlHt
         fXHdVt7NlRWpfW0bCPByL9nmKdv+1fBrd6efirM3SuydLS6s/k6pIWLq13s1/rQGs4
         HtBtcwWT2JPg+gDfrTlq/CGEBULC0+rZk+9vQgFs=
Date:   Sat, 15 Aug 2020 22:53:40 +0200
From:   Clemens Gruber <clemens.gruber@pqgruber.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>, fugang.duan@nxp.com,
        Chris Healy <cphealy@gmail.com>,
        David Miller <davem@davemloft.net>, Dave Karr <dkarr@vyex.com>
Subject: Re: [PATCH net-next v5] net: ethernet: fec: Replace interrupt driven
 MDIO with polled IO
Message-ID: <20200815205340.GA37931@workstation.tuxnet>
References: <20200502152504.154401-1-andrew@lunn.ch>
 <20200815165556.GA503896@workstation.tuxnet>
 <20200815175349.GG2239279@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200815175349.GG2239279@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Sat, Aug 15, 2020 at 07:53:49PM +0200, Andrew Lunn wrote:
> On Sat, Aug 15, 2020 at 06:55:56PM +0200, Clemens Gruber wrote:
> > Hi,
> > 
> > this patch / commit f166f890c8 ("net: ethernet: fec: Replace interrupt
> > driven MDIO with polled IO") broke networking on i.MX6Q boards with
> > Marvell 88E1510 PHYs (Copper / 1000Base-T).
> 
> Hi Clemens
> 
> Please could you try:
> 
> https://www.spinics.net/lists/netdev/msg675568.html
> 
> 	Andrew

Thanks, this fixes it! I'll send a Tested-by in reply to the patch.

Clemens
