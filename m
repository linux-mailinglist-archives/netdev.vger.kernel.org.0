Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F4F20E964
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 01:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729501AbgF2XbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 19:31:22 -0400
Received: from mga12.intel.com ([192.55.52.136]:31694 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726794AbgF2XbV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 19:31:21 -0400
IronPort-SDR: 0v3dSYDMJvTn0B8AN9CvhNNr2fDqrQxDvY/rZkm22qBOewGNESMbuzTLEVezZdXTcKh9o37yx+
 IuwdhftDPzSw==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="125730029"
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="125730029"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 16:31:21 -0700
IronPort-SDR: G9mnpHTxFTEzklsbTYsD9NnkScYZSWiBeLDL754H4eHjJwVWkxuEppbYu+G8mtJKDGE67l1xWA
 wAeuiUISteFQ==
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="454377280"
Received: from jlbliss-mobl.amr.corp.intel.com ([10.255.231.136])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 16:31:21 -0700
Date:   Mon, 29 Jun 2020 16:31:21 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@jlbliss-mobl.amr.corp.intel.com
To:     Davide Caratti <dcaratti@redhat.com>
cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org
Subject: Re: [PATCH net-next 6/6] mptcp: close poll() races
In-Reply-To: <0c0e9026c97b90d92047b3771dc248e5d873ac6a.1593461586.git.dcaratti@redhat.com>
Message-ID: <alpine.OSX.2.23.453.2006291631060.11066@jlbliss-mobl.amr.corp.intel.com>
References: <cover.1593461586.git.dcaratti@redhat.com> <0c0e9026c97b90d92047b3771dc248e5d873ac6a.1593461586.git.dcaratti@redhat.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Jun 2020, Davide Caratti wrote:

> From: Paolo Abeni <pabeni@redhat.com>
>
> mptcp_poll always return POLLOUT for unblocking
> connect(), ensure that the socket is a suitable
> state.
> The MPTCP_DATA_READY bit is never cleared on accept:
> ensure we don't leave mptcp_accept() with an empty
> accept queue and such bit set.
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
> net/mptcp/protocol.c | 25 ++++++++++++++++++++-----
> 1 file changed, 20 insertions(+), 5 deletions(-)
>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
