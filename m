Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30DDCA0E01
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 01:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfH1XCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 19:02:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38386 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbfH1XCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 19:02:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 55C61153B099D;
        Wed, 28 Aug 2019 16:02:50 -0700 (PDT)
Date:   Wed, 28 Aug 2019 16:02:47 -0700 (PDT)
Message-Id: <20190828.160247.1952943063294295495.davem@davemloft.net>
To:     hayeswang@realtek.com
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3 0/2] r8152: fix side effect
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-320-Taiwan-albertk@realtek.com>
References: <1394712342-15778-314-Taiwan-albertk@realtek.com>
        <1394712342-15778-320-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 28 Aug 2019 16:02:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Wed, 28 Aug 2019 09:51:40 +0800

> v3:
> Update the commit message for patch #1.
> 
> v2:
> Replace patch #2 with "r8152: remove calling netif_napi_del".
> 
> v1:
> The commit 0ee1f4734967 ("r8152: napi hangup fix after disconnect")
> add a check to avoid using napi_disable after netif_napi_del. However,
> the commit ffa9fec30ca0 ("r8152: set RTL8152_UNPLUG only for real
> disconnection") let the check useless.
> 
> Therefore, I revert commit 0ee1f4734967 ("r8152: napi hangup fix
> after disconnect") first, and add another patch to fix it.

Series applied, thank you.
