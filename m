Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470DB29CC2B
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 23:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1756985AbgJ0WqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 18:46:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:62507 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756904AbgJ0WqO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 18:46:14 -0400
IronPort-SDR: 7euyhD/arm/T2KhhQbPUlUBa1KmBjIXbxDZwUZWN8OmZnEbjWdk5kLWHcgnlTHe1FTj/N/64cF
 8R8JflMBCuQg==
X-IronPort-AV: E=McAfee;i="6000,8403,9787"; a="155142600"
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="155142600"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2020 15:46:12 -0700
IronPort-SDR: j/qmJLxb8zUUvjIN60g8L5rrWWO9s1WLAeGb5NQZuPf1W4TzFn7lLsTObO3m0Jr4KA5fZfxS1o
 hcFGpW0Cbbuw==
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="304047436"
Received: from kcalvi-mobl2.amr.corp.intel.com ([10.252.138.241])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2020 15:46:12 -0700
Date:   Tue, 27 Oct 2020 15:46:11 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        mptcp@lists.01.org
Subject: Re: [PATCH net] mptcp: add missing memory scheduling in the rx
 path
In-Reply-To: <f6143a6193a083574f11b00dbf7b5ad151bc4ff4.1603810630.git.pabeni@redhat.com>
Message-ID: <d7886714-7b92-9be8-441e-73c48c52d62@linux.intel.com>
References: <f6143a6193a083574f11b00dbf7b5ad151bc4ff4.1603810630.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020, Paolo Abeni wrote:

> When moving the skbs from the subflow into the msk receive
> queue, we must schedule there the required amount of memory.
>
> Try to borrow the required memory from the subflow, if needed,
> so that we leverage the existing TCP heuristic.
>
> Fixes: 6771bfd9ee24 ("mptcp: update mptcp ack sequence from work queue")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/protocol.c | 10 ++++++++++
> 1 file changed, 10 insertions(+)
>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
