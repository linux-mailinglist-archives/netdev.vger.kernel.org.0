Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B531B8283
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 01:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgDXXpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 19:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbgDXXpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 19:45:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE562C09B049
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 16:45:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3371614F43DBE;
        Fri, 24 Apr 2020 16:45:09 -0700 (PDT)
Date:   Fri, 24 Apr 2020 16:45:08 -0700 (PDT)
Message-Id: <20200424.164508.994949344270029718.davem@davemloft.net>
To:     brouer@redhat.com
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        toke@redhat.com, ruxandra.radulescu@nxp.com, ioana.ciornei@nxp.com,
        nipun.gupta@nxp.com, shawnguo@kernel.org
Subject: Re: [PATCH net-next 0/2] Fix qdisc noop issue caused by driver and
 identify future bugs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <158765382862.1613879.11444486146802159959.stgit@firesoul>
References: <158765382862.1613879.11444486146802159959.stgit@firesoul>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Apr 2020 16:45:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Thu, 23 Apr 2020 16:57:40 +0200

> I've been very puzzled why networking on my NXP development board,
> using driver dpaa2-eth, stopped working when I updated the kernel
> version >= 5.3.  The observable issue were that interface would drop
> all TX packets, because it had assigned the qdisc noop.
> 
> This turned out the be a NIC driver bug, that would only get triggered
> when using sysctl net/core/default_qdisc=fq_codel. It was non-trivial
> to find out[1] this was driver related. Thus, this patchset besides
> fixing the driver bug, also helps end-user identify the issue.
> 
> [1]: https://github.com/xdp-project/xdp-project/blob/master/areas/arm64/board_nxp_ls1088/nxp-board04-troubleshoot-qdisc.org

Series applied to net-next, thanks.
