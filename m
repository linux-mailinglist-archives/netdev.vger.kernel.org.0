Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1CAD9A56
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 21:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394558AbfJPTii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 15:38:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49094 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389475AbfJPTii (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 15:38:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zd30SfDASsrlQ1k7qw2efNdIO+JipvFfGiFhBOf9OX4=; b=lWxb0Ue59Ux21FuWm325S/PT0n
        ByNwCeu9gT9JEnfZWuM5NKwNhj2ya/1paGg7B5PM4cVSwWLgFi+/dtVnvD/hEYR8/OPxtJ1n+BRKX
        08w40GJS4Bdxyw8sgpAEZnM+iZ65gNQvVtze774vcnd3yojZQRAn4vXNgYdxKhdOvliU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iKp7u-0000ls-OL; Wed, 16 Oct 2019 21:38:30 +0200
Date:   Wed, 16 Oct 2019 21:38:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>
Subject: Re: [PATCH v2 net-next 10/12] net: aquantia: add support for Phy
 access
Message-ID: <20191016193830.GJ17013@lunn.ch>
References: <cover.1570531332.git.igor.russkikh@aquantia.com>
 <09f7d525783b31730ca3bdbaa52c962a141284a5.1570531332.git.igor.russkikh@aquantia.com>
 <20191015121903.GK19861@lunn.ch>
 <bfd14f97-de5c-feda-49e1-06451bd4ed80@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfd14f97-de5c-feda-49e1-06451bd4ed80@aquantia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Andrew,
> No it can't. This is a monolitic MAC+Phy solution.

O.K, then not using the core infrastructure is O.K.

Thanks
     Andrew
