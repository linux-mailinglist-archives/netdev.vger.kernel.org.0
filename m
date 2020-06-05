Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D92E1F00D1
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 22:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbgFEUNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 16:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727917AbgFEUNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 16:13:51 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C47CC08C5C2;
        Fri,  5 Jun 2020 13:13:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 512BB127AEEE6;
        Fri,  5 Jun 2020 13:13:50 -0700 (PDT)
Date:   Fri, 05 Jun 2020 13:13:49 -0700 (PDT)
Message-Id: <20200605.131349.189750898730910530.davem@davemloft.net>
To:     bloodyreaper@yandex.ru
Cc:     kuba@kernel.org, thomas.petazzoni@bootlin.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        sven.auhagen@voleatech.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH net] net: ethernet: mvneta: fix MVNETA_SKB_HEADROOM
 alignment
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200605125324.52474-1-bloodyreaper@yandex.ru>
References: <20200605125324.52474-1-bloodyreaper@yandex.ru>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Jun 2020 13:13:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <bloodyreaper@yandex.ru>
Date: Fri,  5 Jun 2020 15:53:24 +0300

> Commit ca23cb0bc50f ("mvneta: MVNETA_SKB_HEADROOM set last 3 bits to zero")
> added headroom alignment check against 8.
> Hovewer (if we imagine that NET_SKB_PAD or XDP_PACKET_HEADROOM is not
> aligned to cacheline size), it actually aligns headroom down, while
> skb/xdp_buff headroom should be *at least* equal to one of the values
> (depending on XDP prog presence).
> So, fix the check to align the value up. This satisfies both
> hardware/driver and network stack requirements.
> 
> Fixes: ca23cb0bc50f ("mvneta: MVNETA_SKB_HEADROOM set last 3 bits to zero")
> Signed-off-by: Alexander Lobakin <bloodyreaper@yandex.ru>

Applied, thank you.
