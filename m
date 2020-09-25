Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF46277CC2
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgIYATu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:19:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:30196 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbgIYATu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 20:19:50 -0400
IronPort-SDR: V0LdhS1agKMN8op7lk+GmfumOgw3Vjl/Lpj9TUaBUepjT0d2o8H9qZM3ym3+PK5sxra/Yu5e8a
 RM1xJ0YM/NUg==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="179478345"
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="179478345"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 17:19:50 -0700
IronPort-SDR: tn8ZPLnO/mrIjnKap5g9u7hH+EEL468C9JVcKeX0ONig4eBuKx62mCI9aYRgaqjzoq/rgrWjob
 jf0YwpBT8mVQ==
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="455585035"
Received: from mmahler-mobl1.amr.corp.intel.com ([10.254.96.152])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 17:19:50 -0700
Date:   Thu, 24 Sep 2020 17:19:50 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@mmahler-mobl1.amr.corp.intel.com
To:     Geliang Tang <geliangtang@gmail.com>
cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [MPTCP][PATCH net-next 03/16] mptcp: add the incoming RM_ADDR
 support
In-Reply-To: <bf7aca2bee20de148728e30343734628aee6d779.1600853093.git.geliangtang@gmail.com>
Message-ID: <alpine.OSX.2.23.453.2009241718510.62831@mmahler-mobl1.amr.corp.intel.com>
References: <cover.1600853093.git.geliangtang@gmail.com> <bf7aca2bee20de148728e30343734628aee6d779.1600853093.git.geliangtang@gmail.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Sep 2020, Geliang Tang wrote:

> This patch added the RM_ADDR option parsing logic:
>
> We parsed the incoming options to find if the rm_addr option is received,
> and called mptcp_pm_rm_addr_received to schedule PM work to a new status,
> named MPTCP_PM_RM_ADDR_RECEIVED.
>
> PM work got this status, and called mptcp_pm_nl_rm_addr_received to handle
> it.
>
> In mptcp_pm_nl_rm_addr_received, we closed the subflow matching the rm_id,
> and updated PM counter.
>
> Suggested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Suggested-by: Paolo Abeni <pabeni@redhat.com>
> Suggested-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> ---
> net/mptcp/options.c    |  5 +++++
> net/mptcp/pm.c         | 12 ++++++++++++
> net/mptcp/pm_netlink.c | 34 ++++++++++++++++++++++++++++++++++
> net/mptcp/protocol.c   | 12 ++++++++----
> net/mptcp/protocol.h   |  7 +++++++
> 5 files changed, 66 insertions(+), 4 deletions(-)

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
