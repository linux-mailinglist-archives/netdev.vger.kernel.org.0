Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB40FA965E
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 00:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730539AbfIDW0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 18:26:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38702 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbfIDW0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 18:26:49 -0400
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8271615286006;
        Wed,  4 Sep 2019 15:26:48 -0700 (PDT)
Date:   Wed, 04 Sep 2019 15:26:46 -0700 (PDT)
Message-Id: <20190904.152646.1973211125417119901.davem@davemloft.net>
To:     hayeswang@realtek.com
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] r8152: modify rtl8152_set_speed function
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-326-Taiwan-albertk@realtek.com>
References: <1394712342-15778-326-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Sep 2019 15:26:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Mon, 2 Sep 2019 19:52:28 +0800

> First, for AUTONEG_DISABLE, we only need to modify MII_BMCR.
> 
> Second, add advertising parameter for rtl8152_set_speed(). Add
> RTL_ADVERTISED_xxx for advertising parameter of rtl8152_set_speed().
> Then, the advertising settings from ethtool could be saved.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied.
