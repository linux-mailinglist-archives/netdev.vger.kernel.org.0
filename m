Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74ABB234D9B
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 00:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgGaWhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 18:37:33 -0400
Received: from mga12.intel.com ([192.55.52.136]:34569 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbgGaWhd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 18:37:33 -0400
IronPort-SDR: mdc61U9yKQ1ds7M/JSebItXNHyGwxdmAVmV3KV/VyqWgF/XyquoLwjg2/eDMI3guO+7QH1e7C7
 cZKet1WavyUA==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="131448659"
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="131448659"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 15:37:32 -0700
IronPort-SDR: 40U6QHsqXUMyCi9LobOLL9klN9PsRbzbFk0pDYt5o2KJOdjcMq4ojejjNWv1WMAbYhlQUDPDkg
 Qygw5cRwMtjQ==
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="287330582"
Received: from nataliet-mobl.amr.corp.intel.com ([10.254.79.31])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 15:37:31 -0700
Date:   Fri, 31 Jul 2020 15:37:31 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@nataliet-mobl.amr.corp.intel.com
To:     Florian Westphal <fw@strlen.de>
cc:     netdev@vger.kernel.org, edumazet@google.com,
        matthieu.baerts@tessares.net, pabeni@redhat.com
Subject: Re: [PATCH v2 net-next 2/9] mptcp: token: move retry to caller
In-Reply-To: <20200730192558.25697-3-fw@strlen.de>
Message-ID: <alpine.OSX.2.23.453.2007311536500.30834@nataliet-mobl.amr.corp.intel.com>
References: <20200730192558.25697-1-fw@strlen.de> <20200730192558.25697-3-fw@strlen.de>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jul 2020, Florian Westphal wrote:

> Once syncookie support is added, no state will be stored anymore when the
> syn/ack is generated in syncookie mode.
>
> When the ACK comes back, the generated key will be taken from the TCP ACK,
> the token is re-generated and inserted into the token tree.
>
> This means we can't retry with a new key when the token is already taken
> in the syncookie case.
>
> Therefore, move the retry logic to the caller to prepare for syncookie
> support in mptcp.
>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
> net/mptcp/subflow.c |  9 ++++++++-
> net/mptcp/token.c   | 12 ++++--------
> 2 files changed, 12 insertions(+), 9 deletions(-)

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
