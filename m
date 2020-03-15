Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D402D185A00
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 05:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgCOEHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 00:07:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35310 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbgCOEHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 00:07:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 73A7615B75337;
        Sat, 14 Mar 2020 21:07:10 -0700 (PDT)
Date:   Sat, 14 Mar 2020 21:07:09 -0700 (PDT)
Message-Id: <20200314.210709.1134027873876631073.davem@davemloft.net>
To:     antoine.tenart@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/3] net: phy: split the mscc driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200313094802.82863-1-antoine.tenart@bootlin.com>
References: <20200313094802.82863-1-antoine.tenart@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 14 Mar 2020 21:07:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>
Date: Fri, 13 Mar 2020 10:47:59 +0100

> This is a proposal to split the MSCC PHY driver, as its code base grew a
> lot lately (it's already 3800+ lines). It also supports features
> requiring a lot of code (MACsec), which would gain in being split from
> the driver core, for readability and maintenance. This is also done as
> other features should be coming later, which will also need lots of code
> addition.
> 
> This series shouldn't change the way the driver works.
> 
> I checked, and there were no patch pending on this driver. This change
> was done on top of all the modifications done on this driver in net-next.
 ...

Series applied, thanks Antoine.
