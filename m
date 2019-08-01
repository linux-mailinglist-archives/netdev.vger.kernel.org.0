Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC607D3FE
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 05:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730473AbfHADqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 23:46:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52784 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730413AbfHADp6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 23:45:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FTPM3csely9s2zFjlouoeuv0HtNJCvzMK22CfSdrkWk=; b=WGw5Zol78L39eiMcggNoSq52xq
        ZCM69o62mAwiMmFqlWkIFlcWAoiYE2oeCfFit/7OS821z0Mz2Y9Ccp7Cd+2prQI7CEOYluus/kEBY
        9QFJmmh1i+j0Q4cOk7MaH8Ef5ljXAld4nY0GBai1qVi+xa8r3u2mle2nSRu5VFJlhdPc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1ht22N-0001Eg-EG; Thu, 01 Aug 2019 05:45:55 +0200
Date:   Thu, 1 Aug 2019 05:45:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hubert Feurstein <h.feurstein@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH net-next v2 3/6] net: dsa: mv88e6xxx: introduce
 invalid_port_mask in mv88e6xxx_info
Message-ID: <20190801034555.GD2713@lunn.ch>
References: <20190731082351.3157-1-h.feurstein@gmail.com>
 <20190731082351.3157-4-h.feurstein@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731082351.3157-4-h.feurstein@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 10:23:48AM +0200, Hubert Feurstein wrote:
> With this it is possible to mark certain chip ports as invalid. This is
> required for example for the MV88E6220 (which is in general a MV88E6250
> with 7 ports) but the ports 2-4 are not routed to pins.
> 
> If a user configures an invalid port, an error is returned.
> 
> Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
