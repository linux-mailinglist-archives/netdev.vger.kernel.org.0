Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAFB82C92FA
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 00:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbgK3Xqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 18:46:37 -0500
Received: from mga12.intel.com ([192.55.52.136]:40000 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbgK3Xqg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 18:46:36 -0500
IronPort-SDR: 6CHJ16Bo+JU0xsPkx2bxzwNyuvLeGqmCZNApl7VcrNF1IFZ9JU3R8TQJyZCcYABtpwoyk8anh7
 gRp/BuLkXNKg==
X-IronPort-AV: E=McAfee;i="6000,8403,9821"; a="151984997"
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="151984997"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 15:44:56 -0800
IronPort-SDR: O01TZlnHsGEuDYR+LT0SQzIkOgjBKtCKrWuWJq4Xx4LZQQM1eVpe2XVPambI7viU6xLumRudZ+
 cLO871bfkzSg==
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="480855930"
Received: from cdhirema-mobl5.amr.corp.intel.com ([10.254.71.173])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 15:44:55 -0800
Date:   Mon, 30 Nov 2020 15:44:54 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        mptcp@lists.01.org, Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 5/6] mptcp: avoid a few atomic ops in the rx
 path
In-Reply-To: <46e049b7bf734ed50f5b3c3762ee0278a682c66e.1606413118.git.pabeni@redhat.com>
Message-ID: <e9ef28f7-814a-1a86-9337-a7d2eddb7754@linux.intel.com>
References: <cover.1606413118.git.pabeni@redhat.com> <46e049b7bf734ed50f5b3c3762ee0278a682c66e.1606413118.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Nov 2020, Paolo Abeni wrote:

> Extending the data_lock scope in mptcp_incoming_option
> we can use that to protect both snd_una and wnd_end.
> In the typical case, we will have a single atomic op instead of 2
>
> Acked-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/mptcp_diag.c |  2 +-
> net/mptcp/options.c    | 33 +++++++++++++--------------------
> net/mptcp/protocol.c   | 34 ++++++++++++++++------------------
> net/mptcp/protocol.h   |  8 ++++----
> 4 files changed, 34 insertions(+), 43 deletions(-)

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
