Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC83127D80F
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729086AbgI2U3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728457AbgI2U3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 16:29:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BA4C061755;
        Tue, 29 Sep 2020 13:29:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CC5DB146008BD;
        Tue, 29 Sep 2020 13:12:12 -0700 (PDT)
Date:   Tue, 29 Sep 2020 13:28:59 -0700 (PDT)
Message-Id: <20200929.132859.1281877426049965614.davem@davemloft.net>
To:     gustavoars@kernel.org
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] fddi/skfp: Avoid the use of one-element array
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200929132751.GA29220@embeddedor>
References: <20200929132751.GA29220@embeddedor>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 29 Sep 2020 13:12:13 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Date: Tue, 29 Sep 2020 08:27:51 -0500

> One-element arrays are being deprecated[1]. Replace the one-element array
> with a simple object of type u_char: 'u_char rm_pad1'[2], once it seems
> this is just a placeholder for padding.
> 
> [1] https://www.kernel.org/doc/html/v5.9-rc1/process/deprecated.html#zero-length-and-one-element-arrays
> [2] https://github.com/KSPP/linux/issues/86
> 
> Built-tested-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/lkml/5f72c23f.%2FkPBWcZBu+W6HKH4%25lkp@intel.com/
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Applied, thanks.
