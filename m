Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8E35EB947
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 22:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbfJaVuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 17:50:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33230 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728561AbfJaVuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 17:50:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5BDDA1500397B;
        Thu, 31 Oct 2019 14:50:15 -0700 (PDT)
Date:   Thu, 31 Oct 2019 14:50:14 -0700 (PDT)
Message-Id: <20191031.145014.186986700333108637.davem@davemloft.net>
To:     joe@perches.com
Cc:     gregkh@linuxfoundation.org, perex@perex.cz,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] hp100: Move 100BaseVG AnyLAN driver to staging
From:   David Miller <davem@davemloft.net>
In-Reply-To: <4024b52c917975cebde58afc094eed1a107622c2.1572545956.git.joe@perches.com>
References: <4024b52c917975cebde58afc094eed1a107622c2.1572545956.git.joe@perches.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 31 Oct 2019 14:50:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 31 Oct 2019 11:23:37 -0700

> 100BaseVG AnyLAN hasn't been useful since 1996 or so and even then
> didn't sell many devices.  It's unlikely any are still in use.
> 
> Move the driver to staging with the intent of removing it altogether
> one day.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied to net-next.
