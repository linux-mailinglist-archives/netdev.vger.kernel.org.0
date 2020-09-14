Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07EE269452
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgINSE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:04:26 -0400
Received: from mga14.intel.com ([192.55.52.115]:26114 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbgINSEZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 14:04:25 -0400
IronPort-SDR: mzsLCbCpQWLJ33shSSH8s2Hvv3Fkwunrc5okydFYKmUP0rD6PvKRhn7AzSlE68KJK+nOxezhHe
 ccqx3/y5kAww==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="158419086"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="158419086"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 11:04:23 -0700
IronPort-SDR: LPPbPoC8Z9QU4f5W1YHUxNyeLjmT4UIEh8if/kcoX5m84uXM7WbGUKmKq7iQ6B1/Ilg6i6i59Q
 ENjPEzZFI2UQ==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="450980249"
Received: from ningale-mobl.amr.corp.intel.com ([10.255.229.30])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 11:04:23 -0700
Date:   Mon, 14 Sep 2020 11:04:22 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@ningale-mobl.amr.corp.intel.com
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: Re: [MPTCP] [PATCH net-next v2 04/13] mptcp: basic sndbuf
 autotuning
In-Reply-To: <3f5500f120bf9a196abf3b7b1b307a1e48f8c715.1599854632.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.23.453.2009141103540.57764@ningale-mobl.amr.corp.intel.com>
References: <cover.1599854632.git.pabeni@redhat.com> <3f5500f120bf9a196abf3b7b1b307a1e48f8c715.1599854632.git.pabeni@redhat.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020, Paolo Abeni wrote:

> Let the msk sendbuf track the size of the larger subflow's
> send window, so that we ensure mptcp_sendmsg() does not
> exceed MPTCP-level send window.
>
> The update is performed just before try to send any data.
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/protocol.c | 17 +++++++++++++----
> 1 file changed, 13 insertions(+), 4 deletions(-)
>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
