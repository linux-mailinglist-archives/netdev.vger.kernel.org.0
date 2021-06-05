Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5A139CAEE
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 22:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhFEUho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 16:37:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47346 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229998AbhFEUhn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Jun 2021 16:37:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=s6VRfGv/EuqyVSr/BR5QORHIP+Z5rOUtImUIEBpCkmw=; b=AUadwMigdmmYnX9aSAofmV4nUf
        SPaW0N29Zj997jD9ohfKKYYvB4c0raiA2vOMrdmaj+K1OAdhFtqmHLcCDfYpgKAFJu/6EAQSg5ePN
        6yg07x9dF4xJctKnpBU0QIPS1rFiqGHNhL+1ebw/KOBfvn3g8ihUQksmoAC/iVUIdYa4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lpd1H-007xPN-Ak; Sat, 05 Jun 2021 22:35:47 +0200
Date:   Sat, 5 Jun 2021 22:35:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Matthew Hagan <mnhagan88@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next] net: dsa: tag_qca: Check for upstream VLAN
 tag
Message-ID: <YLvgI1e3tdb+9SQC@lunn.ch>
References: <20210605193749.730836-1-mnhagan88@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210605193749.730836-1-mnhagan88@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The tested case is a Meraki MX65 which features two QCA8337 switches with
> their CPU ports attached to a BCM58625 switch ports 4 and 5 respectively.

Hi Matthew

The BCM58625 switch is also running DSA? What does you device tree
look like? I know Florian has used two broadcom switches in cascade
and did not have problems.

    Andrew
