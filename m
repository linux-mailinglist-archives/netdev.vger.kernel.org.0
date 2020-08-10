Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA78E240D6E
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 21:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbgHJTHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 15:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbgHJTHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 15:07:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2183CC061756;
        Mon, 10 Aug 2020 12:07:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B0A49127517B7;
        Mon, 10 Aug 2020 11:50:56 -0700 (PDT)
Date:   Mon, 10 Aug 2020 12:07:39 -0700 (PDT)
Message-Id: <20200810.120739.1883274758298088684.davem@davemloft.net>
To:     hch@lst.de
Cc:     kuba@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        edumazet@google.com, john.stultz@linaro.org
Subject: Re: [PATCH] net: Revert "net: optimize the sockptr_t for unified
 kernel/user address spaces"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200810164214.9978-1-hch@lst.de>
References: <20200810164214.9978-1-hch@lst.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Aug 2020 11:50:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Mon, 10 Aug 2020 18:42:14 +0200

> This reverts commits 6d04fe15f78acdf8e32329e208552e226f7a8ae6 and
> a31edb2059ed4e498f9aa8230c734b59d0ad797a.
> 
> It turns out the idea to share a single pointer for both kernel and user
> space address causes various kinds of problems.  So use the slightly less
> optimal version that uses an extra bit, but which is guaranteed to be safe
> everywhere.
> 
> Fixes: 6d04fe15f78a ("net: optimize the sockptr_t for unified kernel/user address spaces")
> Reported-by: Eric Dumazet <edumazet@google.com>
> Reported-by: John Stultz <john.stultz@linaro.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Applied, thanks.
