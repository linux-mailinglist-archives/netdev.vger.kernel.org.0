Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5697B277CC9
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgIYAVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:21:25 -0400
Received: from mga03.intel.com ([134.134.136.65]:14527 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726806AbgIYAVY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 20:21:24 -0400
IronPort-SDR: 2RPReHbpQOw9YN2XGxyTBmttmnC78x5ZYaHw1FTSCny0It56J8U/qTLOVgg3xQwNN1N3nbs6gw
 tyApI/ZVK/qA==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="161464239"
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="161464239"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 17:21:24 -0700
IronPort-SDR: RVZ5xxV+ZZC8sE2z4qXZOxY5PBm6zJlBm/fRvqgydW1EdIan5mw1lNeq1sEGIlogxqJdjBUnQB
 hpS+GmxFDmeg==
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="455586461"
Received: from mmahler-mobl1.amr.corp.intel.com ([10.254.96.152])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 17:21:24 -0700
Date:   Thu, 24 Sep 2020 17:21:24 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@mmahler-mobl1.amr.corp.intel.com
To:     Geliang Tang <geliangtang@gmail.com>
cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [MPTCP][PATCH net-next 10/16] mptcp: add RM_ADDR related mibs
In-Reply-To: <644420f22ba6f0b9f9f3509c081d8d639ff4bbf3.1600853093.git.geliangtang@gmail.com>
Message-ID: <alpine.OSX.2.23.453.2009241721080.62831@mmahler-mobl1.amr.corp.intel.com>
References: <cover.1600853093.git.geliangtang@gmail.com> <644420f22ba6f0b9f9f3509c081d8d639ff4bbf3.1600853093.git.geliangtang@gmail.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Sep 2020, Geliang Tang wrote:

> This patch added two new mibs for RM_ADDR, named MPTCP_MIB_RMADDR and
> MPTCP_MIB_RMSUBFLOW, when the RM_ADDR suboption is received, increase
> the first mib counter, when the local subflow is removed, increase the
> second mib counter.
>
> Suggested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Suggested-by: Paolo Abeni <pabeni@redhat.com>
> Suggested-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Acked-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> ---
> net/mptcp/mib.c        | 2 ++
> net/mptcp/mib.h        | 2 ++
> net/mptcp/pm_netlink.c | 5 +++++
> 3 files changed, 9 insertions(+)

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
