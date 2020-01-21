Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE89A143BB6
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 12:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729152AbgAULKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 06:10:21 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36316 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbgAULKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 06:10:20 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F240915C1D7B3;
        Tue, 21 Jan 2020 03:10:18 -0800 (PST)
Date:   Tue, 21 Jan 2020 12:10:17 +0100 (CET)
Message-Id: <20200121.121017.935276956491301331.davem@davemloft.net>
To:     chenzhou10@huawei.com
Cc:     mhabets@solarflare.com, kuba@kernel.org,
        sergei.shtylyov@cogentembedded.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next v2] drivers: net: declance: fix comparing pointer
 to 0
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200121092455.82983-1-chenzhou10@huawei.com>
References: <20200121092455.82983-1-chenzhou10@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jan 2020 03:10:20 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen Zhou <chenzhou10@huawei.com>
Date: Tue, 21 Jan 2020 17:24:55 +0800

> Fixes coccicheck warning:
> 
> ./drivers/net/ethernet/amd/declance.c:611:14-15:
> 	WARNING comparing pointer to 0
> 
> Replace "skb == 0" with "!skb".
> 
> Signed-off-by: Chen Zhou <chenzhou10@huawei.com>

Applied, thanks.
