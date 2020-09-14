Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4340C26947A
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgINSKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:10:02 -0400
Received: from mga17.intel.com ([192.55.52.151]:41422 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbgINSJy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 14:09:54 -0400
IronPort-SDR: ER9if3o2ztv0NhIBqBccVNbIBCzSme+9EO0qlYslKFf6ZjvTgzr4zP74rQmSv7Uz7MvyePnPXE
 //Yaw+yqpgGA==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="139147480"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="139147480"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 11:09:53 -0700
IronPort-SDR: EeV38mDKfL9f3HcuDWVbKq5woK5B+utQx8HvTHhoF7/H3S2gixUCRVUCHD4D17tJ7AXD7jm8ps
 DtQvkgAX08uw==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="482446896"
Received: from ningale-mobl.amr.corp.intel.com ([10.255.229.30])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 11:09:53 -0700
Date:   Mon, 14 Sep 2020 11:09:53 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@ningale-mobl.amr.corp.intel.com
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: Re: [PATCH net-next v2 13/13] mptcp: simult flow self-tests
In-Reply-To: <c1fc87079b24def5cb0a6729481d4b14444296b4.1599854632.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.23.453.2009141109260.57764@ningale-mobl.amr.corp.intel.com>
References: <cover.1599854632.git.pabeni@redhat.com> <c1fc87079b24def5cb0a6729481d4b14444296b4.1599854632.git.pabeni@redhat.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020, Paolo Abeni wrote:

> Add a bunch of test-cases for multiple subflow xmit:
> create multiple subflows simulating different links
> condition via netem and verify that the msk is able
> to use completely the aggregated bandwidth.
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> tools/testing/selftests/net/mptcp/Makefile    |   3 +-
> .../selftests/net/mptcp/simult_flows.sh       | 293 ++++++++++++++++++
> 2 files changed, 295 insertions(+), 1 deletion(-)
> create mode 100755 tools/testing/selftests/net/mptcp/simult_flows.sh
>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
