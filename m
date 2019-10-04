Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0FB2CBB8E
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 15:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388438AbfJDNV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 09:21:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60920 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388425AbfJDNV3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 09:21:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FSljuVvOyZQEdrxkiqLJP+0zKFRwTQyNmQdQMYJLOEY=; b=KZONWqPp6kaz9Rdpmql2kOf8mN
        Xqhg/8ODaiBq9/buSkTzUQP4j4kS8WuWGTjltMuvJ7efCOA9gkBaIetZ8UjjaekEGargBVwMSpo/x
        lM5At60zlKJkrl+zoWborr8I7rkSMrC1M/oe/0sSHyJGjMncK8o8EmgirVdYHoIJr1kI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iGNWP-00019z-B6; Fri, 04 Oct 2019 15:21:25 +0200
Date:   Fri, 4 Oct 2019 15:21:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, mlxsw@mellanox.com
Subject: Re: [patch net-next] net: devlink: don't ignore errors during dumpit
Message-ID: <20191004132125.GD3817@lunn.ch>
References: <20191004095012.1287-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004095012.1287-1-jiri@resnulli.us>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 04, 2019 at 11:50:12AM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Currently, some dumpit function may end-up with error which is not
> -EMSGSIZE and this error is silently ignored. Use does not have clue
> that something wrong happened. Instead of silent ignore, propagate
> the error to user.
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Thanks Jiri

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
