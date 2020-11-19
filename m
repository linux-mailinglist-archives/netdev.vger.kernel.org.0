Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB1E72B8926
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 01:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgKSAmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 19:42:45 -0500
Received: from mga12.intel.com ([192.55.52.136]:57753 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbgKSAmp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 19:42:45 -0500
IronPort-SDR: y/mm7vUubAy9UXuoMdFW5act82yW9HjRahsrr63SfcFsYuDLai6pmnY4o2OU0cIAa/dZb6/Y06
 V2mwXfUQ6wbw==
X-IronPort-AV: E=McAfee;i="6000,8403,9809"; a="150479304"
X-IronPort-AV: E=Sophos;i="5.77,488,1596524400"; 
   d="scan'208";a="150479304"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 16:42:45 -0800
IronPort-SDR: pDegFnxsze2eCCiYoJootAGTSUVRawJtgqC5QHUMtWR8jMjADmQraiTNTwKDFOhIzPCCxgk3Ia
 FNLDRAqfddAA==
X-IronPort-AV: E=Sophos;i="5.77,488,1596524400"; 
   d="scan'208";a="368567900"
Received: from abgardin-mobl.amr.corp.intel.com ([10.254.102.209])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 16:42:45 -0800
Date:   Wed, 18 Nov 2020 16:42:44 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        mptcp@lists.01.org
Subject: Re: [MPTCP] [PATCH net-next] mptcp: update rtx timeout only if
 required.
In-Reply-To: <1a72039f112cae048c44d398ffa14e0a1432db3d.1605737083.git.pabeni@redhat.com>
Message-ID: <d69c8138-311b-f94e-74b8-1e759846eec0@linux.intel.com>
References: <1a72039f112cae048c44d398ffa14e0a1432db3d.1605737083.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, 18 Nov 2020, Paolo Abeni wrote:

> We must start the retransmission timer only there are
> pending data in the rtx queue.
> Otherwise we can hit a WARN_ON in mptcp_reset_timer(),
> as syzbot demonstrated.
>
> Reported-and-tested-by: syzbot+42aa53dafb66a07e5a24@syzkaller.appspotmail.com
> Fixes: d9ca1de8c0cd ("mptcp: move page frag allocation in mptcp_sendmsg()")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/protocol.c | 9 +++++----
> 1 file changed, 5 insertions(+), 4 deletions(-)
>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
