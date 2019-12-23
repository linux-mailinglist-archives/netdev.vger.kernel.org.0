Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B923F12933B
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 09:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbfLWIpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 03:45:08 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37844 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725926AbfLWIpI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Dec 2019 03:45:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uECD/WnbinkFvBaF7utqX1qebxGBe2kWJTnjn2zM/c4=; b=2m/Z4EvoLtJTby7jwic0DoEpmP
        iVAXI1psNbzwrTVyXc/AOs+++a9d3ZJbtfzK/BVQvXuy7IzENXAxpWMqqH/BjOtuQtVcsOAnsGXf6
        ikCarapVcz5dHbhvJ9UT526d8x9rDOvaj7QpATd1HBN4JI1zB6ccrYiujVLoDdJmv0MI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ijJKq-00008A-Jt; Mon, 23 Dec 2019 09:45:04 +0100
Date:   Mon, 23 Dec 2019 09:45:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH] mv88e6xxx: Add serdes Rx statistics
Message-ID: <20191223084504.GB32356@lunn.ch>
References: <20191223055324.26396-1-nikita.yoush@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191223055324.26396-1-nikita.yoush@cogentembedded.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 08:53:24AM +0300, Nikita Yushchenko wrote:
> If packet checker is enabled in the serdes, then Rx counter registers
> start working, and no side effects have been detected.
> 
> This patch enables packet checker automatically when powering serdes on,
> and exposes Rx counter registers via ethtool statistics interface.
> 
> Code partially basded by older attempt by Andrew Lunn.
> 
> Signed-off-by: Nikita Yushchenko <nikita.yoush@cogentembedded.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
