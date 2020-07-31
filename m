Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD179234D9D
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 00:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgGaWh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 18:37:57 -0400
Received: from mga04.intel.com ([192.55.52.120]:35357 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbgGaWh5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 18:37:57 -0400
IronPort-SDR: 7K0sNykyyH/Et+nb1iNRtKq6Bg3Q2SpeZTbxitmdQHsXsMiqxbGq1+9Z+WDZiqb9ti0OZv+lH0
 AhdOuSI5kwHg==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="149332632"
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="149332632"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 15:37:57 -0700
IronPort-SDR: 8LLtfgiM3oMOP0OM5OtYfoTOb/jWQn7Mm1GRieQR93bHBEs9igS3gvCOBrJtxO+argmTyNMIFw
 g/V5PbixwuEQ==
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="287330667"
Received: from nataliet-mobl.amr.corp.intel.com ([10.254.79.31])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 15:37:57 -0700
Date:   Fri, 31 Jul 2020 15:37:56 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@nataliet-mobl.amr.corp.intel.com
To:     Florian Westphal <fw@strlen.de>
cc:     netdev@vger.kernel.org, edumazet@google.com,
        matthieu.baerts@tessares.net, pabeni@redhat.com
Subject: Re: [PATCH v2 net-next 3/9] mptcp: subflow: split subflow_init_req
In-Reply-To: <20200730192558.25697-4-fw@strlen.de>
Message-ID: <alpine.OSX.2.23.453.2007311537360.30834@nataliet-mobl.amr.corp.intel.com>
References: <20200730192558.25697-1-fw@strlen.de> <20200730192558.25697-4-fw@strlen.de>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jul 2020, Florian Westphal wrote:

> When syncookie support is added, we will need to add a variant of
> subflow_init_req() helper.  It will do almost same thing except
> that it will not compute/add a token to the mptcp token tree.
>
> To avoid excess copy&paste, this commit splits away part of the
> code into a new helper, __subflow_init_req, that can then be re-used
> from the 'no insert' function added in a followup change.
>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
> net/mptcp/subflow.c | 32 ++++++++++++++++++++++----------
> 1 file changed, 22 insertions(+), 10 deletions(-)
>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
