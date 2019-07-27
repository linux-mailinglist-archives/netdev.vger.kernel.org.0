Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA9177BFB
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 23:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbfG0VSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 17:18:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40292 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725265AbfG0VSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 17:18:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4E1BE1534E491;
        Sat, 27 Jul 2019 14:18:13 -0700 (PDT)
Date:   Sat, 27 Jul 2019 14:18:12 -0700 (PDT)
Message-Id: <20190727.141812.424056483851039132.davem@davemloft.net>
To:     natechancellor@gmail.com
Cc:     iyappan@os.amperecomputing.com, keyur@os.amperecomputing.com,
        quan@os.amperecomputing.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, skunberg.kelsey@gmail.com
Subject: Re: [PATCH] drivers: net: xgene: Move status variable declaration
 into CONFIG_ACPI block
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190726162037.37308-1-natechancellor@gmail.com>
References: <20190726162037.37308-1-natechancellor@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 27 Jul 2019 14:18:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>
Date: Fri, 26 Jul 2019 09:20:37 -0700

> When CONFIG_ACPI is unset (arm allyesconfig), status is unused.
> 
> drivers/net/ethernet/apm/xgene/xgene_enet_xgmac.c:383:14: warning:
> unused variable 'status' [-Wunused-variable]
>         acpi_status status;
>                     ^
> drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c:440:14: warning:
> unused variable 'status' [-Wunused-variable]
>         acpi_status status;
>                     ^
> drivers/net/ethernet/apm/xgene/xgene_enet_hw.c:697:14: warning: unused
> variable 'status' [-Wunused-variable]
>         acpi_status status;
>                     ^
> 
> Move the declaration into the CONFIG_ACPI block so that there are no
> compiler warnings.
> 
> Fixes: 570d785ba46b ("drivers: net: xgene: Remove acpi_has_method() calls")
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Applied.
