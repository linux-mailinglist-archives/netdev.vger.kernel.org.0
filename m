Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A27EF3E9A22
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 22:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbhHKU6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 16:58:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45842 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229589AbhHKU6O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 16:58:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mPAEsI0fVRuhUaKTy3lDnIb5ywL8Fvk+uCUGYs39isM=; b=jAbarFgvJjBqFrnKQGJBUT/WGL
        7jTxD+yK0HZ7JCW0l2IguDqbEQbjt492ulJB/jxWMP9IagfnqJb7KZpU7+xLqEarwRyQAc3HRdFQq
        CYAa2dcjOGZLQLutmrRLQbeubLytoFhJex+/pfDTCFClQBkxgNSfvkbVSJKJqUTYRB7w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mDvIJ-00HBS2-TG; Wed, 11 Aug 2021 22:57:47 +0200
Date:   Wed, 11 Aug 2021 22:57:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, davem@davemloft.net, mkubecek@suse.cz,
        pali@kernel.org, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 1/8] ethtool: Add ability to control
 transceiver modules' low power mode
Message-ID: <YRQ5y65CVgaPJkdB@lunn.ch>
References: <YRIqOZrrjS0HOppg@shredder>
 <YRKElHYChti9EeHo@lunn.ch>
 <20210810065954.68036568@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRLlpCutXmthqtOg@shredder>
 <20210810150544.3fec5086@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRO1ck4HYWTH+74S@shredder>
 <20210811060343.014724e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRPgXWKZ2e88J1sn@lunn.ch>
 <YRQnEWeQSE22woIr@shredder>
 <20210811133006.1c9aa6db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811133006.1c9aa6db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Isn't the "low-power" attr just duplicating the relevant bits from -m?

Do all SFPs report it in the dump? I'm thinking GPON, 1G modules with
a TX_ENABLE pin? INF-8074 does not specify a bit in the 'EEPROM' data
to indicate the status. So you need to know the state of the GPIO
driving the TX_ENABLE pin.

   Andrew
