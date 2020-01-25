Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEE7914969A
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 17:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgAYQYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 11:24:01 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54168 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbgAYQYA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 11:24:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jex0E8D9r9+e+6DUpspkCaHnqqzSIrlNGW9e5du01CQ=; b=5giQsy/uLoYYaRrT93K3SefnaL
        2ak6pJiZ13B/nntmKOnGnbQfkxKTSf9olPDjlx05uT//8td9XJDWtGN3XTmauMwXFzJ5z6IsqUADK
        oqCIIOr6kmP05O/UmYqYXlLRO6NItWLs29ASGQKqrvCpGoaH4trZVee1a+ygw/kfIR2I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ivOE1-00076k-75; Sat, 25 Jan 2020 17:23:57 +0100
Date:   Sat, 25 Jan 2020 17:23:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, jiri@resnulli.us,
        ivecera@redhat.com, davem@davemloft.net, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, anirudh.venkataramanan@intel.com,
        olteanv@gmail.com, jeffrey.t.kirsher@intel.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [RFC net-next v3 00/10]  net: bridge: mrp: Add support for Media
 Redundancy Protocol (MRP)
Message-ID: <20200125162357.GE18311@lunn.ch>
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
 <20200124203406.2ci7w3w6zzj6yibz@lx-anielsen.microsemi.net>
 <87zhecimza.fsf@linux.intel.com>
 <20200125094441.kgbw7rdkuleqn23a@lx-anielsen.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200125094441.kgbw7rdkuleqn23a@lx-anielsen.microsemi.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Lets say that the link between H1 and H2 goes down:
> 
>     +------------------------------------------+
>     |                                          |
>     +-->|H1|<---  / --->|H2|<---------->|H3|<--+
>     eth0    eth1    eth0    eth1    eth0    eth1
> 
> H1 will now observe that the test packets it sends on eth1, is not
> received in eth0, meaninf that the ring is open

Hi Allan

Is H1 the only device sending test packets? It is assumed that H2 and
H3 will forward them? Or does each device send test packets, and when
it stops hearing these packets from a neighbour, it assumes the link
is open?

   Andrew
