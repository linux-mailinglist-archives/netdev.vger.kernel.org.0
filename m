Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 907E1F3C1F
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 00:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfKGXYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 18:24:36 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49826 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfKGXYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 18:24:35 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8B50A15371C2E;
        Thu,  7 Nov 2019 15:24:34 -0800 (PST)
Date:   Thu, 07 Nov 2019 15:24:33 -0800 (PST)
Message-Id: <20191107.152433.2093440519085855964.davem@davemloft.net>
To:     bianpan2016@163.com
Cc:     johannes.berg@intel.com, swinslow@gmail.com, 92siuyang@gmail.com,
        allison@lohutok.net, mkubecek@suse.cz, andreyknvl@google.com,
        tglx@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] nfc: netlink: fix double device reference drop
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1573108190-30836-1-git-send-email-bianpan2016@163.com>
References: <1573108190-30836-1-git-send-email-bianpan2016@163.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 15:24:34 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>
Date: Thu,  7 Nov 2019 14:29:50 +0800

> The function nfc_put_device(dev) is called twice to drop the reference
> to dev when there is no associated local llcp. Remove one of them to fix
> the bug.
> 
> Signed-off-by: Pan Bian <bianpan2016@163.com>
> ---
> v2: change subject of the patch

Applied, with Fixes: tags added, and queued up for -stable, thanks.
