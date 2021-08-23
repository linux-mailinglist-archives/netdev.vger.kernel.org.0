Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6093F4B7D
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 15:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236646AbhHWNOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 09:14:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36714 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235813AbhHWNOG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 09:14:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=uB0G9ZImc8Pdu1OVro8WDnme5TohgKEu1Eb5sDQCZk4=; b=fbwCpv5jAwZxPBTTS5/T5y1/D0
        YYF6rBKheBtZTLG+QOh6KsBZtHiR3bKAowxwTmZ+6semZ2tWzSpLeITj9oipZtwosu51Cj5af0OK1
        L0tqpKNcHZKmRn6PWdmDsmoMtsCPkTTr1SyuPNRVZSoHpc3CpQdpkIrqz3vCgfdDW0O0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mI9lO-003T5Z-6C; Mon, 23 Aug 2021 15:13:18 +0200
Date:   Mon, 23 Aug 2021 15:13:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 4/5] net: dsa: realtek-smi: add rtl8365mb
 subdriver for RTL8365MB-VC
Message-ID: <YSOe7nSC9me8dcCf@lunn.ch>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
 <20210822193145.1312668-5-alvin@pqrs.dk>
 <20210822224805.p4ifpynog2jvx3il@skbuf>
 <dd2947d5-977d-b150-848e-fb9a20c16668@bang-olufsen.dk>
 <20210823001953.rsss4fvnvkcqtebj@skbuf>
 <75d2820b-9429-5145-c02d-9c5ce8ceb78f@bang-olufsen.dk>
 <20210823021213.tqnnjdquxywhaprq@skbuf>
 <4928f92c-ed7d-9474-8b6b-21a4baa3a610@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4928f92c-ed7d-9474-8b6b-21a4baa3a610@bang-olufsen.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I tested your patch with some small modifications to make it apply (I'm 
> running 5.14-rc5 right now and it's not so trivial to bump right now - 
> let me know if you think it's important).

Patches submitted to netdev should be against net-next. Before you
submit a version which gets merged, you need to update. Please mark
all submissions until then as RFC in the Subject line.

    Andrew
