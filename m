Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352AE21602B
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 22:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgGFUTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 16:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgGFUTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 16:19:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA917C061755;
        Mon,  6 Jul 2020 13:19:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3F7D3120ED4AD;
        Mon,  6 Jul 2020 13:19:11 -0700 (PDT)
Date:   Mon, 06 Jul 2020 13:19:10 -0700 (PDT)
Message-Id: <20200706.131910.1401749404818988951.davem@davemloft.net>
To:     alobakin@marvell.com
Cc:     kuba@kernel.org, irusskikh@marvell.com,
        michal.kalderon@marvell.com, aelior@marvell.com,
        denis.bolotin@marvell.com, GR-everest-linux-l2@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/9] net: qed/qede: W=1 C=1 warnings cleanup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200706153821.786-1-alobakin@marvell.com>
References: <20200706153821.786-1-alobakin@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Jul 2020 13:19:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alobakin@marvell.com>
Date: Mon, 6 Jul 2020 18:38:12 +0300

> This set cleans qed/qede build log under W=1 C=1 with GCC 8 and
> sparse 0.6.2. The only thing left is "context imbalance -- unexpected
> unlock" in one of the source files, which will be issued later during
> the refactoring cycles.
> 
> The biggest part is handling the endianness warnings. The current code
> often just assumes that both host and device operate in LE, which is
> obviously incorrect (despite the fact that it's true for x86 platforms),
> and makes sparse {s,m}ad.
> 
> The rest of the series is mostly random non-functional fixes
> here-and-there.

Series applied, thank you.
