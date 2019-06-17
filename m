Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59AD949159
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 22:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbfFQU3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 16:29:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37850 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfFQU3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 16:29:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6C9701511042F;
        Mon, 17 Jun 2019 13:29:15 -0700 (PDT)
Date:   Mon, 17 Jun 2019 13:29:14 -0700 (PDT)
Message-Id: <20190617.132914.2072904368765535293.davem@davemloft.net>
To:     tuong.t.lien@dektech.com.au
Cc:     jon.maloy@ericsson.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [net-next] tipc: include retrans failure detection for unicast
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190617051542.4133-1-tuong.t.lien@dektech.com.au>
References: <20190617051542.4133-1-tuong.t.lien@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Jun 2019 13:29:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>
Date: Mon, 17 Jun 2019 12:15:42 +0700

> In patch series, commit 9195948fbf34 ("tipc: improve TIPC throughput by
> Gap ACK blocks"), as for simplicity, the repeated retransmit failures'
> detection in the function - "tipc_link_retrans()" was kept there for
> broadcast retransmissions only.
> 
> This commit now reapplies this feature for link unicast retransmissions
> that has been done via the function - "tipc_link_advance_transmq()".
> 
> Also, the "tipc_link_retrans()" is renamed to "tipc_link_bc_retrans()"
> as it is used only for broadcast.
> 
> Acked-by: Jon Maloy <jon.maloy@ericsson.se>
> Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>

Applied, thank you.
