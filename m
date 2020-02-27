Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA34170D0D
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 01:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgB0AMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 19:12:36 -0500
Received: from mga18.intel.com ([134.134.136.126]:24412 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728018AbgB0AMg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 19:12:36 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Feb 2020 16:12:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,490,1574150400"; 
   d="scan'208";a="238211814"
Received: from tvtrimel-mobl2.amr.corp.intel.com ([10.251.11.94])
  by orsmga003.jf.intel.com with ESMTP; 26 Feb 2020 16:12:35 -0800
Date:   Wed, 26 Feb 2020 16:12:35 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@tvtrimel-mobl2.amr.corp.intel.com
To:     Florian Westphal <fw@strlen.de>
cc:     netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 7/7] mptcp: defer work schedule until mptcp lock
 is released
In-Reply-To: <20200226091452.1116-8-fw@strlen.de>
Message-ID: <alpine.OSX.2.22.394.2002261612010.50710@tvtrimel-mobl2.amr.corp.intel.com>
References: <20200226091452.1116-1-fw@strlen.de> <20200226091452.1116-8-fw@strlen.de>
User-Agent: Alpine 2.22 (OSX 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Feb 2020, Florian Westphal wrote:

> From: Paolo Abeni <pabeni@redhat.com>
>
> Don't schedule the work queue right away, instead defer this
> to the lock release callback.
>
> This has the advantage that it will give recv path a chance to
> complete -- this might have moved all pending packets from the
> subflow to the mptcp receive queue, which allows to avoid the
> schedule_work().
>
> Co-developed-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
