Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 984891211BE
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfLPR0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:26:42 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55788 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbfLPR0m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:26:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LVckM27X4WE9CsOvq3vdvP2uiOX71Hj2026af52Rr7g=; b=BWH6k43vtvDb0pRqKuJh8Jlwze
        JNujQaXAW4/v8A/Il6cgVUAOqJrkTAHmx1SD+0iyygvju51jsaR6aLuAUiu7ub1LyEtmmRLzys1ct
        1S4EVkRm+zIMyo9N495UVAR+WcDkuRVlCViQlj0oqcJavQvQpXZXLe5oV7uKn42jwa+s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1igu8h-0007M0-1k; Mon, 16 Dec 2019 18:26:35 +0100
Date:   Mon, 16 Dec 2019 18:26:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] net: ag71xx: fix compile warnings
Message-ID: <20191216172635.GA27901@lunn.ch>
References: <20191216064407.32310-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216064407.32310-1-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 07:44:07AM +0100, Oleksij Rempel wrote:
> drivers/net/ethernet/atheros/ag71xx.c: In function 'ag71xx_probe':
> drivers/net/ethernet/atheros/ag71xx.c:1776:30: warning: passing argument 2 of
>  'of_get_phy_mode' makes pointer from integer without a cast [-Wint-conversion]
> In file included from drivers/net/ethernet/atheros/ag71xx.c:33:
> ./include/linux/of_net.h:15:69: note: expected 'phy_interface_t *'
>  {aka 'enum <anonymous> *'} but argument is of type 'int'
> 
> Fixes: 0c65b2b90d13c1 ("net: of_get_phy_mode: Change API to solve int/unit warnings")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
