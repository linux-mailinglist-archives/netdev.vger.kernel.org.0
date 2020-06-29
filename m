Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E28320E956
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 01:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729079AbgF2X3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 19:29:34 -0400
Received: from mga18.intel.com ([134.134.136.126]:52941 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbgF2X3d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 19:29:33 -0400
IronPort-SDR: VZ43LChBb1DS5t0fLDykqjLIK/YoU6rH6hZv0aiHFrsQIOwwkquFcIQhH2UDjyOUxj9nTmQsYX
 jnPVGnZumdag==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="133540443"
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="133540443"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 16:29:33 -0700
IronPort-SDR: NYDlXV41NKqL8wr4lLn0xwui7LTJHvtVimx9xicSBsvKDMYSU7q/rwY4X1fEypbYSeYdrL8nOk
 2BCf/Z5l+Ryg==
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="454376708"
Received: from jlbliss-mobl.amr.corp.intel.com ([10.255.231.136])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 16:29:33 -0700
Date:   Mon, 29 Jun 2020 16:29:32 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@jlbliss-mobl.amr.corp.intel.com
To:     Davide Caratti <dcaratti@redhat.com>
cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org
Subject: Re: [PATCH net-next 1/6] net: mptcp: improve fallback to TCP
In-Reply-To: <48551241b592f237f236361276b5b42774d2ba69.1593461586.git.dcaratti@redhat.com>
Message-ID: <alpine.OSX.2.23.453.2006291624250.11066@jlbliss-mobl.amr.corp.intel.com>
References: <cover.1593461586.git.dcaratti@redhat.com> <48551241b592f237f236361276b5b42774d2ba69.1593461586.git.dcaratti@redhat.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Jun 2020, Davide Caratti wrote:

> Keep using MPTCP sockets and a use "dummy mapping" in case of fallback
> to regular TCP. When fallback is triggered, skip addition of the MPTCP
> option on send.
>
> Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/11
> Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/22
> Co-developed-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
> net/mptcp/options.c  |  9 +++-
> net/mptcp/protocol.c | 98 ++++++++++++--------------------------------
> net/mptcp/protocol.h | 33 +++++++++++++++
> net/mptcp/subflow.c  | 47 +++++++++++++--------
> 4 files changed, 98 insertions(+), 89 deletions(-)
>

Thanks Davide and Paolo! Appreciate the simplification of the fallback 
code.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
