Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2F02DC9A8
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 00:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730016AbgLPXib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 18:38:31 -0500
Received: from mga04.intel.com ([192.55.52.120]:34417 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726806AbgLPXib (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 18:38:31 -0500
IronPort-SDR: lUQBRGrg7ZTOVArKCfHA+Exz4K3XNpWG3l8c0Kc2PgUn4cqSR7474CN/nIE8fY8gnk0MstOaBS
 ZGPgw7UWmcMw==
X-IronPort-AV: E=McAfee;i="6000,8403,9837"; a="172583156"
X-IronPort-AV: E=Sophos;i="5.78,425,1599548400"; 
   d="scan'208";a="172583156"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 15:36:45 -0800
IronPort-SDR: RaqASg+pB3JJYYbBYCEK1RjfnMIoK1AA+jTu2+jjwGtFeRzUSG+OnCDVWnUpDrw2Up79ITda2b
 UON1BDaN005A==
X-IronPort-AV: E=Sophos;i="5.78,425,1599548400"; 
   d="scan'208";a="352888758"
Received: from jumaanew-mobl2.amr.corp.intel.com ([10.254.73.12])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 15:36:45 -0800
Date:   Wed, 16 Dec 2020 15:36:45 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: Re: [PATCH net 1/4] mptcp: fix security context on server socket
In-Reply-To: <1bf3ee9b0c79a1e619fe4749d926aab71f0a7bcc.1608114076.git.pabeni@redhat.com>
Message-ID: <79aeed3-e480-9e5c-6498-40893e81f1f4@linux.intel.com>
References: <cover.1608114076.git.pabeni@redhat.com> <1bf3ee9b0c79a1e619fe4749d926aab71f0a7bcc.1608114076.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Dec 2020, Paolo Abeni wrote:

> Currently MPTCP is not propagating the security context
> from the ingress request socket to newly created msk
> at clone time.
>
> Address the issue invoking the missing security helper.
>
> Fixes: cf7da0d66cc1 ("mptcp: Create SUBFLOW socket for incoming connections")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/protocol.c | 2 ++
> 1 file changed, 2 insertions(+)
>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
