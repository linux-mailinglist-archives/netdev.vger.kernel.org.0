Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF5221C6B7
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 01:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgGKX3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 19:29:50 -0400
Received: from mail.nic.cz ([217.31.204.67]:52366 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727021AbgGKX3u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jul 2020 19:29:50 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id F1DE413FD43;
        Sun, 12 Jul 2020 01:29:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1594510185; bh=lWztn9N9uyo26F9grBTtPFMtC0wTtyu9Lz/iHKpqtCY=;
        h=Date:From:To;
        b=BV2Q3Xkrbf08ikHAwKh+yErI/vGFIaqhCALz/y+iiW+Ep9lb/kWKuLDtfjGas+1bO
         whWqH7BS2rktwV6RCbV42W80SfWMZ06TXSai4OJwIvBXz3L+ypoJgvo23D7264uS5V
         aoxdm9bFbbv9CEiOfBTJ6YhVzLoQgnNAWchT+i6Y=
Date:   Sun, 12 Jul 2020 01:29:44 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Chris Healy <cphealy@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>
Subject: Re: [PATCH net-next 1/2] net: dsa: mv88e6xxx: Implement MTU change
Message-ID: <20200712012944.1541b078@nic.cz>
In-Reply-To: <20200711203206.1110108-2-andrew@lunn.ch>
References: <20200711203206.1110108-1-andrew@lunn.ch>
        <20200711203206.1110108-2-andrew@lunn.ch>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WHITELIST shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 11 Jul 2020 22:32:05 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> The Marvell Switches support jumbo packages. So implement the
> callbacks needed for changing the MTU.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Hi Andrew,

maybe this could be sent to net, not only net-next. Or maybe even
better, with a Fixes tag to some commit - DSA now prints warnings on
some systems when initializing switch interfaces, that MTU cannot be
changed, so maybe we could look at this patch as a fix and get it
backported...

Marek
