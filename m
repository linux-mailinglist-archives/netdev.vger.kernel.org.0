Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F83B20BB65
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 23:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726022AbgFZVYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 17:24:41 -0400
Received: from mga03.intel.com ([134.134.136.65]:9766 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgFZVYl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 17:24:41 -0400
IronPort-SDR: W2DJkiTLTF7gK0RH1ur2wvMmMw/0fUdZuyHpj1OWSnpweMB60sVNDnO24x3Z4R8QFHnvFqJ015
 RJrlz1aXtXYA==
X-IronPort-AV: E=McAfee;i="6000,8403,9664"; a="145536767"
X-IronPort-AV: E=Sophos;i="5.75,285,1589266800"; 
   d="scan'208";a="145536767"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 14:24:40 -0700
IronPort-SDR: 84qb4e9o0ufMeqO0B4USzIQIriYWGpFBttoG8lOLOum7leqEc80kxAKP5gAhDdBXZ8a9ksGhOt
 ZNge2S1lTBpg==
X-IronPort-AV: E=Sophos;i="5.75,285,1589266800"; 
   d="scan'208";a="302447607"
Received: from redsall-mobl2.amr.corp.intel.com ([10.254.108.22])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 14:24:40 -0700
Date:   Fri, 26 Jun 2020 14:24:39 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@redsall-mobl2.amr.corp.intel.com
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [MPTCP] [PATCH net-next v2 1/4] mptcp: add __init annotation on
 setup functions
In-Reply-To: <37cfccea23f199a5e11497a11373786b0f3e078a.1593192442.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.23.453.2006261423070.66996@redsall-mobl2.amr.corp.intel.com>
References: <cover.1593192442.git.pabeni@redhat.com> <37cfccea23f199a5e11497a11373786b0f3e078a.1593192442.git.pabeni@redhat.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 26 Jun 2020, Paolo Abeni wrote:

> Add the missing annotation in some setup-only
> functions.
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/pm.c         |  2 +-
> net/mptcp/pm_netlink.c |  2 +-
> net/mptcp/protocol.c   |  4 ++--
> net/mptcp/protocol.h   | 10 +++++-----
> net/mptcp/subflow.c    |  2 +-
> 5 files changed, 10 insertions(+), 10 deletions(-)

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
