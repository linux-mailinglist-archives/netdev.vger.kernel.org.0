Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 012305C6C6
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 03:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfGBBv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 21:51:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53640 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbfGBBv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 21:51:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D8DB614DE870D;
        Mon,  1 Jul 2019 18:51:56 -0700 (PDT)
Date:   Mon, 01 Jul 2019 18:51:56 -0700 (PDT)
Message-Id: <20190701.185156.2142325894415755085.davem@davemloft.net>
To:     jelsasser@appneta.com
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, edumazet@google.com, mcroce@redhat.com
Subject: Re: [PATCH RESEND 4.9.y] net: check before dereferencing
 netdev_ops during busy poll
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190701234143.72631-1-jelsasser@appneta.com>
References: <20190701234143.72631-1-jelsasser@appneta.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jul 2019 18:51:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Josh Elsasser <jelsasser@appneta.com>
Date: Mon,  1 Jul 2019 16:41:43 -0700

> No changes since V2[1], resent as per discussiond on -stable[2]. I hope
> this is the correct way to send net fixes for older LTS releases, I'm
> going off of the latest netdev FAQ:

I just tried to apply this with "git am" to the current v4.19 -stable
branch and it failed.

[davem@localhost linux-stable]$ git am --signoff diff
Applying: net: check before dereferencing netdev_ops during busy poll
error: patch failed: net/core/dev.c:5083
error: net/core/dev.c: patch does not apply
Patch failed at 0001 net: check before dereferencing netdev_ops during busy poll
hint: Use 'git am --show-current-patch' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".
