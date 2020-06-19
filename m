Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C532000F0
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 05:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgFSDql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 23:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgFSDql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 23:46:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D01C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 20:46:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E5C08120ED49C;
        Thu, 18 Jun 2020 20:46:40 -0700 (PDT)
Date:   Thu, 18 Jun 2020 20:46:40 -0700 (PDT)
Message-Id: <20200618.204640.2179914524937773513.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, kuba@kernel.org,
        willemb@google.com, sgoutham@marvell.com,
        antoine.tenart@bootlin.com
Subject: Re: [PATCH v2 net-next 0/6] net: tso: expand to UDP support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200618035326.39686-1-edumazet@google.com>
References: <20200618035326.39686-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jun 2020 20:46:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 17 Jun 2020 20:53:20 -0700

> With QUIC getting more attention these days, it is worth
> implementing UDP direct segmentation, the same we did for TCP.
> 
> Drivers will need to advertize NETIF_F_GSO_UDP_L4 so that
> GSO stack does not do the (more expensive) segmentation.
> 
> Note the two first patches are stable candidates, after
> tests confirm they do not add regressions.
> 
> v2: addressed Jakub feedback :
>    1) Added a prep patch for octeontx2-af
>    2) calls tso_start() earlier in otx2_sq_append_tso()

Series applied, thanks Eric.
