Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE6B277CF2
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbgIYAdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:33:36 -0400
Received: from mga17.intel.com ([192.55.52.151]:50126 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbgIYAdd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 20:33:33 -0400
IronPort-SDR: kDCVnxpoVlyhcs1ucFyzBL4b2TcIoyuqNIa5ZBb+M/+nH5Krzg0/YkbP5P/UclEC/Eelg16Tav
 5X0qiYlZR3LA==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="141403377"
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="141403377"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 17:33:32 -0700
IronPort-SDR: ran4sEvukTlPhNzEQger88oGZzET0JLT4Tg7/5NFFytMDrznK1OH4jQM0Ny5hRyjhK47KxilLm
 wRUWJO01dEfA==
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="455596270"
Received: from mmahler-mobl1.amr.corp.intel.com ([10.254.96.152])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 17:33:32 -0700
Date:   Thu, 24 Sep 2020 17:33:32 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@mmahler-mobl1.amr.corp.intel.com
To:     netdev@vger.kernel.org
Subject: Re: [MPTCP][PATCH net-next 09/16] mptcp: implement
 mptcp_pm_remove_subflow
In-Reply-To: <5018fd495529e058ea866e8d8edbe0bb98ec733a.1600853093.git.geliangtang@gmail.com>
Message-ID: <alpine.OSX.2.23.453.2009241730590.62831@mmahler-mobl1.amr.corp.intel.com>
References: <cover.1600853093.git.geliangtang@gmail.com> <5018fd495529e058ea866e8d8edbe0bb98ec733a.1600853093.git.geliangtang@gmail.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Sep 2020, Geliang Tang wrote:

> This patch implemented the local subflow removing function,
> mptcp_pm_remove_subflow, it simply called mptcp_pm_nl_rm_subflow_received
> under the PM spin lock.
>
> We use mptcp_pm_remove_subflow to remove a local subflow, so change it's
> argument from remote_id to local_id.
>
> We check subflow->local_id in mptcp_pm_nl_rm_subflow_received to remove
> a subflow.
>
> Suggested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Suggested-by: Paolo Abeni <pabeni@redhat.com>
> Suggested-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> ---
> net/mptcp/pm.c         |  9 +++++++--
> net/mptcp/pm_netlink.c | 33 +++++++++++++++++++++++++++++++++
> net/mptcp/protocol.h   |  3 ++-
> 3 files changed, 42 insertions(+), 3 deletions(-)

Resending this reviewed-by tag so patchwork picks it up (previous mail was 
not delivered to the mailing list, but I'm assuming it did go to other 
recipients).

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
