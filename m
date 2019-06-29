Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 869B25AD0C
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 21:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfF2TV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 15:21:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39462 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbfF2TV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 15:21:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1F28614C74925;
        Sat, 29 Jun 2019 12:21:56 -0700 (PDT)
Date:   Sat, 29 Jun 2019 12:21:55 -0700 (PDT)
Message-Id: <20190629.122155.104888078125933248.davem@davemloft.net>
To:     baruch@tkos.co.il
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: dsa: mv88e6xxx: wait after reset deactivation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <2e272a4e588ae44137864237d0cd73e2208f2c60.1561659459.git.baruch@tkos.co.il>
References: <2e272a4e588ae44137864237d0cd73e2208f2c60.1561659459.git.baruch@tkos.co.il>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Jun 2019 12:21:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baruch Siach <baruch@tkos.co.il>
Date: Thu, 27 Jun 2019 21:17:39 +0300

> Add a 1ms delay after reset deactivation. Otherwise the chip returns
> bogus ID value. This is observed with 88E6390 (Peridot) chip.
> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
> v2: Address Andrew Lunn's comments:
>   Use usleep_range.
>   Delay only when reset line is valid.

Applied and queuedu up for -stable, thanks.
