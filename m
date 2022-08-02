Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E664588427
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 00:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235806AbiHBWVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 18:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235771AbiHBWVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 18:21:36 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61D352475;
        Tue,  2 Aug 2022 15:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659478894; x=1691014894;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=RRl8Wr0Hdlu6OVTnv0N+8fa2YKugeYr1fvxmaKZlk3U=;
  b=dnBaZG1USJ2jKdEuZLs6fDWqwEfWxHKx7nQSJD4rwYbz2S5iJmSpKR2b
   c0J270sYJi3O/fzb8jdiaIZ6zwIhA5PbIZ56CiQdL5Tz2s2bnHhAMgzbZ
   q6KSpVruBfmxUwC23cdvJREM2lVNoVG4yOU1sDUSbTpXg0EJkf2g/Rymg
   DWMr5hx12y7JQdhxKonjiKvRWtkJW3+JeHqBsIc+YjaBoQsLMCYtvkn4S
   fA76BiOywu4DQ3nnV/0jrroVhjW951Qi/N37Rf9O9uMawy9D/20/C5KME
   Dv0v3dg3JHy1cQTMMjZBt7Hsy60kCa2GNaSFzCCaRbsIyMYzzg/RKZmuf
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10427"; a="287091229"
X-IronPort-AV: E=Sophos;i="5.93,212,1654585200"; 
   d="scan'208";a="287091229"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 15:21:34 -0700
X-IronPort-AV: E=Sophos;i="5.93,212,1654585200"; 
   d="scan'208";a="553086889"
Received: from dnrajurk-mobl.amr.corp.intel.com ([10.209.121.166])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 15:21:34 -0700
Date:   Tue, 2 Aug 2022 15:21:34 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Xie Shaowen <studentxswpy@163.com>
cc:     matthieu.baerts@tessares.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org,
        Hacash Robot <hacashRobot@santino.com>
Subject: Re: [PATCH net-next] mptcp: Fix spelling mistakes and cleanup code
In-Reply-To: <20220730090617.3101386-1-studentxswpy@163.com>
Message-ID: <8dbc125-5396-fe56-99a1-c94b27c8938e@linux.intel.com>
References: <20220730090617.3101386-1-studentxswpy@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 30 Jul 2022, studentxswpy@163.com wrote:

> From: Xie Shaowen <studentxswpy@163.com>
>
> fix follow spelling misktakes:
> 	regarless ==> regardless
> 	interaces ==> interfaces
>
> Reported-by: Hacash Robot <hacashRobot@santino.com>
> Signed-off-by: Xie Shaowen <studentxswpy@163.com>

Hello Xie Shaowen -

These spelling errors were already fixed in commit d640516a65d8, merged 
2022-06-28. Please make sure to work from an up-to-date branch!


Thanks for your patch,

Mat



> ---
> net/mptcp/pm_netlink.c | 2 +-
> net/mptcp/subflow.c    | 2 +-
> 2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
> index 7c7395b58944..5bdb559d5242 100644
> --- a/net/mptcp/pm_netlink.c
> +++ b/net/mptcp/pm_netlink.c
> @@ -1134,7 +1134,7 @@ void mptcp_pm_nl_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ss
> 			}
> 			unlock_sock_fast(ssk, slow);
>
> -			/* always try to push the pending data regarless of re-injections:
> +			/* always try to push the pending data regardless of re-injections:
> 			 * we can possibly use backup subflows now, and subflow selection
> 			 * is cheap under the msk socket lock
> 			 */
> diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
> index af28f3b60389..901c763dcdbb 100644
> --- a/net/mptcp/subflow.c
> +++ b/net/mptcp/subflow.c
> @@ -1634,7 +1634,7 @@ int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
> 	/* the newly created socket really belongs to the owning MPTCP master
> 	 * socket, even if for additional subflows the allocation is performed
> 	 * by a kernel workqueue. Adjust inode references, so that the
> -	 * procfs/diag interaces really show this one belonging to the correct
> +	 * procfs/diag interfaces really show this one belonging to the correct
> 	 * user.
> 	 */
> 	SOCK_INODE(sf)->i_ino = SOCK_INODE(sk->sk_socket)->i_ino;
> -- 
> 2.25.1
>
>

--
Mat Martineau
Intel
