Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48769AC935
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 22:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395268AbfIGUdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 16:33:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33616 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727307AbfIGUdS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Sep 2019 16:33:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UxlFs9a/64hVyyR1hH+u5fQw95BHm3l5R/86+UJ65y0=; b=pUPhSXKGvwParm6s28xLyMBFAt
        +ke7XLpxUb1aTeoftgcPLigitXujk8JhItOb3oDXWJ+6vTeocFdgBYbYrYu6xZVj/CYBej5i3RuIj
        /ah7zzfvAQLaGegWll0evIJsujrsbI+Y+1uTiPy2OsJXXkrtrXLrcW7wXDnuZuPdTIgM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i6hOX-0005id-Jg; Sat, 07 Sep 2019 22:33:17 +0200
Date:   Sat, 7 Sep 2019 22:33:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com
Subject: Re: [PATCH net-next 2/3] net: dsa: mv88e6xxx: introduce
 .port_set_policy
Message-ID: <20190907203317.GC18741@lunn.ch>
References: <20190907200049.25273-1-vivien.didelot@gmail.com>
 <20190907200049.25273-3-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190907200049.25273-3-vivien.didelot@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 07, 2019 at 04:00:48PM -0400, Vivien Didelot wrote:
> Introduce a new .port_set_policy operation to configure a port's
> Policy Control List, based on mapping such as DA, SA, Etype and so on.
> 
> Models similar to 88E6352 and 88E6390 are supported at the moment.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
