Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35FD277CBE
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgIYARY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:17:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:30033 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbgIYARX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 20:17:23 -0400
IronPort-SDR: d9XJB02cDf1Y0aSYWgL8M7XHM7t/+CAkiJE8XTgMxpzOuUTc08eMhtQ68ahN37u6uBJgv6cFBO
 zmtytbgIl2Sg==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="179478064"
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="179478064"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 17:17:23 -0700
IronPort-SDR: 8vU4NKRK0ZkP53WcM8Vwzsx9IVbuPT+jVi2Y8Lu4lvob0q6eKKxgru1nH3SIGI6jrp6OLvAMu4
 TOW3sl4P/CgQ==
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="455583311"
Received: from mmahler-mobl1.amr.corp.intel.com ([10.254.96.152])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 17:17:23 -0700
Date:   Thu, 24 Sep 2020 17:17:22 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@mmahler-mobl1.amr.corp.intel.com
To:     Geliang Tang <geliangtang@gmail.com>
cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [MPTCP][PATCH net-next 02/16] mptcp: add the outgoing RM_ADDR
 support
In-Reply-To: <e3c9ab612d773465ddf78cef0482208c73a0ca07.1600853093.git.geliangtang@gmail.com>
Message-ID: <alpine.OSX.2.23.453.2009241717100.62831@mmahler-mobl1.amr.corp.intel.com>
References: <cover.1600853093.git.geliangtang@gmail.com> <e3c9ab612d773465ddf78cef0482208c73a0ca07.1600853093.git.geliangtang@gmail.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Sep 2020, Geliang Tang wrote:

> This patch added a new signal named rm_addr_signal in PM. On outgoing path,
> we called mptcp_pm_should_rm_signal to check if rm_addr_signal has been
> set. If it has been, we sent out the RM_ADDR option.
>
> Suggested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Suggested-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> ---
> net/mptcp/options.c  | 29 +++++++++++++++++++++++++++++
> net/mptcp/pm.c       | 25 +++++++++++++++++++++++++
> net/mptcp/protocol.h |  9 +++++++++
> 3 files changed, 63 insertions(+)

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
