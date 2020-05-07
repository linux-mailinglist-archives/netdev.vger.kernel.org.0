Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 055611C9B93
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 22:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728551AbgEGUEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 16:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726320AbgEGUEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 16:04:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8944CC05BD43;
        Thu,  7 May 2020 13:04:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 431931195077E;
        Thu,  7 May 2020 13:04:39 -0700 (PDT)
Date:   Thu, 07 May 2020 13:04:38 -0700 (PDT)
Message-Id: <20200507.130438.579883511397409999.davem@davemloft.net>
To:     yanaijie@huawei.com
Cc:     netdev@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: tulip: de4x5: make PCI_signature()
 return void
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200507110847.37940-1-yanaijie@huawei.com>
References: <20200507110847.37940-1-yanaijie@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 May 2020 13:04:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Yan <yanaijie@huawei.com>
Date: Thu, 7 May 2020 19:08:47 +0800

> This function always return 0 now, we can make it return void to
> simplify the code. This fixes the following coccicheck warning:
> 
> drivers/net/ethernet/dec/tulip/de4x5.c:3908:11-17: Unneeded variable:
> "status". Return "0" on line 3912
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Applied.
