Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF5087D3C9
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 05:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbfHADnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 23:43:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52766 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbfHADnb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 23:43:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=b1ZPq4bTVMjHKfhV0Bt+OqxdWOApx20xd731kmQFo+0=; b=vWRRBlbdKb8D5u3c7PHFtD+2hY
        LIrkuFFZB5+VDRfWR81vcvnKll/AaqpgOVYuWhaTApp1ljj6Qx7NN0K7jVYisrhb6YArV/8BlRPzh
        FXNQKGxlPjlK5BZcjeg5Z7FwDY9PG7OTCcz541lstzm8S87dCaLBleudXaMYRhNg1SbI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1ht1zy-0001BX-Va; Thu, 01 Aug 2019 05:43:26 +0200
Date:   Thu, 1 Aug 2019 05:43:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hubert Feurstein <h.feurstein@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH net-next v2 1/6] net: dsa: mv88e6xxx: add support for
 MV88E6220
Message-ID: <20190801034326.GC2713@lunn.ch>
References: <20190731082351.3157-1-h.feurstein@gmail.com>
 <20190731082351.3157-2-h.feurstein@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731082351.3157-2-h.feurstein@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 10:23:46AM +0200, Hubert Feurstein wrote:
> The MV88E6220 is almost the same as MV88E6250 except that the ports 2-4 are
> not routed to pins. So the usable ports are 0, 1, 5 and 6.
> 
> Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
