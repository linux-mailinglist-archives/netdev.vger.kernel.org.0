Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32D91F4659
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 20:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731965AbgFISa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 14:30:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42070 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730658AbgFISa4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 14:30:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EhV/TVKgV99na7u/JLTSBppnhlsRTgnR+BNUpCAIBHI=; b=gvDExwgFmo/5fyena05I3UXVhT
        im/tmmJZfA4cjS084NK/cIRcpxB+AgBxfN3ZPhkkaxHKqOJGHunR0wGMEEUdtymItcGqSq4XvaZ7/
        ia1J3WS5uUbeB+79FSP17qXtlxKzdqdooczP0XABmtdyckwx+xvMfjGmeZJ3CKfyHXM8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jij18-004XY1-Ca; Tue, 09 Jun 2020 20:30:34 +0200
Date:   Tue, 9 Jun 2020 20:30:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Miller <davem@davemloft.net>, o.rempel@pengutronix.de,
        f.fainelli@gmail.com, hkallweit1@gmail.com, kuba@kernel.org,
        corbet@lwn.net, mkubecek@suse.cz, linville@tuxdriver.com,
        david@protonic.nl, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux@armlinux.org.uk, mkl@pengutronix.de, marex@denx.de,
        christian.herber@nxp.com, amitc@mellanox.com, petrm@mellanox.com
Subject: Re: [PATCH ethtool v1] netlink: add master/slave configuration
 support
Message-ID: <20200609183034.GC1056844@lunn.ch>
References: <20200526091025.25243-1-o.rempel@pengutronix.de>
 <20200607153019.3c8d6650@hermes.lan>
 <20200607.164532.964293508393444353.davem@davemloft.net>
 <20200609101935.5716b3bd@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200609101935.5716b3bd@hermes.lan>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen

> A common example is that master/slave is unclear and would be clearer
> as primary/secondary or active/backup or controller/worker.

802.3, cause 32.1.2, 2015 version:

   A 100BASE-T2 PHY can be configured either as a master PHY or as a
   slave PHY. The master-slave relationship between two stations
   sharing a link segment is established during Auto-Negotiation (see
   Clause 28, 32.5, Annex 28C, and 32.5.2). The master PHY uses an
   external clock to determine the timing of transmitter and receiver
   operations. The slave PHY recovers the clock from the received
   signal and uses it to determine the timing of transmitter
   operations, i.e., it performs loop timing, as illustrated in Figure
   32–2.

In this case, i would say master/slave is very clearly defined.

Given these definitions, would you like to propose alternatives?

Do you have any insights has to how the IEEE 802.3 standard will be
changed?

      Andrew
