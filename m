Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54AED193321
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 22:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbgCYVzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 17:55:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57678 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727351AbgCYVzn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 17:55:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MJ1KmnAUu3PrJi6jRYjuOmoElslleBdkOocevj5s+rI=; b=aHi0n5vvYm5/UUhujzJkoqcKq6
        lmvV+XJddmK6NM56tQ3Ds/hExW1RsRKSLZghwoTmpBrfvVJM/GYyX1cOiqlJ2CDLXSDRXnM6jk7k7
        EW6l2ApZhjhSJpTPHtsef/vbHGFJsapgd/AdTy+S5IbnI278HajgVYsrGHqXrYqqQgN4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jHDzu-000879-Bk; Wed, 25 Mar 2020 22:55:38 +0100
Date:   Wed, 25 Mar 2020 22:55:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Marek Vasut <marex@denx.de>,
        o.rempel@pengutronix.de, Florian Fainelli <f.fainelli@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jean Delvare <jdelvare@suse.com>,
        Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: RFC: future of ethtool tunables (Re: [RFC][PATCH 1/2] ethtool:
 Add BroadRReach Master/Slave PHY tunable)
Message-ID: <20200325215538.GB27427@lunn.ch>
References: <20200325101736.2100-1-marex@denx.de>
 <20200325164958.GZ31519@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325164958.GZ31519@unicorn.suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> What might be useful, on the other hand, would be device specific
> tunables: an interface allowing device drivers to define a list of
> tunables and their types for each device. It would be a generalization
> of private flags. There is, of course, the risk that we could end up
> with multiple NIC vendors defining the same parameters, each under
> a different name and with slightly different semantics.
 
Hi Michal

I'm not too happy to let PHY drivers do whatever they want. So far,
all PHY tunables have been generic. Any T1 PHY can implement control
of master/slave, and there is no reason for each PHY to do it
different to any other PHY. Downshift is a generic concept, multiple
PHYs have implemented it, and they all implement it the same. Only
Marvell currently supports fast link down, but the API is generic
enough that other PHYs could implement it, if the hardware supports
it.

I don't however mind if it gets a different name, or a different tool,
etc.

I will let others comment on NICs. They are a different beast.

Andrew



