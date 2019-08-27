Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2A209EA22
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 15:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbfH0NxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 09:53:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34546 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbfH0NxA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 09:53:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RSZNT4ssH1KSyi6q+em3w02tElqkWq3YebMLf+p5fSE=; b=BwTqcUAPFd1rp8JmacvViM+vcG
        u26p80dgsNJeOr3iDlT4zQYvq3DJDcSoe9D11aYY+WAR8rjpyGojOgnbpsPkjpNZmyuqlRNYuDtdF
        n1GK/7B+ya/f6TsT8EfyuFOskOBZzil09yn7qba5VmeN5F5XDrVQhTy+vZivtNiyvl8Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i2bu5-0003c3-UH; Tue, 27 Aug 2019 15:52:57 +0200
Date:   Tue, 27 Aug 2019 15:52:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v5 3/6] net: dsa: mv88e6xxx: create
 serdes_get_lane chip operation
Message-ID: <20190827135257.GL2168@lunn.ch>
References: <20190826213155.14685-1-marek.behun@nic.cz>
 <20190826213155.14685-4-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190826213155.14685-4-marek.behun@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 26, 2019 at 11:31:52PM +0200, Marek Behún wrote:
> Create a serdes_get_lane() method in the mv88e6xxx operations structure.
> Use it instead of calling the different implementations.
> Also change the methods so that their return value is used only for
> error. The lane number is put into a place referred to by a pointer
> given as argument. If the port does not have a lane, return -ENODEV.
> Lanes are phy addresses, so use u8 as their type.
> 
> Signed-off-by: Marek Behún <marek.behun@nic.cz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
