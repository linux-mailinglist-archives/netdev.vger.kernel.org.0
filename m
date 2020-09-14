Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2D826946C
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgINSIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:08:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:1234 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgINSH4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 14:07:56 -0400
IronPort-SDR: KJXE2hgmUswAdOP8jF+BlW3igCu2W7N3LSFmaydKLcuV7aCVgW2/l9qDy28yCVzhPagehzh79s
 NR6psmtes1gw==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="160067701"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="160067701"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 11:07:47 -0700
IronPort-SDR: tLLcSgMYQp/qaRESRFAAkmxc9gvoSPfzneWIGizOq+LoeC2T7QM6EJpbRGzKfJpIOtV38LCgsQ
 v8MB7tDOv04g==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="482445855"
Received: from ningale-mobl.amr.corp.intel.com ([10.255.229.30])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 11:07:47 -0700
Date:   Mon, 14 Sep 2020 11:07:46 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@ningale-mobl.amr.corp.intel.com
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: Re: [PATCH net-next v2 07/13] mptcp: cleanup
 mptcp_subflow_discard_data()
In-Reply-To: <f62a0071f94505b78dd32140b685cd938560008e.1599854632.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.23.453.2009141107280.57764@ningale-mobl.amr.corp.intel.com>
References: <cover.1599854632.git.pabeni@redhat.com> <f62a0071f94505b78dd32140b685cd938560008e.1599854632.git.pabeni@redhat.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020, Paolo Abeni wrote:

> There is no need to use the tcp_read_sock(), we can
> simply drop the skb. Additionally try to look at the
> next buffer for in order data.
>
> This both simplifies the code and avoid unneeded indirect
> calls.
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/protocol.h |  1 -
> net/mptcp/subflow.c  | 58 +++++++++++---------------------------------
> 2 files changed, 14 insertions(+), 45 deletions(-)
>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
