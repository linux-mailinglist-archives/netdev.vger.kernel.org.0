Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33298216056
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 22:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbgGFUbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 16:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgGFUbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 16:31:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B953C061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 13:31:43 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DD3C1120F19C4;
        Mon,  6 Jul 2020 13:31:42 -0700 (PDT)
Date:   Mon, 06 Jul 2020 13:31:42 -0700 (PDT)
Message-Id: <20200706.133142.2053119289184509872.davem@davemloft.net>
To:     dcaratti@redhat.com
Cc:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        netdev@vger.kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH net-next] mptcp: fix race in subflow_data_ready()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <4eed4130aba55b8a2b3854fe99d254a50530866b.1594062200.git.dcaratti@redhat.com>
References: <4eed4130aba55b8a2b3854fe99d254a50530866b.1594062200.git.dcaratti@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Jul 2020 13:31:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>
Date: Mon,  6 Jul 2020 21:06:12 +0200

> syzkaller was able to make the kernel reach subflow_data_ready() for a
> server subflow that was closed before subflow_finish_connect() completed.
> In these cases we can avoid using the path for regular/fallback MPTCP
> data, and just wake the main socket, to avoid the following warning:
 ...
> Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/39
> Reported-by: Christoph Paasch <cpaasch@apple.com>
> Fixes: e1ff9e82e2ea ("net: mptcp: improve fallback to TCP")
> Suggested-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Applied, thank you.
