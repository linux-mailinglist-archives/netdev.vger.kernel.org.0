Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93F6234D9E
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 00:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgGaWiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 18:38:20 -0400
Received: from mga06.intel.com ([134.134.136.31]:5674 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbgGaWiU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 18:38:20 -0400
IronPort-SDR: HSxB3MlwJjhOasJOUHjfca/eRVjiYCYEDFuy1307JyDMYd8E5JPID15Tj3K8m4MGjj8yBzIMot
 u0koFcj1OPkQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="213417723"
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="213417723"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 15:38:19 -0700
IronPort-SDR: O1yhDuk44qjwB55R5prj7Toc8jf/5pcXitnY3M8bBaFFZArgAzCafOg4T/qjOkNi8nLK6zSnzT
 iz4AL2G3luRw==
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="287330795"
Received: from nataliet-mobl.amr.corp.intel.com ([10.254.79.31])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 15:38:19 -0700
Date:   Fri, 31 Jul 2020 15:38:19 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@nataliet-mobl.amr.corp.intel.com
To:     Florian Westphal <fw@strlen.de>
cc:     netdev@vger.kernel.org, edumazet@google.com,
        matthieu.baerts@tessares.net, pabeni@redhat.com
Subject: Re: [PATCH v2 net-next 4/9] mptcp: rename and export
 mptcp_subflow_request_sock_ops
In-Reply-To: <20200730192558.25697-5-fw@strlen.de>
Message-ID: <alpine.OSX.2.23.453.2007311538010.30834@nataliet-mobl.amr.corp.intel.com>
References: <20200730192558.25697-1-fw@strlen.de> <20200730192558.25697-5-fw@strlen.de>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jul 2020, Florian Westphal wrote:

> syncookie code path needs to create an mptcp request sock.
>
> Prepare for this and add mptcp prefix plus needed export of ops struct.
>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
> include/net/mptcp.h |  1 +
> net/mptcp/subflow.c | 11 ++++++-----
> 2 files changed, 7 insertions(+), 5 deletions(-)

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
