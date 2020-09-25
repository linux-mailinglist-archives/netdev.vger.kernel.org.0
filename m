Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076D4277CD7
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgIYAZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:25:33 -0400
Received: from mga06.intel.com ([134.134.136.31]:59497 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726704AbgIYAZc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 20:25:32 -0400
IronPort-SDR: DX9Jn924FmE9TJDxNFnOYi7yyutfNPuq5X5zmYtgsM4y5Nx8ZRWgFSZTkBawP+f1UeVP2E+2OU
 /oMEJ8bacFvw==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="222980683"
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="222980683"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 17:25:31 -0700
IronPort-SDR: bZ3RqbCtiF/I1cHwEEiktgI4FD/+rB/BBVJHXxcCtyeoAVJ+9QyZjanLFSWWYj5vmatKth+PY8
 pZhneaGZn7jw==
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="455589690"
Received: from mmahler-mobl1.amr.corp.intel.com ([10.254.96.152])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 17:25:31 -0700
Date:   Thu, 24 Sep 2020 17:25:31 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@mmahler-mobl1.amr.corp.intel.com
To:     Geliang Tang <geliangtang@gmail.com>
cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [MPTCP][PATCH net-next 14/16] mptcp: add struct
 mptcp_pm_add_entry
In-Reply-To: <26617b54898c115de8d916633b8e42055ed5c678.1600853093.git.geliangtang@gmail.com>
Message-ID: <alpine.OSX.2.23.453.2009241725200.62831@mmahler-mobl1.amr.corp.intel.com>
References: <cover.1600853093.git.geliangtang@gmail.com> <26617b54898c115de8d916633b8e42055ed5c678.1600853093.git.geliangtang@gmail.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Sep 2020, Geliang Tang wrote:

> Add a new struct mptcp_pm_add_entry to describe add_addr's entry.
>
> Acked-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> ---
> net/mptcp/pm_netlink.c | 19 ++++++++++++-------
> 1 file changed, 12 insertions(+), 7 deletions(-)

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
