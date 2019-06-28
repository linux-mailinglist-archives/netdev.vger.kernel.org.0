Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FECF5A0F8
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 18:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbfF1QcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 12:32:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47266 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbfF1QcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 12:32:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BE9DA14E038E3;
        Fri, 28 Jun 2019 09:32:15 -0700 (PDT)
Date:   Fri, 28 Jun 2019 09:32:15 -0700 (PDT)
Message-Id: <20190628.093215.173840298920978641.davem@davemloft.net>
To:     arnd@arndb.de
Cc:     aviad.krawczyk@huawei.com, xuechaojing@huawei.com,
        jesse.brandeburg@intel.com, zhaochen6@huawei.com,
        edumazet@google.com, dann.frazier@canonical.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hinic: reduce rss_init stack usage
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190628103158.2446356-1-arnd@arndb.de>
References: <20190628103158.2446356-1-arnd@arndb.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Jun 2019 09:32:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 28 Jun 2019 12:31:44 +0200

> On 32-bit architectures, putting an array of 256 u32 values on the
> stack uses more space than the warning limit:
> 
> drivers/net/ethernet/huawei/hinic/hinic_main.c: In function 'hinic_rss_init':
> drivers/net/ethernet/huawei/hinic/hinic_main.c:286:1: error: the frame size of 1068 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> 
> I considered changing the code to use u8 values here, since that's
> all the hardware supports, but dynamically allocating the array is
> a more isolated fix here.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied to net-next.

Arnd, please make it clear what tree you are targetting in the
future.  Thank you.
