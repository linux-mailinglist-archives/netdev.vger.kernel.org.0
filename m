Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 156FA14D24D
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 22:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbgA2VII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 16:08:08 -0500
Received: from mga18.intel.com ([134.134.136.126]:61173 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727133AbgA2VIH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jan 2020 16:08:07 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 13:08:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,379,1574150400"; 
   d="scan'208";a="223945144"
Received: from cmossx-mobl1.amr.corp.intel.com ([10.251.7.89])
  by fmsmga008.fm.intel.com with ESMTP; 29 Jan 2020 13:08:04 -0800
Date:   Wed, 29 Jan 2020 13:08:04 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@cmossx-mobl1.amr.corp.intel.com
To:     Geert Uytterhoeven <geert@linux-m68k.org>
cc:     Paolo Abeni <pabeni@redhat.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mptcp: MPTCP_HMAC_TEST should depend on MPTCP
In-Reply-To: <20200129180224.700-1-geert@linux-m68k.org>
Message-ID: <alpine.OSX.2.21.2001291246140.9282@cmossx-mobl1.amr.corp.intel.com>
References: <20200129180224.700-1-geert@linux-m68k.org>
User-Agent: Alpine 2.21 (OSX 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, 29 Jan 2020, Geert Uytterhoeven wrote:

> As the MPTCP HMAC test is integrated into the MPTCP code, it can be
> built only when MPTCP is enabled.  Hence when MPTCP is disabled, asking
> the user if the test code should be enabled is futile.
>
> Wrap the whole block of MPTCP-specific config options inside a check for
> MPTCP.  While at it, drop the "default n" for MPTCP_HMAC_TEST, as that
> is the default anyway.
>
> Fixes: 65492c5a6ab5df50 ("mptcp: move from sha1 (v0) to sha256 (v1)")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
