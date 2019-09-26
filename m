Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F991BEC4C
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 09:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbfIZHGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 03:06:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44630 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbfIZHGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 03:06:25 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 283E31264F762;
        Thu, 26 Sep 2019 00:06:23 -0700 (PDT)
Date:   Thu, 26 Sep 2019 09:06:22 +0200 (CEST)
Message-Id: <20190926.090622.761340436187528786.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: print proper warning on dst underflow
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190924090937.13001-1-Jason@zx2c4.com>
References: <20190924090937.13001-1-Jason@zx2c4.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Sep 2019 00:06:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 24 Sep 2019 11:09:37 +0200

> Proper warnings with stack traces make it much easier to figure out
> what's doing the double free and create more meaningful bug reports from
> users.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Applied, thanks.
