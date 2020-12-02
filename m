Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 592DB2CC636
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 20:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbgLBTHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 14:07:52 -0500
Received: from mga06.intel.com ([134.134.136.31]:55028 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727454AbgLBTHw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 14:07:52 -0500
IronPort-SDR: RLJ7bJf8iDjuEYUWQCxdUD+BnGyAHQxk82A6bOH6qcCiChaQhjg817cn9mOLNHW5QxwkhMaiuA
 KPhdOJ/gCVfQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9823"; a="234677270"
X-IronPort-AV: E=Sophos;i="5.78,387,1599548400"; 
   d="scan'208";a="234677270"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2020 11:06:11 -0800
IronPort-SDR: E/sRQGC6KwsnS/HGSbtl1PBoK8VMw5qNMVAG4R921pvfite1KNduYVcLYKX/K2DONhdbAUhClu
 WvQoW0CTU7zw==
X-IronPort-AV: E=Sophos;i="5.78,387,1599548400"; 
   d="scan'208";a="316196419"
Received: from icenteno-mobl1.amr.corp.intel.com ([10.251.24.90])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2020 11:06:11 -0800
Date:   Wed, 2 Dec 2020 11:06:10 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next] mptcp: avoid potential infinite loop in
 mptcp_recvmsg()
In-Reply-To: <20201202171657.1185108-1-eric.dumazet@gmail.com>
Message-ID: <547dd077-bcfc-cf42-9278-e388b3af1ac8@linux.intel.com>
References: <20201202171657.1185108-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Dec 2020, Eric Dumazet wrote:

> From: Eric Dumazet <edumazet@google.com>
>
> If a packet is ready in receive queue, and application isssues
> a recvmsg()/recvfrom()/recvmmsg() request asking for zero bytes,
> we hang in mptcp_recvmsg().
>
> Fixes: ea4ca586b16f ("mptcp: refine MPTCP-level ack scheduling")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/protocol.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks for catching this Eric.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
