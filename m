Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB931CCB8E
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 16:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbgEJOc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 10:32:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51952 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbgEJOc6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 10:32:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=eu36s6VDaVxzp6MDRt8lN13k4I4yUb2/yQepOwTi0HY=; b=r5Sz0LeGjeG6rJOVcjJYgHue21
        WMa1yOjiCrGu+35Xl341t744a4wyHlFhHdIcH8A8VArf2UFH1mpctXoJsizp+bZhR4nQVLivSYlVk
        uqxugSJIUKIfrHhro24ZbN2BmMVu/0jYhXNfSuy4KpP6Ym3xvbXDxWUqhgXOKpwjOA/Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jXn0i-001i7K-Bp; Sun, 10 May 2020 16:32:56 +0200
Date:   Sun, 10 May 2020 16:32:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 1/4] net: phy: broadcom: add exp register access
 methods without buslock
Message-ID: <20200510143256.GG362499@lunn.ch>
References: <20200509223714.30855-1-michael@walle.cc>
 <20200509223714.30855-2-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509223714.30855-2-michael@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 10, 2020 at 12:37:11AM +0200, Michael Walle wrote:
> Add helper to read and write expansion registers without taking the mdio
> lock.
> 
> Please note, that this changes the semantics of the read and write.
> Before there was no lock between selecting the expansion register and
> the actual read/write. This may lead to access failures if there are
> parallel accesses. Instead take the bus lock during the whole access
> cycle.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
