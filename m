Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50477280C13
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 03:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387543AbgJBBpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 21:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727780AbgJBBpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 21:45:45 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE237C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 18:45:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BDEE11285D1A7;
        Thu,  1 Oct 2020 18:28:57 -0700 (PDT)
Date:   Thu, 01 Oct 2020 18:45:44 -0700 (PDT)
Message-Id: <20201001.184544.2087043514608904373.davem@davemloft.net>
To:     yebin10@huawei.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, hulkci@huawei.com
Subject: Re: [PATCH 1/2] pktgen: Fix inconsistent of format with argument
 type in pktgen.c
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200930010838.1266872-2-yebin10@huawei.com>
References: <20200930010838.1266872-1-yebin10@huawei.com>
        <20200930010838.1266872-2-yebin10@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 01 Oct 2020 18:28:57 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>
Date: Wed, 30 Sep 2020 09:08:37 +0800

> Fix follow warnings:
> [net/core/pktgen.c:925]: (warning) %u in format string (no. 1)
> 	requires 'unsigned int' but the argument type is 'signed int'.
> [net/core/pktgen.c:942]: (warning) %u in format string (no. 1)
> 	requires 'unsigned int' but the argument type is 'signed int'.
> [net/core/pktgen.c:962]: (warning) %u in format string (no. 1)
> 	requires 'unsigned int' but the argument type is 'signed int'.
> [net/core/pktgen.c:984]: (warning) %u in format string (no. 1)
> 	requires 'unsigned int' but the argument type is 'signed int'.
> [net/core/pktgen.c:1149]: (warning) %d in format string (no. 1)
> 	requires 'int' but the argument type is 'unsigned int'.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Ye Bin <yebin10@huawei.com>

Applied.
