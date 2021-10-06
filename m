Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D9A424AC3
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 01:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239905AbhJFX5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 19:57:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53190 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239892AbhJFX5T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 19:57:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kpCOnrQsR1iFKLM2W1z5+2ckaBs41q2dEOXpln1RY5I=; b=fw0OpZ4aOEf0BvyrJ8YBvJM+8+
        s6NwWqwLaGakc/l2H/ZLSA3OXYrX0d8rEge79Num1wTRcaPskcVl/MoXeZ8mUiPCkJoGjntn+Z6VC
        ZDrInHfaMTE5ag+vtdVeHMRuj/seyOk4R6NuDahvQwApRufsIDxGEiSSo48qwd5leQO8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mYGkt-009t8F-2n; Thu, 07 Oct 2021 01:55:23 +0200
Date:   Thu, 7 Oct 2021 01:55:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 03/13] drivers: net: phy: at803x: enable prefer
 master for 83xx internal phy
Message-ID: <YV43a0qLxVDfd7dk@lunn.ch>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
 <20211006223603.18858-4-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006223603.18858-4-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 12:35:53AM +0200, Ansuel Smith wrote:
> >From original QCA source code the port was set to prefer master as port
> type in 1000BASE-T mode. Apply the same settings also here.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
