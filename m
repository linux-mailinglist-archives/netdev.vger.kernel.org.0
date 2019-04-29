Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA875EC4E
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 23:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbfD2VzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 17:55:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49138 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729354AbfD2VzD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 17:55:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=F521CCrtIQW5uRRwyywy4lNDdVu4FKJqviWBVYsKYkc=; b=cZG4FyOSxDvx1kHGh0khoRKzb/
        hbPHR8sa/9kAPvqxz9x+pmNl0TNE9Uk7bDOLbWRWkNayPQIbhoBO9AVnMzreUR0R9zZjCbWUww2dX
        A0LupPac/giDZ4R4YMRxV+MOO+KxOJoii2LOBFYZUAigfci8PgYFs2JFTLUc//NN8ilE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hLEEm-000700-Ur; Mon, 29 Apr 2019 23:55:00 +0200
Date:   Mon, 29 Apr 2019 23:55:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 08/13] net: dsa: Add helper function to retrieve
 VLAN awareness setting
Message-ID: <20190429215500.GH12333@lunn.ch>
References: <20190428184554.9968-1-olteanv@gmail.com>
 <20190428184554.9968-9-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190428184554.9968-9-olteanv@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 28, 2019 at 09:45:49PM +0300, Vladimir Oltean wrote:
> Since different types of hardware may or may not support this setting
> per-port, DSA keeps it either in dsa_switch or in dsa_port.
> 
> While drivers may know the characteristics of their hardware and
> retrieve it from the correct place without the need of helpers, it is
> cumbersone to find out an unambigous answer from generic DSA code.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
