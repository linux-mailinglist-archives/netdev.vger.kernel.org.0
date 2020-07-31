Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0176234DA1
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 00:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgGaWj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 18:39:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:12481 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgGaWj3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 18:39:29 -0400
IronPort-SDR: uBl+jH5UnwDgGv0S/lsA0d0EkwrekStWXVtwUxJx6/CvNGejhKr3/PtsA3AnnJ/aFKIcv4clpA
 WAP4civDEdbw==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="149696247"
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="149696247"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 15:39:29 -0700
IronPort-SDR: ngb5LZJqExQBjfamSp88KN7FX9ypv9kuXNQ4KRM1eVcwaevhmRJiJK+3xTEMEbebxdciu0G6Gm
 z8LiKz7PKckw==
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="287331347"
Received: from nataliet-mobl.amr.corp.intel.com ([10.254.79.31])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 15:39:28 -0700
Date:   Fri, 31 Jul 2020 15:39:28 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@nataliet-mobl.amr.corp.intel.com
To:     Florian Westphal <fw@strlen.de>
cc:     netdev@vger.kernel.org, edumazet@google.com,
        matthieu.baerts@tessares.net, pabeni@redhat.com
Subject: Re: [PATCH v2 net-next 8/9] selftests: mptcp: make 2nd net namespace
 use tcp syn cookies unconditionally
In-Reply-To: <20200730192558.25697-9-fw@strlen.de>
Message-ID: <alpine.OSX.2.23.453.2007311539160.30834@nataliet-mobl.amr.corp.intel.com>
References: <20200730192558.25697-1-fw@strlen.de> <20200730192558.25697-9-fw@strlen.de>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jul 2020, Florian Westphal wrote:

> check we can establish connections also when syn cookies are in use.
>
> Check that
> MPTcpExtMPCapableSYNRX and MPTcpExtMPCapableACKRX increase for each
> MPTCP test.
>
> Check TcpExtSyncookiesSent and TcpExtSyncookiesRecv increase in netns2.
>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
> .../selftests/net/mptcp/mptcp_connect.sh      | 47 +++++++++++++++++++
> 1 file changed, 47 insertions(+)

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
