Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 122137C828
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 18:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729709AbfGaQHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 12:07:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39758 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725209AbfGaQHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 12:07:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 113BC140AD8FF;
        Wed, 31 Jul 2019 09:07:21 -0700 (PDT)
Date:   Wed, 31 Jul 2019 09:07:20 -0700 (PDT)
Message-Id: <20190731.090720.391196858300492585.davem@davemloft.net>
To:     gregkh@linuxfoundation.org
Cc:     willy@infradead.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, yuehaibing@huawei.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging/octeon: Fix build error without
 CONFIG_NETDEVICES
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190731160219.GA2114@kroah.com>
References: <20190731160219.GA2114@kroah.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 31 Jul 2019 09:07:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>
Date: Wed, 31 Jul 2019 18:02:19 +0200

> From: YueHaibing <yuehaibing@huawei.com>
> 
> While do COMPILE_TEST build without CONFIG_NETDEVICES,
> we get Kconfig warning:
> 
> WARNING: unmet direct dependencies detected for PHYLIB
>   Depends on [n]: NETDEVICES [=n]
>   Selected by [y]:
>   - OCTEON_ETHERNET [=y] && STAGING [=y] && (CAVIUM_OCTEON_SOC && NETDEVICES [=n] || COMPILE_TEST [=y])
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Reported-by: Mark Brown <broonie@kernel.org>
> Fixes: 171a9bae68c7 ("staging/octeon: Allow test build on !MIPS")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Applied to net-next.
