Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2171299F5
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 16:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404133AbfEXOUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 10:20:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56062 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403917AbfEXOUG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 10:20:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cuRwu6AvJsEFKF1ZtaoQXhNO4jkyXgQbiE5pb75uGKc=; b=pnNQAx4LNKQkRAThxt3AZXJ/wJ
        Tk0EC+kygzFEnpoSWyEzzgSLLzgBLD1F8TfN3tAe94cXcke+iY9Wd5BMCrFIesFeNLa9m72Zpb53N
        AI4qcUJbmleN1BlKLGE4xn4me6+OxJyr1Q5fmuGOmzs5niC/axcrNQsbYSLwN5hcpuYg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hUB3A-0001Xs-CU; Fri, 24 May 2019 16:20:00 +0200
Date:   Fri, 24 May 2019 16:20:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/5] net: dsa: mv88e6xxx: implement watchdog_ops for
 mv88e6250
Message-ID: <20190524142000.GK2979@lunn.ch>
References: <20190501193126.19196-1-rasmus.villemoes@prevas.dk>
 <20190524085921.11108-1-rasmus.villemoes@prevas.dk>
 <20190524085921.11108-5-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524085921.11108-5-rasmus.villemoes@prevas.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 09:00:29AM +0000, Rasmus Villemoes wrote:
> The MV88E6352_G2_WDOG_CTL_* bits almost, but not quite, describe the
> watchdog control register on the mv88e6250. Among those actually
> referenced in the code, only QC_ENABLE differs (bit 6 rather than bit
> 5).

Marvell hardware engineers do like to keep software engineers busy :-(

> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
