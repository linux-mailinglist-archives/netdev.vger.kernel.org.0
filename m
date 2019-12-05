Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBB011390F
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 01:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728570AbfLEA7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 19:59:39 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38436 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728121AbfLEA7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 19:59:39 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BCD7214F3638D;
        Wed,  4 Dec 2019 16:59:38 -0800 (PST)
Date:   Wed, 04 Dec 2019 16:59:38 -0800 (PST)
Message-Id: <20191204.165938.1723521846846109078.davem@davemloft.net>
To:     maowenan@huawei.com
Cc:     gregkh@linuxfoundation.org, alexios.zavras@intel.com,
        oneukum@suse.com, tglx@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        hulkci@huawei.com
Subject: Re: [PATCH -next] NFC: port100: Convert
 cpu_to_le16(le16_to_cpu(E1) + E2) to use le16_add_cpu().
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191204063717.102854-1-maowenan@huawei.com>
References: <20191204063717.102854-1-maowenan@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Dec 2019 16:59:39 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mao Wenan <maowenan@huawei.com>
Date: Wed, 4 Dec 2019 14:37:17 +0800

> It is better to convert cpu_to_le16(le16_to_cpu(frame->datalen) + len) to
> use le16_add_cpu().
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Mao Wenan <maowenan@huawei.com>

Please resubmit when the net-next tree is open again, right now it is
closed:

	http://vger.kernel.org/~davem/net-next.html
