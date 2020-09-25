Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6DD277CD1
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgIYAYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:24:16 -0400
Received: from mga18.intel.com ([134.134.136.126]:56218 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbgIYAYQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 20:24:16 -0400
IronPort-SDR: WiU0Txmhj0qxovRx39gnDqpuNGwB93dQKI5dNiLMXo7lZYZqYdut0GxynLW63SqseDMnJFKTdf
 q8hecySNQ0gw==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="149136130"
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="149136130"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 17:24:15 -0700
IronPort-SDR: BGxNuyTbf357vWr+i1cAtEwwRQO6azngTTVwPF6ivIwuxXS/ATV66Iu6Cxkxy0OOlLyslXCUsR
 PnCiQaV4M/Mg==
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="455588806"
Received: from mmahler-mobl1.amr.corp.intel.com ([10.254.96.152])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 17:24:15 -0700
Date:   Thu, 24 Sep 2020 17:24:15 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@mmahler-mobl1.amr.corp.intel.com
To:     Geliang Tang <geliangtang@gmail.com>
cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [MPTCP][PATCH net-next 12/16] selftests: mptcp: add remove cfg
 in mptcp_connect
In-Reply-To: <aa4ffb8cb7f8c135e5704eb11cfce7cb0bf7ecd4.1600853093.git.geliangtang@gmail.com>
Message-ID: <alpine.OSX.2.23.453.2009241723580.62831@mmahler-mobl1.amr.corp.intel.com>
References: <cover.1600853093.git.geliangtang@gmail.com> <aa4ffb8cb7f8c135e5704eb11cfce7cb0bf7ecd4.1600853093.git.geliangtang@gmail.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Sep 2020, Geliang Tang wrote:

> This patch added a new cfg, named cfg_remove in mptcp_connect. This new
> cfg_remove is copied from cfg_join. The only difference between them is in
> the do_rnd_write function. Here we slow down the transfer process of all
> data to let the RM_ADDR suboption can be sent and received completely.
> Otherwise the remove address and subflow test cases don't work.
>
> Suggested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Suggested-by: Paolo Abeni <pabeni@redhat.com>
> Suggested-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Acked-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> ---
> .../selftests/net/mptcp/mptcp_connect.c        | 18 +++++++++++++++---
> 1 file changed, 15 insertions(+), 3 deletions(-)

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
