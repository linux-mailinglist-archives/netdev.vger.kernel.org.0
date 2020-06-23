Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5670C2066A9
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387697AbgFWVvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 17:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387455AbgFWVvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 17:51:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F103C061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 14:51:24 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4800B12944A86;
        Tue, 23 Jun 2020 14:51:24 -0700 (PDT)
Date:   Tue, 23 Jun 2020 14:51:23 -0700 (PDT)
Message-Id: <20200623.145123.1064457264732125231.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 0/2] wireguard fixes for 5.8-rc3
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200623095945.1402468-1-Jason@zx2c4.com>
References: <20200623095945.1402468-1-Jason@zx2c4.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jun 2020 14:51:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 23 Jun 2020 03:59:43 -0600

> This series contains two fixes, one cosmetic and one quite important:
> 
> 1) Avoid the `if ((x = f()) == y)` pattern, from Frank
>    Werner-Krippendorf.
> 
> 2) Mitigate a potential memory leak by creating circular netns
>    references, while also making the netns semantics a bit more
>    robust.

Series applied.

> Patch (2) has a "Fixes:" line and should be backported to stable.

Queued up.

Thanks.
