Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCCFEC953F
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbfJBXxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:53:05 -0400
Received: from mga04.intel.com ([192.55.52.120]:17485 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727659AbfJBXxE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:53:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:53:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="195032806"
Received: from syitbare-mobl.amr.corp.intel.com ([10.251.8.3])
  by orsmga003.jf.intel.com with ESMTP; 02 Oct 2019 16:53:04 -0700
Date:   Wed, 2 Oct 2019 16:53:04 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@syitbare-mobl.amr.corp.intel.com
To:     netdev@vger.kernel.org, edumazet@google.com
cc:     cpaasch@apple.com, fw@strlen.de, pabeni@redhat.com,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: Re: [RFC PATCH v2 00/45] Multipath TCP
In-Reply-To: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
Message-ID: <alpine.OSX.2.21.1910021649400.33041@syitbare-mobl.amr.corp.intel.com>
References: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
User-Agent: Alpine 2.21 (OSX 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, 2 Oct 2019, Mat Martineau wrote:

> The MPTCP upstreaming community has prepared a net-next RFCv2 patch set
> for review.
>
> Clone/fetch:
> https://github.com/multipath-tcp/mptcp_net-next.git (tag: netdev-rfcv2)
>
> Browse:
> https://github.com/multipath-tcp/mptcp_net-next/tree/netdev-rfcv2


Huge apologies everyone: while the branches referenced above are correct, 
the email patch series I just posted was not generated from the correct 
git commits.

Please disregard, I will send v3 shortly.

--
Mat Martineau
Intel
