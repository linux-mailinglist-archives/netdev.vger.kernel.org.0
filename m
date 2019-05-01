Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE6B410E06
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 22:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbfEAU3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 16:29:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51505 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbfEAU3F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 16:29:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OX6sjbOWFLnIxaPa8t5912cAm1U32qUA0QoGbsbAcHo=; b=HuQyza/sC87VffW8Ph6TREaVuV
        tjJWjHh1O/uJt+O3jmx5+wUO6lSjS/Yzmvti8L0LbQGmAGWnUmTws2oawBgL+MajXaalOgTA+6nNr
        96QUs+uzrB2w1nmVib21Q7GEmrbkgj6jxf7JrRmcBJOGApUQoWecXjUjXqKkv8ChMb+M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hLvqf-0008LN-3A; Wed, 01 May 2019 22:29:01 +0200
Date:   Wed, 1 May 2019 22:29:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>
Subject: Re: [RFC PATCH 5/5] net: dsa: add support for mv88e6250
Message-ID: <20190501202901.GF19809@lunn.ch>
References: <20190501193126.19196-1-rasmus.villemoes@prevas.dk>
 <20190501193126.19196-6-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190501193126.19196-6-rasmus.villemoes@prevas.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +++ b/drivers/net/dsa/mv88e6xxx/global1.c
> @@ -205,6 +205,26 @@ int mv88e6352_g1_reset(struct mv88e6xxx_chip *chip)
>  	return mv88e6352_g1_wait_ppu_polling(chip);
>  }
>  
> +/* copy of mv88e6352_g1_reset, without tailcall of mv88e6352_g1_wait_ppu_polling. */

Nit:

No need to have this comment. 

Otherwise 

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
