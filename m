Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B28F1D1AFF
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 18:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389598AbgEMQ0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 12:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730831AbgEMQ0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 12:26:39 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904BCC061A0C;
        Wed, 13 May 2020 09:26:39 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id D239322FB6;
        Wed, 13 May 2020 18:26:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1589387197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pYLWAIXiTcx/p4X2M35UO82CgyvVqP6649j5CtXrFBA=;
        b=ILxNwfrBn0AKTJBH4SDIvRyCFExdKuCLrgIYggmK9sl4MBaZQ1s93Jwmy/yzlRL9DUvRO5
        KNCmiXjY1uRHNgmaZADuXp8h+gXSavPl9mol8V6AP6U1oIrfB2LhTbWEgvKTDyWR42w89i
        jGtQ/jddtDOpexByKd4FPPMJaDb3cbw=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 13 May 2020 18:26:37 +0200
From:   Michael Walle <michael@walle.cc>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v1] net: phy: at803x: add cable test support
In-Reply-To: <20200513160026.fdls7kpxb6luuwed@pengutronix.de>
References: <20200513120648.14415-1-o.rempel@pengutronix.de>
 <0c80397b-58b8-0807-0b98-695db8068e25@gmail.com>
 <20200513154544.gwcccvbicpvrj6vm@pengutronix.de>
 <20200513154953.GI499265@lunn.ch>
 <20200513160026.fdls7kpxb6luuwed@pengutronix.de>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <13b7ade2fee2de3dd160588cc323bdfe@walle.cc>
X-Sender: michael@walle.cc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2020-05-13 18:00, schrieb Oleksij Rempel:
> On Wed, May 13, 2020 at 05:49:53PM +0200, Andrew Lunn wrote:
>> > Uff.. i missed this. Then I'll need only to add some changes on top of
>> > his patch.
>> 
>> I've been chatting with mwalle on IRC today. There should be a repost
>> of the patches soon.
> 
> Cool!
> @Michael, please CC me.

sure no problem.

> you can include support for AR9331 and AR8032 in your patch (if you
> like)

I guess merging doesn't take too long for my patch. So better you just 
post
a patch on top of that, before I screw something up.

-michael

> http://www.jhongtech.com/DOWN/ATHEROS--AR8032.pdf
> 
> They have same register, but only 2 pairs.
