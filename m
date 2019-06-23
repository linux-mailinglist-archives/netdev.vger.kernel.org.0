Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86B5A4FCAA
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 18:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfFWQZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 12:25:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50732 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726399AbfFWQZk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Jun 2019 12:25:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XZ/GPA7RwKAfiLy3VA2nmHd53YUrhTSDvoSWRxFK6EM=; b=MBbPZ1QGpVPBb44qTFdHWfilNL
        AjxrTLIS8pp9u/jQG7xsJlwLLxbfIA/HJrgu5BKr0rMJdQotm+g58RpLIHmKO1wp32PslMxeY6NQd
        ZMWp2LuOsPJ5Ryubp8nvfX/fJBPT0LR05n42ha1axTtKK3h0ZwxQaUMb9tEWJEzDO58g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hf5JB-0000BW-J3; Sun, 23 Jun 2019 18:25:37 +0200
Date:   Sun, 23 Jun 2019 18:25:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vadim Pasternak <vadimp@mellanox.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, mlxsw <mlxsw@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 3/3] mlxsw: core: Add support for negative
 temperature readout
Message-ID: <20190623162537.GF28942@lunn.ch>
References: <20190623125645.2663-1-idosch@idosch.org>
 <20190623125645.2663-4-idosch@idosch.org>
 <20190623154407.GE28942@lunn.ch>
 <AM6PR05MB5224C6BC97D0F90391DA9B0FA2E10@AM6PR05MB5224.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR05MB5224C6BC97D0F90391DA9B0FA2E10@AM6PR05MB5224.eurprd05.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Why the > 0?
> 
> We don't consider negative temperature for thermal control.

Is this because the thermal control is also broken and does not
support negative values? This is just a workaround papering over the
cracks?

I've worked on some systems where the thermal subsystem has controller
a heater. Mostly industrial systems, extended temperature range, and
you have to make sure the hardware is kept above -25C, otherwise the
DRAM timing goes to pot and the system crashed and froze.

	Andrew
