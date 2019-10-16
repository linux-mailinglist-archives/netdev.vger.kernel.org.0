Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A77AFD8567
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 03:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbfJPBQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 21:16:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42866 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfJPBQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 21:16:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0D1C0126514C7;
        Tue, 15 Oct 2019 18:16:50 -0700 (PDT)
Date:   Tue, 15 Oct 2019 18:16:49 -0700 (PDT)
Message-Id: <20191015.181649.949805234862708186.davem@davemloft.net>
To:     alobakin@dlink.ru
Cc:     ecree@solarflare.com, jiri@mellanox.com, edumazet@google.com,
        idosch@mellanox.com, pabeni@redhat.com, petrm@mellanox.com,
        sd@queasysnail.net, f.fainelli@gmail.com,
        jaswinder.singh@linaro.org, ilias.apalodimas@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: core: use listified Rx for GRO_NORMAL
 in napi_gro_receive()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191014080033.12407-1-alobakin@dlink.ru>
References: <20191014080033.12407-1-alobakin@dlink.ru>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 18:16:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alobakin@dlink.ru>
Date: Mon, 14 Oct 2019 11:00:33 +0300

> Commit 323ebb61e32b4 ("net: use listified RX for handling GRO_NORMAL
> skbs") made use of listified skb processing for the users of
> napi_gro_frags().
> The same technique can be used in a way more common napi_gro_receive()
> to speed up non-merged (GRO_NORMAL) skbs for a wide range of drivers
> including gro_cells and mac80211 users.
> This slightly changes the return value in cases where skb is being
> dropped by the core stack, but it seems to have no impact on related
> drivers' functionality.
> gro_normal_batch is left untouched as it's very individual for every
> single system configuration and might be tuned in manual order to
> achieve an optimal performance.
> 
> Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
> Acked-by: Edward Cree <ecree@solarflare.com>

Applied, thank you.
