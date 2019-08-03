Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09CCF803A9
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 03:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388638AbfHCBPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 21:15:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53082 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387926AbfHCBPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 21:15:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BF93212B88C08;
        Fri,  2 Aug 2019 18:15:19 -0700 (PDT)
Date:   Fri, 02 Aug 2019 18:15:19 -0700 (PDT)
Message-Id: <20190802.181519.236187362730601447.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, netdev@vger.kernel.org,
        liuyonglong@huawei.com
Subject: Re: [PATCH net] net: phy: fix race in genphy_update_link
From:   David Miller <davem@davemloft.net>
In-Reply-To: <19122a98-cfcd-424c-a598-e034c1a9349d@gmail.com>
References: <19122a98-cfcd-424c-a598-e034c1a9349d@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 02 Aug 2019 18:15:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Wed, 31 Jul 2019 23:05:10 +0200

> In phy_start_aneg() autoneg is started, and immediately after that
> link and autoneg status are read. As reported in [0] it can happen that
> at time of this read the PHY has reset the "aneg complete" bit but not
> yet the "link up" bit, what can result in a false link-up detection.
> To fix this don't report link as up if we're in aneg mode and PHY
> doesn't signal "aneg complete".
> 
> [0] https://marc.info/?t=156413509900003&r=1&w=2
> 
> Fixes: 4950c2ba49cc ("net: phy: fix autoneg mismatch case in genphy_read_status")
> Reported-by: liuyonglong <liuyonglong@huawei.com>
> Tested-by: liuyonglong <liuyonglong@huawei.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
