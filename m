Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5E7234DA2
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 00:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgGaWju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 18:39:50 -0400
Received: from mga12.intel.com ([192.55.52.136]:34770 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgGaWju (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 18:39:50 -0400
IronPort-SDR: lP1X6wZKym8VQcEgd8BXJZf7rtnBH37z6QD/kAETEUG57Dfbl57PSyUCfhoBvUQNJiJ3/24wH/
 v/P2oImtiBXw==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="131448867"
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="131448867"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 15:39:50 -0700
IronPort-SDR: a7uTiEW5oLKFKd+L0jidMaX+QqiKtFT1XV6LkKGQC8iQSJ5mhhfFMRth34I8wwYfJkYUdWBHxI
 7rPe2r7i9+LQ==
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="287331518"
Received: from nataliet-mobl.amr.corp.intel.com ([10.254.79.31])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 15:39:49 -0700
Date:   Fri, 31 Jul 2020 15:39:49 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@nataliet-mobl.amr.corp.intel.com
To:     Florian Westphal <fw@strlen.de>
cc:     netdev@vger.kernel.org, edumazet@google.com,
        matthieu.baerts@tessares.net, pabeni@redhat.com
Subject: Re: [PATCH v2 net-next 9/9] selftests: mptcp: add test cases for
 mptcp join tests with syn cookies
In-Reply-To: <20200730192558.25697-10-fw@strlen.de>
Message-ID: <alpine.OSX.2.23.453.2007311539340.30834@nataliet-mobl.amr.corp.intel.com>
References: <20200730192558.25697-1-fw@strlen.de> <20200730192558.25697-10-fw@strlen.de>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jul 2020, Florian Westphal wrote:

> Also add test cases with MP_JOIN when tcp_syncookies sysctl is 2 (i.e.,
> syncookies are always-on).
>
> While at it, also print the test number and add the test number
> to the pcap files that can be generated optionally.
>
> This makes it easier to match the pcap to the test case.
>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
> .../testing/selftests/net/mptcp/mptcp_join.sh | 66 ++++++++++++++++++-
> 1 file changed, 64 insertions(+), 2 deletions(-)

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
