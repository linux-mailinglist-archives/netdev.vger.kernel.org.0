Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 578EDBEC9A
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 09:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729980AbfIZHfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 03:35:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44866 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728240AbfIZHfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 03:35:34 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F405012B02593;
        Thu, 26 Sep 2019 00:35:32 -0700 (PDT)
Date:   Thu, 26 Sep 2019 09:35:31 +0200 (CEST)
Message-Id: <20190926.093531.2264373827205325138.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        weiwan@google.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] ipv6: do not free rt if FIB_LOOKUP_NOREF is set on
 suppress rule
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190924140128.19394-1-Jason@zx2c4.com>
References: <20190924.145257.2013712373872209531.davem@davemloft.net>
        <20190924140128.19394-1-Jason@zx2c4.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Sep 2019 00:35:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 24 Sep 2019 16:01:28 +0200

> Commit 7d9e5f422150 removed references from certain dsts, but accounting
> for this never translated down into the fib6 suppression code. This bug
> was triggered by WireGuard users who use wg-quick(8), which uses the
> "suppress-prefix" directive to ip-rule(8) for routing all of their
> internet traffic without routing loops. The test case added here
> causes the reference underflow by causing packets to evaluate a suppress
> rule.
> 
> Cc: stable@vger.kernel.org

Please don't CC: stable for networking fixes, I handle these manually as per
the netdev FAQ.

> Fixes: 7d9e5f422150 ("ipv6: convert major tx path to use RT6_LOOKUP_F_DST_NOREF")
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Applied and queued up for -stable, thanks.
