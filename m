Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039D723168F
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 02:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730506AbgG2AC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 20:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730203AbgG2AC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 20:02:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FF4C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 17:02:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0D5B1128D3042;
        Tue, 28 Jul 2020 16:46:11 -0700 (PDT)
Date:   Tue, 28 Jul 2020 17:02:55 -0700 (PDT)
Message-Id: <20200728.170255.1791271197978687017.davem@davemloft.net>
To:     mathew.j.martineau@linux.intel.com
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        matthieu.baerts@tessares.net, pabeni@redhat.com
Subject: Re: [PATCH net-next 00/12] Exchange MPTCP DATA_FIN/DATA_ACK before
 TCP FIN
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200728221210.92841-1-mathew.j.martineau@linux.intel.com>
References: <20200728221210.92841-1-mathew.j.martineau@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Jul 2020 16:46:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Date: Tue, 28 Jul 2020 15:11:58 -0700

> This series allows the MPTCP-level connection to be closed with the
> peers exchanging DATA_FIN and DATA_ACK according to the state machine in
> appendix D of RFC 8684. The process is very similar to the TCP
> disconnect state machine. 
> 
> The prior code sends DATA_FIN only when TCP FIN packets are sent, and
> does not allow for the MPTCP-level connection to be half-closed.
> 
> Patch 8 ("mptcp: Use full MPTCP-level disconnect state machine") is the
> core of the series. Earlier patches in the series have some small fixes
> and helpers in preparation, and the final four small patches do some
> cleanup.

Series applied, thanks.
