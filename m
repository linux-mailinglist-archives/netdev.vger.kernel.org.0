Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 378E4F26D0
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 06:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbfKGFTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 00:19:38 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33708 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbfKGFTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 00:19:38 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 629B815103734;
        Wed,  6 Nov 2019 21:19:37 -0800 (PST)
Date:   Wed, 06 Nov 2019 21:19:36 -0800 (PST)
Message-Id: <20191106.211936.1279246967616905224.davem@davemloft.net>
To:     bianpan2016@163.com
Cc:     johannes.berg@intel.com, andreyknvl@google.com,
        opensource@jilayne.com, swinslow@gmail.com, mkubecek@suse.cz,
        tglx@linutronix.de, 92siuyang@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netlink: fix double drop dev reference
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1573041943-9316-1-git-send-email-bianpan2016@163.com>
References: <1573041943-9316-1-git-send-email-bianpan2016@163.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Nov 2019 21:19:37 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>
Date: Wed,  6 Nov 2019 20:05:43 +0800

> The function nfc_put_device(dev) is called twice to drop the reference
> to dev when there is no associated local llcp. Remove one of them to fix
> the bug.
> 
> Signed-off-by: Pan Bian <bianpan2016@163.com>

This is a change to the nfc subsystem not to the netlink subsystem,
therefore the appropriate subsystem prefix is "nfc: " and probably
therefore:

	Subject: [PATCH] nfc: Fix double device reference drop in netlink code.

or something like that.
