Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B3D1B525A
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 04:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgDWCXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 22:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgDWCXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 22:23:47 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84DDC03C1AA
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 19:23:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1820F127A4F57;
        Wed, 22 Apr 2020 19:23:47 -0700 (PDT)
Date:   Wed, 22 Apr 2020 19:23:46 -0700 (PDT)
Message-Id: <20200422.192346.785986932807523843.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        o.rempel@pengutronix.de, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net] net: dsa: don't fail to probe if we couldn't
 set the MTU
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200421171853.12572-1-olteanv@gmail.com>
References: <20200421171853.12572-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Apr 2020 19:23:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Tue, 21 Apr 2020 20:18:53 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> There is no reason to fail the probing of the switch if the MTU couldn't
> be configured correctly (either the switch port itself, or the host
> port) for whatever reason. MTU-sized traffic probably won't work, sure,
> but we can still probably limp on and support some form of communication
> anyway, which the users would probably appreciate more.
> 
> Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
> Reported-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied, thanks Vlad.
