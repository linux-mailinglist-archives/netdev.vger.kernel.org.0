Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6691B2842FA
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 01:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgJEXfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 19:35:41 -0400
Received: from mga17.intel.com ([192.55.52.151]:49132 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725973AbgJEXfl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 19:35:41 -0400
IronPort-SDR: siVwR3ZI8z6PN2RaEviVKwZ+atEDSg4GHhasZDSIbp3EpJ7hnsB/6QETZ1fwQpXnhS4x5D18rK
 G8QpyMlXRJJg==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="144139988"
X-IronPort-AV: E=Sophos;i="5.77,341,1596524400"; 
   d="scan'208";a="144139988"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 16:31:12 -0700
IronPort-SDR: jLGVKuT9/+LNsrJfjOrSBgEFHvu/27qmRaEW5u61amnJAwp33EcU/gmrhY8Lmy6RlFU8Z31YF/
 Q2cTT8ftOKAw==
X-IronPort-AV: E=Sophos;i="5.77,341,1596524400"; 
   d="scan'208";a="517389966"
Received: from srinathb-mobl.amr.corp.intel.com ([10.255.229.180])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 14:59:52 -0700
Date:   Mon, 5 Oct 2020 14:59:39 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@srinathb-mobl.amr.corp.intel.com
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        mptcp@lists.01.org
Subject: Re: [MPTCP] [PATCH net-next] mptcp: don't skip needed ack
In-Reply-To: <515e80a174ee9bad5e2c6a8338d9362eb43d39b7.1601894086.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.23.453.2010051459040.9753@srinathb-mobl.amr.corp.intel.com>
References: <515e80a174ee9bad5e2c6a8338d9362eb43d39b7.1601894086.git.pabeni@redhat.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 5 Oct 2020, Paolo Abeni wrote:

> Currently we skip calling tcp_cleanup_rbuf() when packets
> are moved into the OoO queue or simply dropped. In both
> cases we still increment tp->copied_seq, and we should
> ask the TCP stack to check for ack.
>
> Fixes: c76c6956566f ("mptcp: call tcp_cleanup_rbuf on subflows")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/protocol.c | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
