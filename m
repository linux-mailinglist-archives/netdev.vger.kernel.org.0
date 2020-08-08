Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1786123F576
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 02:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgHHAXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 20:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgHHAXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 20:23:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A12C061A28
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 17:23:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 347D71276E0D9;
        Fri,  7 Aug 2020 17:06:37 -0700 (PDT)
Date:   Fri, 07 Aug 2020 17:23:21 -0700 (PDT)
Message-Id: <20200807.172321.1351420945383297003.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH net] selftests: mptcp: fix dependecies
From:   David Miller <davem@davemloft.net>
In-Reply-To: <781f07aa4d05b123a80bf98f5839e1611a833272.1596791966.git.pabeni@redhat.com>
References: <781f07aa4d05b123a80bf98f5839e1611a833272.1596791966.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Aug 2020 17:06:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Fri,  7 Aug 2020 11:32:04 +0200

> Since commit df62f2ec3df6 ("selftests/mptcp: add diag interface tests")
> the MPTCP selftests relies on the MPTCP diag interface which is
> enabled by a specific kconfig knob: be sure to include it.
> 
> Fixes: df62f2ec3df6 ("selftests/mptcp: add diag interface tests")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied, thanks!
