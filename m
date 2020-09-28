Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA68E27B574
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 21:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgI1TiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 15:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbgI1TiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 15:38:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF0EC061755;
        Mon, 28 Sep 2020 12:38:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C6AAB1451C1D7;
        Mon, 28 Sep 2020 12:21:26 -0700 (PDT)
Date:   Mon, 28 Sep 2020 12:38:13 -0700 (PDT)
Message-Id: <20200928.123813.947887447112074188.davem@davemloft.net>
To:     hayashi.kunihiko@socionext.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: ethernet: ave: Replace alloc_etherdev() with
 devm_alloc_etherdev()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1601287493-4077-1-git-send-email-hayashi.kunihiko@socionext.com>
References: <1601287493-4077-1-git-send-email-hayashi.kunihiko@socionext.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 12:21:26 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Date: Mon, 28 Sep 2020 19:04:53 +0900

> Use devm_alloc_etherdev() to simplify the code instead of alloc_etherdev().
> 
> Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

Applied to net-next, thanks.
