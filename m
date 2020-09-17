Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3274726E980
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 01:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgIQXgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 19:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgIQXgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 19:36:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F04FC06174A;
        Thu, 17 Sep 2020 16:36:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6797C1366095C;
        Thu, 17 Sep 2020 16:19:21 -0700 (PDT)
Date:   Thu, 17 Sep 2020 16:36:07 -0700 (PDT)
Message-Id: <20200917.163607.1696404429705845498.davem@davemloft.net>
To:     vadym.kochan@plvision.eu
Cc:     kuba@kernel.org, jiri@mellanox.com, idosch@mellanox.com,
        andrew@lunn.ch, oleksandr.mazur@plvision.eu,
        serhiy.boiko@plvision.eu, serhiy.pshyk@plvision.eu,
        volodymyr.mytnyk@plvision.eu, taras.chornyi@plvision.eu,
        andrii.savka@plvision.eu, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        mickeyr@marvell.com
Subject: Re: [PATCH net-next v9 0/6] net: marvell: prestera: Add Switchdev
 driver for Prestera family ASIC device 98DX3255 (AC3x)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200916163102.3408-1-vadym.kochan@plvision.eu>
References: <20200916163102.3408-1-vadym.kochan@plvision.eu>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 17 Sep 2020 16:19:22 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vadym.kochan@plvision.eu>
Date: Wed, 16 Sep 2020 19:30:56 +0300

> Marvell Prestera 98DX3255 integrates up to 24 ports of 1GbE with 8
> ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
> wireless SMB deployment.
> 
> Prestera Switchdev is a firmware based driver that operates via PCI bus.  The
> current implementation supports only boards designed for the Marvell Switchdev
> solution and requires special firmware.
> 
> This driver implementation includes only L1, basic L2 support, and RX/TX.
 ...

Series applied, thank you.
