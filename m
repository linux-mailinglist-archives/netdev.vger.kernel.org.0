Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 758D611794A
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 23:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbfLIW1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 17:27:53 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36474 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbfLIW1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 17:27:53 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BBF93154925DC;
        Mon,  9 Dec 2019 14:27:52 -0800 (PST)
Date:   Mon, 09 Dec 2019 14:27:52 -0800 (PST)
Message-Id: <20191209.142752.72047324724544266.davem@davemloft.net>
To:     maowenan@huawei.com
Cc:     gregkh@linuxfoundation.org, alexios.zavras@intel.com,
        oneukum@suse.com, tglx@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        hulkci@huawei.com
Subject: Re: [PATCH v2 -next] NFC: port100: Convert
 cpu_to_le16(le16_to_cpu(E1) + E2) to use le16_add_cpu().
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191209130845.47777-1-maowenan@huawei.com>
References: <20191209130845.47777-1-maowenan@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Dec 2019 14:27:53 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mao Wenan <maowenan@huawei.com>
Date: Mon, 9 Dec 2019 21:08:45 +0800

> Convert cpu_to_le16(le16_to_cpu(frame->datalen) + len) to
> use le16_add_cpu(), which is more concise and does the same thing. 
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Mao Wenan <maowenan@huawei.com>

Applied, thanks.
