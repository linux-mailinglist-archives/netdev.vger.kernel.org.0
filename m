Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C34F2AF884
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 19:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727292AbgKKStX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 13:49:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:47344 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726460AbgKKStW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 13:49:22 -0500
IronPort-SDR: T1wLCwdut8NaWugLt3A4CO4/g53RGujLZM+rQiL6RuxJ8kszsdFZREtja8kMdnzK9J8E9sRo6J
 glRrM7pdN9Ew==
X-IronPort-AV: E=McAfee;i="6000,8403,9802"; a="170362578"
X-IronPort-AV: E=Sophos;i="5.77,470,1596524400"; 
   d="scan'208";a="170362578"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2020 10:49:21 -0800
IronPort-SDR: TiF3SoCyDQmKQoegLE8eXd23N1ySpKy12U9bQ8jsLajrLqclQiB179AIUgHB41XAwFOTTWEkHw
 ujpi/m2viFCQ==
X-IronPort-AV: E=Sophos;i="5.77,470,1596524400"; 
   d="scan'208";a="339148549"
Received: from dnminiba-mobl1.amr.corp.intel.com ([10.251.19.220])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2020 10:49:20 -0800
Date:   Wed, 11 Nov 2020 10:49:20 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Colin King <colin.king@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S . Miller" <davem@davemloft.net>,
        Geliang Tang <geliangtang@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] mptcp: fix a dereference of pointer before msk is
 null checked.
In-Reply-To: <20201109125215.2080172-1-colin.king@canonical.com>
Message-ID: <cb9fba1-b399-325f-c956-ede9da1b1b7@linux.intel.com>
References: <20201109125215.2080172-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Nov 2020, Colin King wrote:

> From: Colin Ian King <colin.king@canonical.com>
>
> Currently the assignment of pointer net from the sock_net(sk) call
> is potentially dereferencing a null pointer sk. sk points to the
> same location as pointer msk and msk is being null checked after
> the sock_net call.  Fix this by calling sock_net after the null
> check on pointer msk.
>
> Addresses-Coverity: ("Dereference before null check")
> Fixes: 00cfd77b9063 ("mptcp: retransmit ADD_ADDR when timeout")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
> net/mptcp/pm_netlink.c | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)
>

Hi Colin and Jakub -

I noticed that the follow-up discussion on this patch didn't go to the 
netdev list, so patchwork did not get updated.

This patch is superseded by the following, which already has a Reviewed-by 
tag from Matthieu:

http://patchwork.ozlabs.org/project/netdev/patch/078a2ef5bdc4e3b2c25ef852461692001f426495.1604976945.git.geliangtang@gmail.com/


Thanks!

--
Mat Martineau
Intel
