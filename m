Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74A75244EF0
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 21:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgHNTsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 15:48:19 -0400
Received: from mga12.intel.com ([192.55.52.136]:22055 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbgHNTsS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 15:48:18 -0400
IronPort-SDR: KmZONe2E7z7H44lXCPzC3SmzPhKelNKFGGCEPQfi/e0w5fTE8ekWajUoK0uhxYTGk/0VzQJqwi
 GYaqsvN9VjyA==
X-IronPort-AV: E=McAfee;i="6000,8403,9713"; a="134001312"
X-IronPort-AV: E=Sophos;i="5.76,313,1592895600"; 
   d="scan'208";a="134001312"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2020 12:48:18 -0700
IronPort-SDR: KTh8e2xzju8NbVtcMbxBTMQzUfRrdycN0zRTfqx65IAIDUpe+RhLBE15K+RaG4+hMaLh14Mxy3
 mlw5urZAJ0KQ==
X-IronPort-AV: E=Sophos;i="5.76,313,1592895600"; 
   d="scan'208";a="440210759"
Received: from cakenne1-mobl1.amr.corp.intel.com ([10.251.27.100])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2020 12:48:17 -0700
Date:   Fri, 14 Aug 2020 12:48:17 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@cakenne1-mobl1.amr.corp.intel.com
To:     Florian Westphal <fw@strlen.de>
cc:     netdev@vger.kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.01.org
Subject: Re: [PATCH net] mptcp: sendmsg: reset iter on error
In-Reply-To: <20200814135634.12996-1-fw@strlen.de>
Message-ID: <alpine.OSX.2.23.453.2008141245480.20141@cakenne1-mobl1.amr.corp.intel.com>
References: <20200814135634.12996-1-fw@strlen.de>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Aug 2020, Florian Westphal wrote:

> Once we've copied data from the iterator we need to revert in case we
> end up not sending any data.
>
> This bug doesn't trigger with normal 'poll' based tests, because
> we only feed a small chunk of data to kernel after poll indicated
> POLLOUT.  With blocking IO and large writes this triggers. Receiver
> ends up with less data than it should get.
>
> Fixes: 72511aab95c94d ("mptcp: avoid blocking in tcp_sendpages")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
> net/mptcp/protocol.c | 8 ++++++--
> 1 file changed, 6 insertions(+), 2 deletions(-)
>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
