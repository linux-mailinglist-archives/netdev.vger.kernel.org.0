Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3B34A0E1F
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 01:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfH1XRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 19:17:18 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38638 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbfH1XRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 19:17:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E1751153B3162;
        Wed, 28 Aug 2019 16:17:14 -0700 (PDT)
Date:   Wed, 28 Aug 2019 16:17:13 -0700 (PDT)
Message-Id: <20190828.161713.1379723336745594139.davem@davemloft.net>
To:     shenjian15@huawei.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        sergei.shtylyov@cogentembedded.com, netdev@vger.kernel.org,
        forest.zhouchang@huawei.com, linuxarm@huawei.com
Subject: Re: [PATCH net-next] net: phy: force phy suspend when calling
 phy_stop
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566956087-37096-1-git-send-email-shenjian15@huawei.com>
References: <1566956087-37096-1-git-send-email-shenjian15@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 28 Aug 2019 16:17:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>
Date: Wed, 28 Aug 2019 09:34:47 +0800

> Some ethernet drivers may call phy_start() and phy_stop() from
> ndo_open() and ndo_close() respectively.
> 
> When network cable is unconnected, and operate like below:
> step 1: ifconfig ethX up -> ndo_open -> phy_start ->start
> autoneg, and phy is no link.
> step 2: ifconfig ethX down -> ndo_close -> phy_stop -> just stop
> phy state machine.
> 
> This patch forces phy suspend even phydev->link is off.
> 
> Signed-off-by: Jian Shen <shenjian15@huawei.com>

Applied.
