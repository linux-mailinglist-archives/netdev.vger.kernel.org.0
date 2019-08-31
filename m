Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB900A4601
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 21:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbfHaTmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 15:42:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46554 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726705AbfHaTmS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Aug 2019 15:42:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=v2ggbygz3WEVv5vP4LbXnaNagw4Q4md4pcMHXR0s6P4=; b=QwGuLaNjviGrxuFUXH+1bNJ6i6
        tCEx6hKIrKIy0WyBKmzphOrx1hPRkxY/3QvC0RZlIO3ggoLRvG7k1Z84733fAWl1v4Kt9bzQWPrD0
        lRGO4/8yjfc0jPiGb7Ry8DA3jDDP6IXvx82ZUKGgVXBBIOKQU+ll/uq31KKpXaS5siYk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i49G0-0001CY-V1; Sat, 31 Aug 2019 21:41:56 +0200
Date:   Sat, 31 Aug 2019 21:41:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        vedang.patel@intel.com, Richard Cochran <richardcochran@gmail.com>,
        weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        xiyou.wangcong@gmail.com, netdev <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH v2 net-next 00/15] tc-taprio offload for SJA1105 DSA
Message-ID: <20190831194156.GC2647@lunn.ch>
References: <20190830004635.24863-1-olteanv@gmail.com>
 <20190829182132.43001706@cakuba.netronome.com>
 <CA+h21hr==OStFfgaswzU7HtFg_bHZPoZD5JTQD+-e4jWwZYWHQ@mail.gmail.com>
 <20190830152839.0fe34d25@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830152839.0fe34d25@cakuba.netronome.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I'm not 100% sure how taprio handles locking TBH, it just seems naive
> that HW callback will not need to sleep, so the kernel should make sure
> that callback can sleep. Otherwise we'll end up with 3/4 of drivers
> implementing some async work routine...

Hi Jakub

I suspect this is because until recently, all such devices were on a
PCI bus, for some other form of memory mapped device. It is only
recently with DSA becoming popular, that we need to handle devices on
the end of other sorts of bus, be is MDIO, SPI or i2c.

    Andrew
