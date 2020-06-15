Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 592B51F9BE0
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 17:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730477AbgFOPV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 11:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730158AbgFOPV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 11:21:57 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8582C061A0E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 08:21:56 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jkqvk-0008TB-Ob; Mon, 15 Jun 2020 17:21:48 +0200
Date:   Mon, 15 Jun 2020 17:21:48 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        fw@strlen.de
Subject: Re: [PATCH net] net: core: reduce recursion limit value
Message-ID: <20200615152148.GE16460@breakpoint.cc>
References: <20200615150037.21529-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200615150037.21529-1-ap420073@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Taehee Yoo <ap420073@gmail.com> wrote:
> In the current code, ->ndo_start_xmit() can be executed recursively only
> 10 times because of stack memory.
> But, in the case of the vxlan, 10 recursion limit value results in
> a stack overflow.
[..]

> Fixes: 97cdcf37b57e ("net: place xmit recursion in softnet data")

That commit did not change the recursion limit,
11a766ce915fc9f86 ("net: Increase xmit RECURSION_LIMIT to 10.") did?
