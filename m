Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1C82130A27
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 23:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgAEWNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 17:13:34 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40034 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgAEWNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 17:13:34 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 24FED15729AD5;
        Sun,  5 Jan 2020 14:13:33 -0800 (PST)
Date:   Sun, 05 Jan 2020 14:13:32 -0800 (PST)
Message-Id: <20200105.141332.1037832872586677248.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] WireGuard bug fixes and cleanups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200102164751.416922-1-Jason@zx2c4.com>
References: <20200102164751.416922-1-Jason@zx2c4.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 Jan 2020 14:13:33 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu,  2 Jan 2020 17:47:48 +0100

> I've been working through some personal notes and also the whole git
> repo history of the out-of-tree module, looking for places where
> tradeoffs were made (and subsequently forgotten about) for old kernels.
> The first two patches in this series clean up those. The first one does
> so in the self-tests and self-test harness, where we're now able to
> expand test coverage by a bit, and we're now cooking away tests on every
> commit to both the wireguard-linux repo and to net-next. The second one
> removes a workaround for a skbuff.h bug that was fixed long ago.
> Finally, the last patch in the series fixes in a bug unearthed by newer
> Qualcomm chipsets running the rmnet_perf driver, which does UDP GRO.

Series applied.

I wonder if, for patch #3, we should have a gro cells helper which just
does that list thing and thus makes the situation self documenting.
