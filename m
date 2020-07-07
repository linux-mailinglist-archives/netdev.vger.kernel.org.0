Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81FA3217548
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 19:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbgGGRfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 13:35:01 -0400
Received: from mga17.intel.com ([192.55.52.151]:37063 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728073AbgGGRfB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 13:35:01 -0400
IronPort-SDR: lyrfrHXVVNBHX7T/TwgkoMuHrja4JKPmUcbZHLIhULeN7amOEQMuAI00My9xA2ave1xO9LEPu0
 3ft0hXtKqRBg==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="127747538"
X-IronPort-AV: E=Sophos;i="5.75,324,1589266800"; 
   d="scan'208";a="127747538"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2020 10:35:00 -0700
IronPort-SDR: 3qFuh2vrk37xXkRW2ixRDqf2HrOR2D93QUt869bO75Y4m5/KyL4EfxvS9W0y7KEWhGT8Km+KFO
 NYWJv2sECUjA==
X-IronPort-AV: E=Sophos;i="5.75,324,1589266800"; 
   d="scan'208";a="266892286"
Received: from apander1-mobl.amr.corp.intel.com ([10.254.78.96])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2020 10:35:00 -0700
Date:   Tue, 7 Jul 2020 10:35:00 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@apander1-mobl.amr.corp.intel.com
To:     Florian Westphal <fw@strlen.de>
cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] mptcp: use mptcp worker for path management
In-Reply-To: <20200707124048.2403-1-fw@strlen.de>
Message-ID: <alpine.OSX.2.23.453.2007071009120.77957@apander1-mobl.amr.corp.intel.com>
References: <20200707124048.2403-1-fw@strlen.de>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue, 7 Jul 2020, Florian Westphal wrote:

> We can re-use the existing work queue to handle path management
> instead of a dedicated work queue.  Just move pm_worker to protocol.c,
> call it from the mptcp worker and get rid of the msk lock (already held).
>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
> net/mptcp/pm.c       | 44 +-------------------------------------------
> net/mptcp/protocol.c | 27 ++++++++++++++++++++++++++-
> net/mptcp/protocol.h |  3 ---
> 3 files changed, 27 insertions(+), 47 deletions(-)
>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
