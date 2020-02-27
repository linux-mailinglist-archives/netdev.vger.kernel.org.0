Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89BAB170CFF
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 01:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbgB0AJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 19:09:46 -0500
Received: from mga07.intel.com ([134.134.136.100]:4836 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727989AbgB0AJp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 19:09:45 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Feb 2020 16:09:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,490,1574150400"; 
   d="scan'208";a="438626149"
Received: from tvtrimel-mobl2.amr.corp.intel.com ([10.251.11.94])
  by fmsmga006.fm.intel.com with ESMTP; 26 Feb 2020 16:09:44 -0800
Date:   Wed, 26 Feb 2020 16:09:44 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@tvtrimel-mobl2.amr.corp.intel.com
To:     Florian Westphal <fw@strlen.de>
cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/7] mptcp: add and use mptcp_data_ready
 helper
In-Reply-To: <20200226091452.1116-2-fw@strlen.de>
Message-ID: <alpine.OSX.2.22.394.2002261608032.50710@tvtrimel-mobl2.amr.corp.intel.com>
References: <20200226091452.1116-1-fw@strlen.de> <20200226091452.1116-2-fw@strlen.de>
User-Agent: Alpine 2.22 (OSX 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, 26 Feb 2020, Florian Westphal wrote:

> allows us to schedule the work queue to drain the ssk receive queue in
> a followup patch.
>
> This is needed to avoid sending all-to-pessimistic mptcp-level
> acknowledgements.  At this time, the ack_seq is what was last read by
> userspace instead of the highest in-sequence number queued for reading.
>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
