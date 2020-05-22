Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A36561DDC25
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 02:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgEVA1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 20:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbgEVA1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 20:27:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4623FC061A0E;
        Thu, 21 May 2020 17:27:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A6D31120ED486;
        Thu, 21 May 2020 17:27:10 -0700 (PDT)
Date:   Thu, 21 May 2020 17:27:10 -0700 (PDT)
Message-Id: <20200521.172710.1928946459385558873.davem@davemloft.net>
To:     tangbin@cmss.chinamobile.com
Cc:     ralf@linux-mips.org, paulburton@kernel.org, tbogendoerfer@suse.de,
        linux-mips@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhangshengju@cmss.chinamobile.com
Subject: Re: [PATCH] net: sgi: ioc3-eth: Fix return value check in
 ioc3eth_probe()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200520095532.20780-1-tangbin@cmss.chinamobile.com>
References: <20200520095532.20780-1-tangbin@cmss.chinamobile.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 May 2020 17:27:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tang Bin <tangbin@cmss.chinamobile.com>
Date: Wed, 20 May 2020 17:55:32 +0800

> In the function devm_platform_ioremap_resource(), if get resource
> failed, the return value is ERR_PTR() not NULL. Thus it must be
> replaced by IS_ERR(), or else it may result in crashes if a critical
> error path is encountered.
> 
> Fixes: 0ce5ebd24d25 ("mfd: ioc3: Add driver for SGI IOC3 chip")
> Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>

Applied, thanks.
