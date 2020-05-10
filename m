Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B591CCD3F
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 21:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729227AbgEJTRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 15:17:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52446 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729113AbgEJTRy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 15:17:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EJbG54NUlsUD3nT3bry6mm3SSzFFuhWkGzyRY7gOEWc=; b=g/xvlJlu08ELZlzLoIqPXKBqc5
        jHDDHGWTD9xjd43iHHZl2yFfYrOCVe8ZnWZ/DObOORqBUq+FAQoDx4R4oxQtdgbt7BtxfsB590W7+
        CBkSzezSJ6PRzEtPklNgKH8t7wPi7CdRJtKw47YJJ32FgLvW7FLwvzjJdWCi21kyto/I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jXrSS-001jm7-VU; Sun, 10 May 2020 21:17:52 +0200
Date:   Sun, 10 May 2020 21:17:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v4 1/1] net: phy: Send notifier when starting
 the cable test
Message-ID: <20200510191752.GA413878@lunn.ch>
References: <20200510191240.413699-1-andrew@lunn.ch>
 <20200510191240.413699-3-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200510191240.413699-3-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 10, 2020 at 09:12:31PM +0200, Andrew Lunn wrote:
> Given that it takes time to run a cable test, send a notify message at
> the start, as well as when it is completed.

Arg! This patch does not belong in the series!

     Andrew
