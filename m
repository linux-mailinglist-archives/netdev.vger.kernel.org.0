Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20A3911D66B
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 19:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730685AbfLLSw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 13:52:59 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42592 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730463AbfLLSw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 13:52:59 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D516D153DCDBB;
        Thu, 12 Dec 2019 10:52:58 -0800 (PST)
Date:   Thu, 12 Dec 2019 10:52:58 -0800 (PST)
Message-Id: <20191212.105258.579549471896891617.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     Jason@zx2c4.com, wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: Remove unused including <linux/version.h>
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191212091527.35293-1-yuehaibing@huawei.com>
References: <20191212091527.35293-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Dec 2019 10:52:59 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Thu, 12 Dec 2019 09:15:27 +0000

> Remove including <linux/version.h> that don't need it.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Appropriate subject line for this should have been:

	Subject: [PATCH net-next] wireguard: Remove unused include <linux/version.h>

'net' is too broad a subsystem prefix as it basically encompases half of the
entire kernel tree.  When people look at the git shortlog output you need to
be specific enough that people can tell what touches what.
