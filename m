Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C04940123E
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 02:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238337AbhIFAo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 20:44:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57230 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234077AbhIFAoz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Sep 2021 20:44:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=crtPfXBWJcF92qukyeTt/bN0aJjLBQqWMJVDWKFffok=; b=Bx//b/O9ZKPHqN1t73JvEgj+bs
        VxDS6vzhjHdSiXxK3KzmvRJveNrnBz1sF0YSVmMg3nk9l8lEhCJxYufBrlzk9PtpMVsN1lAUptwnB
        gignVJRO8gAJdIjrgTd9jTzsBo5UJPPRVOyOvZhqA1kWX+AmRT5ZvUOVrVE7UJbh8XgI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mN2jh-005RYW-0F; Mon, 06 Sep 2021 02:43:45 +0200
Date:   Mon, 6 Sep 2021 02:43:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        patchwork-bot+netdevbpf@kernel.org, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, rafal@milecki.pl
Subject: Re: [PATCH] net: dsa: b53: Fix IMP port setup on BCM5301x
Message-ID: <YTVkQGfD9MsHui80@lunn.ch>
References: <20210905172328.26281-1-zajec5@gmail.com>
 <163086540526.12372.2831878860317230975.git-patchwork-notify@kernel.org>
 <5de7487c-4ffe-bca4-f9a3-e437fc63926b@gmail.com>
 <40577a0e-27ce-01c3-2520-ff28885ab031@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40577a0e-27ce-01c3-2520-ff28885ab031@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I was also surprised a bit with that quick apply. I prefer to have my
> code reviewed properly.

A few people are posting with RFC in the subject, to slow down the
merge and give people a chance to actually comment. This is not how it
should be, but that does appear to at least work.

       Andrew
