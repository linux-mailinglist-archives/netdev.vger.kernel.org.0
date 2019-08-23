Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEC29A507
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 03:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387856AbfHWBlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 21:41:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53672 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732065AbfHWBlY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 21:41:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Hs7E5/q9Cr9u/812ynmQVJ3R5g/ezphQPBjudmuTONs=; b=xvkZSZ1xsIRzHTJejitc26roh0
        Ks06N7zMfWOtqXW/2DOkDQ2asDdrwX45TZ+y3eMoo74u1xnh7AiJ7ZoqncF7S7LrYBXLqYWnPSbco
        exfbQbEUA7/0US5EVW1HbRoS7ahZKCMlvLTLMU1cv/rg9j2w0H2WV18IhSIzxVmsI0w4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i0yZv-00017h-08; Fri, 23 Aug 2019 03:41:23 +0200
Date:   Fri, 23 Aug 2019 03:41:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next 07/10] net: dsa: mv88e6xxx: rename port cmode
 macro
Message-ID: <20190823014122.GN13020@lunn.ch>
References: <20190821232724.1544-1-marek.behun@nic.cz>
 <20190821232724.1544-8-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190821232724.1544-8-marek.behun@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 01:27:21AM +0200, Marek Behún wrote:
> This is a cosmetic update. We are removing the last underscore from
> macros MV88E6XXX_PORT_STS_CMODE_100BASE_X and
> MV88E6XXX_PORT_STS_CMODE_1000BASE_X. The 2500base-x version does not
> have that underscore. Also PHY_INTERFACE_MODE_ macros do not have it
> there.
> 
> Signed-off-by: Marek Behún <marek.behun@nic.cz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
