Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AED5409856
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 18:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345386AbhIMQHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 12:07:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38538 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345105AbhIMQG7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 12:06:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Y3CutjqpVzP5bmoUsnSMZT0IF7u1ISyLxxml45vCJ3E=; b=zA+iPaRwArImutBwRkILbq7fyb
        Ey+FmPmXjEV4mjr4xovdMq/CmXjO9VKP7hWl8d76BjlbgZP49A4ujBr1QvT8cqbq79FDSSahPg1al
        /O4hSfeZPGuXBG5Xa1EMtjewXPWAlAPLUihRk8ZF8Qtc+3oWzGQ/IKXUujhg5g19qp3A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mPoSc-006QXW-P0; Mon, 13 Sep 2021 18:05:34 +0200
Date:   Mon, 13 Sep 2021 18:05:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: tag_rtl4_a: Drop bit 9 from egress
 frames
Message-ID: <YT92zg/JcC/2s3Ss@lunn.ch>
References: <20210913143156.1264570-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913143156.1264570-1-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 04:31:56PM +0200, Linus Walleij wrote:
> This drops the code setting bit 9 on egress frames on the
> Realtek "type A" (RTL8366RB) frames.
> 
> This bit was set on ingress frames for unknown reason,
> and was set on egress frames as the format of ingress
> and egress frames was believed to be the same. As that
> assumption turned out to be false, and since this bit
> seems to have zero effect on the behaviour of the switch
> let's drop this bit entirely.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
