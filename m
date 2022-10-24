Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC9060BEEA
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 01:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiJXXru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 19:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbiJXXrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 19:47:23 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F26B333A99;
        Mon, 24 Oct 2022 15:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666649143; x=1698185143;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=o6EZzwIuG3lKm3iYYLguTM9aIweOE9YaLFfrddeogvQ=;
  b=JSAlA28t+zRSMp7brm9wAvbGLSot1N6vAtV9X1gENmJitJG0XcAuQodx
   uhmAn0YOa2oeelVHC+1mvqIjqV884Knerdlo8GJt3JiqZwhtWrZT4dhjj
   ZTsldpc0jtyZ7Dt3S5mRii9zmMkoNNuWzC5F1oO+NAVeXQlT5Zgn6hDUA
   pf1oqxc+CVTgimJdLtNIb7S4gSHGjlH/VZ8DXgfLGTCTcIzuN6Ud/56G/
   nh5/9fN4JQcpo0I63XbVcPUlPFcDbfpRcF4SJRx+JWCzV+DgJmvYcmWxP
   oH816q76umeuMABVB7q9frzcK/Ut/wv19v7Dw7iBbl6Fc+QaFYZ91z3Fr
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="305144607"
X-IronPort-AV: E=Sophos;i="5.95,210,1661842800"; 
   d="scan'208";a="305144607"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 15:04:29 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="631415597"
X-IronPort-AV: E=Sophos;i="5.95,210,1661842800"; 
   d="scan'208";a="631415597"
Received: from mlotfi-mobl.amr.corp.intel.com ([10.212.254.208])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 15:04:29 -0700
Date:   Mon, 24 Oct 2022 15:04:28 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     wangjianli <wangjianli@cdjrlc.com>
cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mptcp: fix repeated words in comments
In-Reply-To: <Y1VF1DBYePbkTk8x@debian.me>
Message-ID: <162b5545-7d24-3cf2-9158-3100ef644e03@linux.intel.com>
References: <20221022070527.55960-1-wangjianli@cdjrlc.com> <Y1VF1DBYePbkTk8x@debian.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 23 Oct 2022, Bagas Sanjaya wrote:

> On Sat, Oct 22, 2022 at 03:05:27PM +0800, wangjianli wrote:
>> Delete the redundant word 'the'.
>>
>> Signed-off-by: wangjianli <wangjianli@cdjrlc.com>
>> ---
>>  net/mptcp/token.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/mptcp/token.c b/net/mptcp/token.c
>> index f52ee7b26aed..b817c2564300 100644
>> --- a/net/mptcp/token.c
>> +++ b/net/mptcp/token.c
>> @@ -287,7 +287,7 @@ EXPORT_SYMBOL_GPL(mptcp_token_get_sock);
>>   * This function returns the first mptcp connection structure found inside the
>>   * token container starting from the specified position, or NULL.
>>   *
>> - * On successful iteration, the iterator is move to the next position and the
>> + * On successful iteration, the iterator is move to the next position and
>>   * the acquires a reference to the returned socket.
>>   */
>>  struct mptcp_sock *mptcp_token_iter_next(const struct net *net, long *s_slot,
>
> NAK!
>
> Instead, slightly reword the comment above as "On successful iteration,
> the iterator moves to the next position and acquires a reference to the
> returned socket.".
>

Agree on this rewording.

This particular duplicated word came up before, and I thought it would be 
best if the author sent a v2 - but they never did. I will fix this in the 
MPTCP tree next week if there's no suitable v2 by then.

--
Mat Martineau
Intel
