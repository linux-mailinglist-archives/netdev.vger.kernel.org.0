Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7362C92F1
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 00:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387812AbgK3Xou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 18:44:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:48836 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729627AbgK3Xot (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 18:44:49 -0500
IronPort-SDR: y683ctrYcJrvehuCh/wzfb7GLslDJl4ea2AEQlRqyWfaxtGX/O7t8fmRRiDyDgOC/ZkX6UFQtr
 Pso7EEM3u7XA==
X-IronPort-AV: E=McAfee;i="6000,8403,9821"; a="172890369"
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="172890369"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 15:43:08 -0800
IronPort-SDR: 0IUqejnO6BKWSAWA/3Yp6W5QY+1gg8le1IZy7OaOFWxeP4eYJcn8PlhGWw71qkOQxZjnqL0Pma
 uqM8rMCoKK7w==
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="480855355"
Received: from cdhirema-mobl5.amr.corp.intel.com ([10.254.71.173])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 15:43:08 -0800
Date:   Mon, 30 Nov 2020 15:43:07 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        mptcp@lists.01.org, Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 1/6] mptcp: open code mptcp variant for
 lock_sock
In-Reply-To: <fd92953c74dde2aa43d34fcdb681392f1a481d1a.1606413118.git.pabeni@redhat.com>
Message-ID: <97e78fe-e4aa-cf9f-f76f-1746df5b5eb4@linux.intel.com>
References: <cover.1606413118.git.pabeni@redhat.com> <fd92953c74dde2aa43d34fcdb681392f1a481d1a.1606413118.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Nov 2020, Paolo Abeni wrote:

> This allows invoking an additional callback under the
> socket spin lock.
>
> Will be used by the next patches to avoid additional
> spin lock contention.
>
> Acked-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> include/net/sock.h   |  1 +
> net/core/sock.c      |  2 +-
> net/mptcp/protocol.h | 13 +++++++++++++
> 3 files changed, 15 insertions(+), 1 deletion(-)

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
