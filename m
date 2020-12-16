Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4FB2DC9A9
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 00:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730795AbgLPXiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 18:38:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:3899 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726806AbgLPXiw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 18:38:52 -0500
IronPort-SDR: y8+b9jBdN2E2mUhNos13WbD+V/npOCWtpCDxD4F2UmPh8fwYaTWyaiCrDzPOoSCUHQzHHyanoe
 t5+0irc/nzxg==
X-IronPort-AV: E=McAfee;i="6000,8403,9837"; a="171648346"
X-IronPort-AV: E=Sophos;i="5.78,425,1599548400"; 
   d="scan'208";a="171648346"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 15:37:07 -0800
IronPort-SDR: +VwAQCBjm8DR5jiMTAqeUPU8w63pGED+vbY8I+QefkhXuu9rDb+REk/26XiLbTSMTnBTDI6YV4
 hE1la6nBz5qw==
X-IronPort-AV: E=Sophos;i="5.78,425,1599548400"; 
   d="scan'208";a="352888799"
Received: from jumaanew-mobl2.amr.corp.intel.com ([10.254.73.12])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 15:37:07 -0800
Date:   Wed, 16 Dec 2020 15:37:06 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: Re: [PATCH net 2/4] mptcp: properly annotate nested lock
In-Reply-To: <0cbf6359084bee1187ba382a015d8809e2ce2416.1608114076.git.pabeni@redhat.com>
Message-ID: <d21776-ebe6-37c6-5ab0-d04983b4c922@linux.intel.com>
References: <cover.1608114076.git.pabeni@redhat.com> <0cbf6359084bee1187ba382a015d8809e2ce2416.1608114076.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, 16 Dec 2020, Paolo Abeni wrote:

> MPTCP closes the subflows while holding the msk-level lock.
> While acquiring the subflow socket lock we need to use the
> correct nested annotation, or we can hit a lockdep splat
> at runtime.
>
> Reported-and-tested-by: Geliang Tang <geliangtang@gmail.com>
> Fixes: e16163b6e2b7 ("mptcp: refactor shutdown and close")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/protocol.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
