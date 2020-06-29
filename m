Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C80320E95E
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 01:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgF2XaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 19:30:25 -0400
Received: from mga14.intel.com ([192.55.52.115]:24908 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726410AbgF2XaZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 19:30:25 -0400
IronPort-SDR: wnaZmf8Xy2xQLT/FCas5K50ukSNTUN/HKFJTCmz7J/SLhIrRtegbxguXgcYHFvZ2CLU8Qc1J0w
 EYIfDMAo7g1g==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="145169263"
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="145169263"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 16:30:17 -0700
IronPort-SDR: zIaX1M7ycTnUwgEQBfljYfkH1YnajQJVBaBABpEVOoWB8DdWmzeJ3Xu+GmEI0Ibu/Q8B/uJOQM
 02z5HNW7LjSA==
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="454376907"
Received: from jlbliss-mobl.amr.corp.intel.com ([10.255.231.136])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 16:30:17 -0700
Date:   Mon, 29 Jun 2020 16:30:17 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@jlbliss-mobl.amr.corp.intel.com
To:     Davide Caratti <dcaratti@redhat.com>
cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org
Subject: Re: [PATCH net-next 3/6] mptcp: check for plain TCP sock at accept
 time
In-Reply-To: <821ad8ad1581b906b6706426c1ba0c3b837cf60d.1593461586.git.dcaratti@redhat.com>
Message-ID: <alpine.OSX.2.23.453.2006291629590.11066@jlbliss-mobl.amr.corp.intel.com>
References: <cover.1593461586.git.dcaratti@redhat.com> <821ad8ad1581b906b6706426c1ba0c3b837cf60d.1593461586.git.dcaratti@redhat.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Jun 2020, Davide Caratti wrote:

> From: Paolo Abeni <pabeni@redhat.com>
>
> This cleanup the code a bit and avoid corrupted states
> on weird syscall sequence (accept(), connect()).
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
> net/mptcp/protocol.c | 69 +++++---------------------------------------
> 1 file changed, 7 insertions(+), 62 deletions(-)
>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
