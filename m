Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973772CB027
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbgLAWfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 17:35:03 -0500
Received: from mga06.intel.com ([134.134.136.31]:7409 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbgLAWfD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 17:35:03 -0500
IronPort-SDR: xL86DM7S0klMRj0dOSmH7OA6M/PgfEzf5wpE12yNUBjUPnYAZItrCy2D50gMMu6nhpM+czabmj
 VPKAlctKN7aA==
X-IronPort-AV: E=McAfee;i="6000,8403,9822"; a="234524147"
X-IronPort-AV: E=Sophos;i="5.78,385,1599548400"; 
   d="scan'208";a="234524147"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2020 14:33:21 -0800
IronPort-SDR: sn6OsZFfdmDox/L5WQ7PtZ7dAK0f3pUnNbsyCLplVUQ0yOcaGhfuUcSF8zkLzvNA5Xg2HtM8kA
 nu9Zzu3d8tKQ==
X-IronPort-AV: E=Sophos;i="5.78,385,1599548400"; 
   d="scan'208";a="539309683"
Received: from smshah3-mobl2.amr.corp.intel.com ([10.254.106.19])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2020 14:33:21 -0800
Date:   Tue, 1 Dec 2020 14:33:20 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Florian Westphal <fw@strlen.de>
cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-security-module@vger.kernel.org
Subject: Re: [MPTCP] [PATCH net-next 3/3] mptcp: emit tcp reset when a join
 request fails
In-Reply-To: <20201130153631.21872-4-fw@strlen.de>
Message-ID: <73ccf7ca-258c-475-c7e8-7ee9d1a2d94@linux.intel.com>
References: <20201130153631.21872-1-fw@strlen.de> <20201130153631.21872-4-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Nov 2020, Florian Westphal wrote:

> RFC 8684 says:
> If the token is unknown or the host wants to refuse subflow establishment
> (for example, due to a limit on the number of subflows it will permit),
> the receiver will send back a reset (RST) signal, analogous to an unknown
> port in TCP, containing an MP_TCPRST option (Section 3.6) with an
> "MPTCP specific error" reason code.
>
> mptcp-next doesn't support MP_TCPRST yet, this can be added in another
> change.
>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
> net/mptcp/subflow.c | 47 ++++++++++++++++++++++++++++++++++-----------
> 1 file changed, 36 insertions(+), 11 deletions(-)
>

Thanks for the patch, Florian. Hopefully the first two in the series are 
ok with those maintainers, and for this one I can add:

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
