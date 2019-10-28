Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54055E7D1B
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 00:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730990AbfJ1Xia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 19:38:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46770 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbfJ1Xia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 19:38:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BB5E214BF203D;
        Mon, 28 Oct 2019 16:38:29 -0700 (PDT)
Date:   Mon, 28 Oct 2019 16:38:29 -0700 (PDT)
Message-Id: <20191028.163829.742443331770467098.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     edumazet@google.com, willemb@google.com, deepa.kernel@gmail.com,
        kafai@fb.com, arnd@arndb.de, dh.herrmann@gmail.com,
        zhang.lin16@zte.com.cn, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] sock: remove unneeded semicolon
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191025091836.35072-1-yuehaibing@huawei.com>
References: <20191025091836.35072-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 28 Oct 2019 16:38:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Fri, 25 Oct 2019 17:18:36 +0800

> remove unneeded semicolon.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
