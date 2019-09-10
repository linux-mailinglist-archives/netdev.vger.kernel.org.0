Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2D8AF102
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 20:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbfIJS0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 14:26:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38732 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbfIJS0i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 14:26:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=P6YZA4KAw3/xxvCX8Us5I3hzW3nZ3YdqZNDK63LGuU0=; b=CHVcuTqtLWg9QmEcv+dR9hKrij
        xxdZMdhQuFlw+g1e+qNCJgDbUPgEpBvAD9Pp99kAAobAmgBRZ97VISCce+Caw7sxQWW5TjnGu4s19
        PEFOTti0R21YElmwCLjVXIAMbR82YCcdoXwRgnRxo7OOnAprVF95F9TC6dTb3ZtaAZ6E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i7kqZ-0002p1-2y; Tue, 10 Sep 2019 20:26:35 +0200
Date:   Tue, 10 Sep 2019 20:26:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Beckett <bob.beckett@collabora.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/7] net/dsa: configure autoneg for CPU port
Message-ID: <20190910182635.GA9761@lunn.ch>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
 <20190910154238.9155-2-bob.beckett@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190910154238.9155-2-bob.beckett@collabora.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 10, 2019 at 04:41:47PM +0100, Robert Beckett wrote:
> This enables us to negoatiate pause frame transmission to prioritise
> packet delivery over throughput.

I don't think we can unconditionally enable this. It is a big
behaviour change, and it is likely to break running systems. It has
affects on QoS, packet prioritisation, etc.

I think there needs to be a configuration knob. But unfortunately, i
don't know of a good place to put this knob. The switch CPU port is
not visible in any way.

    Andrew
