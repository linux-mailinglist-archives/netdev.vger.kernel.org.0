Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534CB1BCE3E
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 23:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgD1VLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 17:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726284AbgD1VLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 17:11:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B28C03C1AC;
        Tue, 28 Apr 2020 14:11:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 99016120F52B8;
        Tue, 28 Apr 2020 14:11:12 -0700 (PDT)
Date:   Tue, 28 Apr 2020 14:11:11 -0700 (PDT)
Message-Id: <20200428.141111.54288142814578996.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     andrew.hendry@gmail.com, kuba@kernel.org, allison@lohutok.net,
        tglx@linutronix.de, gregkh@linuxfoundation.org,
        tanxin.ctf@gmail.com, xiyuyang19@fudan.edu.cn,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/x25: Fix null-ptr-deref in x25_disconnect
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200428081208.26308-1-yuehaibing@huawei.com>
References: <000000000000cbf17205a452ad4f@google.com>
        <20200428081208.26308-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Apr 2020 14:11:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Tue, 28 Apr 2020 16:12:08 +0800

> We should check null before do x25_neigh_put in x25_disconnect,
> otherwise may cause null-ptr-deref like this:
...
> Reported-by: syzbot+6db548b615e5aeefdce2@syzkaller.appspotmail.com
> Fixes: 4becb7ee5b3d ("net/x25: Fix x25_neigh refcnt leak when x25 disconnect")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
