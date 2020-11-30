Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C0B2C92F9
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 00:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730621AbgK3Xpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 18:45:55 -0500
Received: from mga05.intel.com ([192.55.52.43]:51667 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728509AbgK3Xpy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 18:45:54 -0500
IronPort-SDR: uIDDEzgIo1BDpUhAI6BsC8LJzdYGV1B/m7FecsHU4jJLF0+I44LjuqSqJdkY8kwCF07Tc6lvXY
 JO/ct30XabPA==
X-IronPort-AV: E=McAfee;i="6000,8403,9821"; a="257441107"
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="257441107"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 15:44:14 -0800
IronPort-SDR: Q4yrFjSk58UJJTwmQ5A2aSWX+/0eLKJWmHtSiUCDgvOo2a4MyMWQ5gsZTx8u+hiNge+kNO2jV8
 nywh+DAD4tPQ==
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="480855685"
Received: from cdhirema-mobl5.amr.corp.intel.com ([10.254.71.173])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 15:44:14 -0800
Date:   Mon, 30 Nov 2020 15:44:13 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        mptcp@lists.01.org, Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 4/6] mptcp: allocate TX skbs in msk context
In-Reply-To: <2c4eacb182281d8e65cf4cf521e05141e6b011c8.1606413118.git.pabeni@redhat.com>
Message-ID: <1d213fb6-34a4-668e-e972-47e11f7061b@linux.intel.com>
References: <cover.1606413118.git.pabeni@redhat.com> <2c4eacb182281d8e65cf4cf521e05141e6b011c8.1606413118.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Nov 2020, Paolo Abeni wrote:

> Move the TX skbs allocation in mptcp_sendmsg() scope,
> and tentatively pre-allocate a skbs number proportional
> to the sendmsg() length.
>
> Use the ssk tx skb cache to prevent the subflow allocation.
>
> This allows removing the msk skb extension cache and will
> make possible the later patches.
>
> Acked-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/protocol.c | 248 ++++++++++++++++++++++++++++++++++++-------
> net/mptcp/protocol.h |   4 +-
> 2 files changed, 210 insertions(+), 42 deletions(-)

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
