Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD91DE936E
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 00:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbfJ2XSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 19:18:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60956 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbfJ2XSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 19:18:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 17DF814EBC320;
        Tue, 29 Oct 2019 16:18:32 -0700 (PDT)
Date:   Tue, 29 Oct 2019 16:18:31 -0700 (PDT)
Message-Id: <20191029.161831.1560929325628369179.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     epomozov@marvell.com, igor.russkikh@aquantia.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: aquantia: remove unused including
 <linux/version.h>
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191026025109.75721-1-yuehaibing@huawei.com>
References: <20191026025109.75721-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 16:18:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Sat, 26 Oct 2019 02:51:09 +0000

> Remove including <linux/version.h> that don't need it.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
