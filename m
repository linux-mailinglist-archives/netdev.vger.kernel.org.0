Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0BFE299114
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 16:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1783952AbgJZPeG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 26 Oct 2020 11:34:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:1757 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1783948AbgJZPeF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 11:34:05 -0400
IronPort-SDR: BeD7JecPN3cROovTRJAXgTsLaAmhfEZpyJJTA9Pmehi8Pbvnqpg/SgT3H3QgYakXtxPx3u3ELs
 jgwz75fWYjaw==
X-IronPort-AV: E=McAfee;i="6000,8403,9785"; a="164442767"
X-IronPort-AV: E=Sophos;i="5.77,420,1596524400"; 
   d="scan'208";a="164442767"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2020 08:34:03 -0700
IronPort-SDR: bHLp3u9rWJruRvlfdwSmKZnRsIzhkd/dyEO0u8F0t2jYAtmQIXcLIkmHHMiFzpJKAmYtlO/Mmp
 CzaD0IEmwM2Q==
X-IronPort-AV: E=Sophos;i="5.77,420,1596524400"; 
   d="scan'208";a="317893389"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.212.236.36])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2020 08:33:58 -0700
Date:   Mon, 26 Oct 2020 08:33:56 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Christian Langrock <christian.langrock@secunet.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <anthony.l.nguyen@intel.com>
Subject: Re: Subject: [PATCH net] drivers: net: ixgbe: Fix
 *_ipsec_offload_ok():, Use ip_hdr family
Message-ID: <20201026083356.00001999@intel.com>
In-Reply-To: <1581f61a-f405-008a-8f31-e9e696667d5a@secunet.com>
References: <1581f61a-f405-008a-8f31-e9e696667d5a@secunet.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Langrock wrote:

Please fix your subject, remove the word 'Subject: '

> Xfrm_dev_offload_ok() is called with the unencrypted SKB. So in case of
> interfamily ipsec traffic (IPv4-in-IPv6 and IPv6 in IPv4) the check
> assumes the wrong family of the skb (IP family of the state).
> With this patch the ip header of the SKB is used to determine the
> family.
> 

missing "Fixes: " line? It's useful here because I think this looks
like a good candidate for stable bug fix.

> Signed-off-by: Christian Langrock <christian.langrock@secunet.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c | 2 +-
>  drivers/net/ethernet/intel/ixgbevf/ipsec.c     | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

The patch looks ok otherwise, thanks!
