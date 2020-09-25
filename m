Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1C6277E75
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 05:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgIYDRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 23:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbgIYDRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 23:17:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A40FC0613CE
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 20:17:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 05214135FCBB0;
        Thu, 24 Sep 2020 20:00:29 -0700 (PDT)
Date:   Thu, 24 Sep 2020 20:17:16 -0700 (PDT)
Message-Id: <20200924.201716.624683761190940050.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: tcp: drop unused function argument from
 mptcp_incoming_options
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200924232302.22939-1-fw@strlen.de>
References: <20200924232302.22939-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 24 Sep 2020 20:00:30 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Fri, 25 Sep 2020 01:23:02 +0200

> Since commit cfde141ea3faa30e ("mptcp: move option parsing into
> mptcp_incoming_options()"), the 3rd function argument is no longer used.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied, thanks Florian.
