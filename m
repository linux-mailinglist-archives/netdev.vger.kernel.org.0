Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421E527DD9D
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 03:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729506AbgI3BOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 21:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728931AbgI3BOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 21:14:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18772C061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 18:14:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B5625127ECB5B;
        Tue, 29 Sep 2020 17:57:21 -0700 (PDT)
Date:   Tue, 29 Sep 2020 18:14:08 -0700 (PDT)
Message-Id: <20200929.181408.534589469741619213.davem@davemloft.net>
To:     mathew.j.martineau@linux.intel.com
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org, pabeni@redhat.com
Subject: Re: [PATCH net 2/2] mptcp: Handle incoming 32-bit DATA_FIN values
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200929220820.278003-3-mathew.j.martineau@linux.intel.com>
References: <20200929220820.278003-1-mathew.j.martineau@linux.intel.com>
        <20200929220820.278003-3-mathew.j.martineau@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 29 Sep 2020 17:57:21 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Date: Tue, 29 Sep 2020 15:08:20 -0700

> The peer may send a DATA_FIN mapping with either a 32-bit or 64-bit
> sequence number. When a 32-bit sequence number is received for the
> DATA_FIN, it must be expanded to 64 bits before comparing it to the
> last acked sequence number. This expansion was missing.
> 
> Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/93
> Fixes: 3721b9b64676 (mptcp: Track received DATA_FIN sequence number and add related helpers)
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

The commit header text in a Fixes: tag should be inside of double quotes
as well as parenthesis, like ("this")

I fixed this up while applying this series, but please get it correct
next time.
