Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2843714D257
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 22:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbgA2VKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 16:10:06 -0500
Received: from mga03.intel.com ([134.134.136.65]:46432 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727208AbgA2VKG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jan 2020 16:10:06 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 13:10:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,379,1574150400"; 
   d="scan'208";a="429805093"
Received: from cmossx-mobl1.amr.corp.intel.com ([10.251.7.89])
  by fmsmga006.fm.intel.com with ESMTP; 29 Jan 2020 13:10:04 -0800
Date:   Wed, 29 Jan 2020 13:10:04 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@cmossx-mobl1.amr.corp.intel.com
To:     Geert Uytterhoeven <geert@linux-m68k.org>
cc:     Paolo Abeni <pabeni@redhat.com>, Florian Westphal <fw@strlen.de>,
        Christoph Paasch <cpaasch@apple.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mptcp: Fix incorrect IPV6 dependency check
In-Reply-To: <20200129180117.545-1-geert@linux-m68k.org>
Message-ID: <alpine.OSX.2.21.2001291308450.9282@cmossx-mobl1.amr.corp.intel.com>
References: <20200129180117.545-1-geert@linux-m68k.org>
User-Agent: Alpine 2.21 (OSX 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jan 2020, Geert Uytterhoeven wrote:

> If CONFIG_MPTCP=y, CONFIG_MPTCP_IPV6=n, and CONFIG_IPV6=m:
>
>    net/mptcp/protocol.o: In function `__mptcp_tcp_fallback':
>    protocol.c:(.text+0x786): undefined reference to `inet6_stream_ops'
>
> Fix this by checking for CONFIG_MPTCP_IPV6 instead of CONFIG_IPV6, like
> is done in all other places in the mptcp code.
>
> Fixes: 8ab183deb26a3b79 ("mptcp: cope with later TCP fallback")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>


--
Mat Martineau
Intel
