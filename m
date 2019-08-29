Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2807EA21D0
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 19:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbfH2RIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 13:08:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41350 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726661AbfH2RIg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 13:08:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BG+TteF3BNdDixThdCWh0e84gFtpCc8U280vCsiZxjs=; b=cJeFIw8q4ywlzgu769gAGHc68A
        DiExL5XrVnpxA6Aqe1q18p/5NOKA1hsu+7HW2lSs2eDBniF0UUju98/H9hv6lh/Xta1/tASvPlNyK
        HMuA3hWdlI/Q44QuRWTEL8kNrb41keJQhb1t6LDYwvbXX+XC9uwwgFKntHQFJNO2q8zI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i3NuS-0004Ep-Rb; Thu, 29 Aug 2019 19:08:32 +0200
Date:   Thu, 29 Aug 2019 19:08:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>,
        f.fainelli@gmail.com
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: fix freeing unused SERDES
 IRQ
Message-ID: <20190829170832.GA12909@lunn.ch>
References: <20190828185511.21956-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828185511.21956-1-vivien.didelot@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 28, 2019 at 02:55:11PM -0400, Vivien Didelot wrote:
> Now mv88e6xxx does not enable its ports at setup itself and let
> the DSA core handle this, unused ports are disabled without being
> powered on first. While that is expected, the SERDES powering code
> was assuming that a port was already set up before powering it down,
> resulting in freeing an unused IRQ. The patch fixes this assumption.
> 
> Fixes: b759f528ca3d ("net: dsa: mv88e6xxx: enable SERDES after setup")
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Tested-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
