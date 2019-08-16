Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0E3490915
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 21:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbfHPT6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 15:58:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38848 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727545AbfHPT6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 15:58:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0715A13E2E211;
        Fri, 16 Aug 2019 12:58:00 -0700 (PDT)
Date:   Fri, 16 Aug 2019 12:58:00 -0700 (PDT)
Message-Id: <20190816.125800.1611631994527519662.davem@davemloft.net>
To:     efremov@linux.com
Cc:     hkallweit1@gmail.com, joe@perches.com,
        linux-kernel@vger.kernel.org, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: r8169: Update path to the driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190814121209.3364-1-efremov@linux.com>
References: <69fac52e-8464-ea87-e2e5-422ae36a92c8@gmail.com>
        <20190814121209.3364-1-efremov@linux.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 16 Aug 2019 12:58:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis Efremov <efremov@linux.com>
Date: Wed, 14 Aug 2019 15:12:09 +0300

> Update MAINTAINERS record to reflect the filename change.
> The file was moved in commit 25e992a4603c ("r8169: rename
> r8169.c to r8169_main.c")
> 
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: nic_swsd@realtek.com
> Cc: David S. Miller <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Denis Efremov <efremov@linux.com>

Applied to 'net' since it's important to keep this uptodate and the
paths are such that this change is valid there too.

Thanks.
