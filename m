Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA59B191D99
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 00:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgCXXgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 19:36:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37964 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbgCXXgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 19:36:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 78531159F5F6C;
        Tue, 24 Mar 2020 16:36:52 -0700 (PDT)
Date:   Tue, 24 Mar 2020 16:36:51 -0700 (PDT)
Message-Id: <20200324.163651.1067037521170220223.davem@davemloft.net>
To:     antoine.tenart@bootlin.com
Cc:     andrew@lunn.ch, olteanv@gmail.com, netdev@vger.kernel.org,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: [PATCH net-next] net: phy: mscc: consolidate a common RGMII
 delay implementation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <158506137648.157373.6196697912192436523@kwain>
References: <20200324141358.4341-1-olteanv@gmail.com>
        <20200324141829.GB14512@lunn.ch>
        <158506137648.157373.6196697912192436523@kwain>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Mar 2020 16:36:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>
Date: Tue, 24 Mar 2020 15:49:37 +0100

> Hi Vladimir,
> 
> Quoting Andrew Lunn (2020-03-24 15:18:29)
>> On Tue, Mar 24, 2020 at 04:13:58PM +0200, Vladimir Oltean wrote:
>> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
>> > 
>> > It looks like the VSC8584 PHY driver is rolling its own RGMII delay
>> > configuration code, despite the fact that the logic is mostly the same.
>> > 
>> > In fact only the register layout and position for the RGMII controls has
>> > changed. So we need to adapt and parameterize the PHY-dependent bit
>> > fields when calling the new generic function.
>> > 
>> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>> 
>> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> Tested-by: Antoine Tenart <antoine.tenart@bootlin.com>

Applied, thanks everyone.
