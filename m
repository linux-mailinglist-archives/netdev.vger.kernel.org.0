Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D139F269484
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbgINSL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:11:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:1442 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726052AbgINSId (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 14:08:33 -0400
IronPort-SDR: 4kwjyGyr6h8Mgpyc4nghOe4krtTk35aV0tgFGA69wVGZDXjDCV2jmF9pGWmxkvrfCBmd0/5LOZ
 vGLEbpEKZM9A==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="160067817"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="160067817"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 11:08:33 -0700
IronPort-SDR: NVPtuvlkNuMCL/Wn82ivL0qbfafQNGo/j5QZl5ff1Xtc88kNUmsgNT1RqHOhe7woJ8tSululUM
 uvxaNrajF0Sg==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="482446161"
Received: from ningale-mobl.amr.corp.intel.com ([10.255.229.30])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 11:08:32 -0700
Date:   Mon, 14 Sep 2020 11:08:32 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@ningale-mobl.amr.corp.intel.com
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: Re: [PATCH net-next v2 09/13] mptcp: move address attribute into
 mptcp_addr_info
In-Reply-To: <16790a7f9e2919325d3f2e684597337c5e0833d9.1599854632.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.23.453.2009141108150.57764@ningale-mobl.amr.corp.intel.com>
References: <cover.1599854632.git.pabeni@redhat.com> <16790a7f9e2919325d3f2e684597337c5e0833d9.1599854632.git.pabeni@redhat.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020, Paolo Abeni wrote:

> So that can be accessed easily from the subflow creation
> helper. No functional change intended.
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/pm_netlink.c | 39 ++++++++++++++++++++-------------------
> net/mptcp/protocol.h   |  5 +++--
> net/mptcp/subflow.c    |  5 ++---
> 3 files changed, 25 insertions(+), 24 deletions(-)
>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
