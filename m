Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98EF22F87C
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 20:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgG0SwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 14:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgG0SwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 14:52:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280AAC061794;
        Mon, 27 Jul 2020 11:52:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 38B46126BCA48;
        Mon, 27 Jul 2020 11:35:34 -0700 (PDT)
Date:   Mon, 27 Jul 2020 11:52:18 -0700 (PDT)
Message-Id: <20200727.115218.1191292272155021831.davem@davemloft.net>
To:     matthieu.baerts@tessares.net
Cc:     netdev@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        kuba@kernel.org, pabeni@redhat.com, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] mptcp: fix joined subflows with unblocking sk
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200727102433.3422117-1-matthieu.baerts@tessares.net>
References: <20200727102433.3422117-1-matthieu.baerts@tessares.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jul 2020 11:35:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Mon, 27 Jul 2020 12:24:33 +0200

> Unblocking sockets used for outgoing connections were not containing
> inet info about the initial connection due to a typo there: the value of
> "err" variable is negative in the kernelspace.
> 
> This fixes the creation of additional subflows where the remote port has
> to be reused if the other host didn't announce another one. This also
> fixes inet_diag showing blank info about MPTCP sockets from unblocking
> sockets doing a connect().
> 
> Fixes: 41be81a8d3d0 ("mptcp: fix unblocking connect()")
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Applied, thanks!
