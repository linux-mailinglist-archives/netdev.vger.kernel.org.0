Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 513231A1993
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 03:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgDHBbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 21:31:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44326 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbgDHBbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 21:31:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DFB651210A3E3;
        Tue,  7 Apr 2020 18:31:42 -0700 (PDT)
Date:   Tue, 07 Apr 2020 18:31:42 -0700 (PDT)
Message-Id: <20200407.183142.390281754035873578.davem@davemloft.net>
To:     khlebnikov@yandex-team.ru
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, zeil@yandex-team.ru, tedheadster@gmail.com
Subject: Re: [PATCH] net: revert default NAPI poll timeout to 2 jiffies
From:   David Miller <davem@davemloft.net>
In-Reply-To: <158617317267.1170.12944758673162826206.stgit@buzz>
References: <158617317267.1170.12944758673162826206.stgit@buzz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Apr 2020 18:31:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Date: Mon, 06 Apr 2020 14:39:32 +0300

> For HZ < 1000 timeout 2000us rounds up to 1 jiffy but expires randomly
> because next timer interrupt could come shortly after starting softirq.
> 
> For commonly used CONFIG_HZ=1000 nothing changes.
> 
> Fixes: 7acf8a1e8a28 ("Replace 2 jiffies with sysctl netdev_budget_usecs to enable softirq tuning")
> Reported-by: Dmitry Yakunin <zeil@yandex-team.ru>
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

Applied, thank you.
