Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2C2D57A468
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 18:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236076AbiGSQ4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 12:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236181AbiGSQ4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 12:56:15 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42CF84E842;
        Tue, 19 Jul 2022 09:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658249774; x=1689785774;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=fme5LROzlV8l/fNFEXKRx2eWQvLe0mfWfzSOKn+4C0I=;
  b=YGeCNhXLY5KdGiQuM+ZRAT44+hzn59ez111kW3zhly4rFpoU6pYkUWId
   mhzg/FZ/h8RrjlPRdwvnNwcJfmpJVv4FFxMKAOfyQIAdhusExoze0YkyL
   XHxM8UxysnOWy49NuMa+MtFkGZVaIgRmF/q2RZomrjMfBePGUqNWkWfJJ
   erCsHSHRHtgrDTWZ7A7LGbg0Tb6N459mitfNPPdVNkFfG/GaT8CdeW0IM
   FSOhDL62rgkhIrLFNgZpFQWN1yiu0u7rhjoiNytHpsJnYOkYXJa+bFPjr
   H3lsQbhFWsXaTJkaxTq3LXnezc4QHsogkJf5Vil2i62NhwsUEAT3fFmWb
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="266942180"
X-IronPort-AV: E=Sophos;i="5.92,284,1650956400"; 
   d="scan'208";a="266942180"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 09:56:12 -0700
X-IronPort-AV: E=Sophos;i="5.92,284,1650956400"; 
   d="scan'208";a="625270322"
Received: from nhanhan-mobl.amr.corp.intel.com ([10.209.102.198])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 09:56:12 -0700
Date:   Tue, 19 Jul 2022 09:56:12 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Jason Wang <wangborong@cdjrlc.com>
cc:     matthieu.baerts@tessares.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mptcp: Fix comment typo
In-Reply-To: <20220716044226.43587-1-wangborong@cdjrlc.com>
Message-ID: <1414d684-8881-5b2a-4824-e3c4488e862@linux.intel.com>
References: <20220716044226.43587-1-wangborong@cdjrlc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Sat, 16 Jul 2022, Jason Wang wrote:

> The double `the' is duplicated in the comment, remove one.
>
> Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
> ---
> net/mptcp/token.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/mptcp/token.c b/net/mptcp/token.c
> index f52ee7b26aed..68b822691e36 100644
> --- a/net/mptcp/token.c
> +++ b/net/mptcp/token.c
> @@ -288,7 +288,7 @@ EXPORT_SYMBOL_GPL(mptcp_token_get_sock);
>  * token container starting from the specified position, or NULL.
>  *
>  * On successful iteration, the iterator is move to the next position and the

Two more changes are needed in the line above:

move -> moved
the -> then

Thanks for the contribution.

> - * the acquires a reference to the returned socket.
> + * acquires a reference to the returned socket.
>  */
> struct mptcp_sock *mptcp_token_iter_next(const struct net *net, long *s_slot,
> 					 long *s_num)
> -- 
> 2.35.1
>
>

--
Mat Martineau
Intel
