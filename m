Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA2CBAC746
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 17:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403951AbfIGPeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 11:34:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46246 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389788AbfIGPeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 11:34:24 -0400
Received: from localhost (unknown [88.214.184.0])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9B76E152EFC23;
        Sat,  7 Sep 2019 08:34:22 -0700 (PDT)
Date:   Sat, 07 Sep 2019 17:34:21 +0200 (CEST)
Message-Id: <20190907.173421.792716263211692531.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        lukehsiao@google.com, ncardwell@google.com, dcaratti@redhat.com
Subject: Re: [PATCH net] tcp: ulp: fix possible crash in
 tcp_diag_get_aux_size()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190905202041.138085-1-edumazet@google.com>
References: <20190905202041.138085-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Sep 2019 08:34:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu,  5 Sep 2019 13:20:41 -0700

> tcp_diag_get_aux_size() can be called with sockets in any state.
> 
> icsk_ulp_ops is only present for full sockets.
> 
> For SYN_RECV or TIME_WAIT ones we would access garbage.
> 
> Fixes: 61723b393292 ("tcp: ulp: add functions to dump ulp-specific information")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Luke Hsiao <lukehsiao@google.com>
> Reported-by: Neal Cardwell <ncardwell@google.com>

Applied to net-next, thanks Eric.
