Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A82DD33354
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 17:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729288AbfFCPSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 11:18:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50812 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729004AbfFCPSa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 11:18:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Vh5a4ISZEsQ9Fd8PZTXajuiHikELcBhlSsgS/rwvXuM=; b=z4Dzl2dQans0Sh5JEIA0m+Dysi
        S3XzPiT/kr8LbMSaT2NCZSNLqh+8cQ70rG8rxoTZrAU6FQNqJaeYKbLPE/3YzJYKwypyocTziSuH+
        b0Ppl96PHBDNug0U0HV4EkzLF6xJWsH19BAHoow0A/o0YRPVaRmMioB3V+mj62XVlm/o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hXoj9-00067g-UM; Mon, 03 Jun 2019 17:18:23 +0200
Date:   Mon, 3 Jun 2019 17:18:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 10/10] net: dsa: mv88e6xxx: refactor
 mv88e6352_g1_reset
Message-ID: <20190603151823.GI19627@lunn.ch>
References: <20190603144112.27713-1-rasmus.villemoes@prevas.dk>
 <20190603144112.27713-11-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603144112.27713-11-rasmus.villemoes@prevas.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 02:42:24PM +0000, Rasmus Villemoes wrote:
> The new mv88e6250_g1_reset() is identical to mv88e6352_g1_reset() except
> for the call of mv88e6352_g1_wait_ppu_polling(), so refactor the 6352
> version in term of the 6250 one. No functional change.
> 
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
