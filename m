Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6011C95A8
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 02:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbfJCA1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 20:27:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:45949 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729714AbfJCA1O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 20:27:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 17:27:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366875160"
Received: from syitbare-mobl.amr.corp.intel.com ([10.251.8.3])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 17:27:13 -0700
Date:   Wed, 2 Oct 2019 17:27:13 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@syitbare-mobl.amr.corp.intel.com
To:     David Miller <davem@davemloft.net>
cc:     netdev@vger.kernel.org, edumazet@google.com, cpaasch@apple.com,
        fw@strlen.de, pabeni@redhat.com, peter.krystad@linux.intel.com,
        dcaratti@redhat.com, matthieu.baerts@tessares.net
Subject: Re: [RFC PATCH v2 00/45] Multipath TCP
In-Reply-To: <20191002.171229.1495727500341484392.davem@davemloft.net>
Message-ID: <alpine.OSX.2.21.1910021715070.33041@syitbare-mobl.amr.corp.intel.com>
References: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com> <20191002.171229.1495727500341484392.davem@davemloft.net>
User-Agent: Alpine 2.21 (OSX 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, 2 Oct 2019, David Miller wrote:

> From: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Date: Wed,  2 Oct 2019 16:36:10 -0700
>
>> The MPTCP upstreaming community has prepared a net-next RFCv2 patch set
>> for review.
>
> Nobody is going to read 45 patches and properly review them.
>
> And I do mean nobody.
>
> Please make smaller, more reasonable (like 12-20 MAX), patch sets to
> start building up the MPTCP infrastructure.
>
> This is for your sake as well as everyone else's.

Thanks David.

We were proposing a shorter series for our later non-RFC posting, but will 
do some further squashing and partitioning to fit in the under 12-20 range 
for all future MPTCP patch sets posted on netdev.

And for my sake as well as everyone elses, I'll skip resending the 
correction to this series since it's only slightly shorter.

--
Mat Martineau
Intel
