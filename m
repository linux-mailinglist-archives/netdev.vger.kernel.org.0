Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1A2D122A05
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 12:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbfLQLaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 06:30:14 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57136 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbfLQLaN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 06:30:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=he5l+dqXYGDSxcRQu9vB6nha3gJBzOrvArj+JcXtpFE=; b=kLI0Lc27t6Pzw/leLi2caMVA2m
        o/vWCudS1hv9IHU4SXOSxpCiyaZmOJjvN4hD3pnoF7TwolwxVND/frdcZbIyi6bTwaNEQ871UyR9V
        RoYSMURTxQXei6mu8WhWUzyVq52nUz4syrfK5bYajz2Qn88XC5NGUx8ux2eLMK9KwjI0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ihB3J-0007cs-7u; Tue, 17 Dec 2019 12:30:09 +0100
Date:   Tue, 17 Dec 2019 12:30:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: make unexported dsa_link_touch() static
Message-ID: <20191217113009.GC17965@lunn.ch>
References: <20191217112038.2069386-1-ben.dooks@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217112038.2069386-1-ben.dooks@codethink.co.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 11:20:38AM +0000, Ben Dooks (Codethink) wrote:
> dsa_link_touch() is not exported, or defined outside of the
> file it is in so make it static to avoid the following warning:
> 
> net/dsa/dsa2.c:127:17: warning: symbol 'dsa_link_touch' was not declared. Should it be static?
> 
> Signed-off-by: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>

Fixes: c5f51765a1f6 ("net: dsa: list DSA links in the fabric")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
