Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7685F14D4F1
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 02:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgA3BVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 20:21:52 -0500
Received: from mga17.intel.com ([192.55.52.151]:9156 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726618AbgA3BVv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jan 2020 20:21:51 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 17:21:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,380,1574150400"; 
   d="scan'208";a="428152425"
Received: from cmossx-mobl1.amr.corp.intel.com ([10.251.7.89])
  by fmsmga005.fm.intel.com with ESMTP; 29 Jan 2020 17:21:51 -0800
Date:   Wed, 29 Jan 2020 17:21:51 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@cmossx-mobl1.amr.corp.intel.com
To:     Linus Torvalds <torvalds@linux-foundation.org>
cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [GIT] Networking
In-Reply-To: <CAHk-=wizYS9W=N2S9b0F2XdMPFTx4MKk6iWjo8yq1aMfYaoZ2w@mail.gmail.com>
Message-ID: <alpine.OSX.2.22.394.2001291716590.19287@cmossx-mobl1.amr.corp.intel.com>
References: <20200128.172544.1405211638887784147.davem@davemloft.net> <CAHk-=wizYS9W=N2S9b0F2XdMPFTx4MKk6iWjo8yq1aMfYaoZ2w@mail.gmail.com>
User-Agent: Alpine 2.22 (OSX 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jan 2020, Linus Torvalds wrote:

> On Tue, Jan 28, 2020 at 8:26 AM David Miller <davem@davemloft.net> wrote:
>>
>> 12) Add initial support for MPTCP protocol, from Christoph Paasch,
>>     Matthieu Baerts, Florian Westphal, Peter Krystad, and many
>>     others.
>
> Hmm. This adds a MPTCP_HMAC_TEST config variable, and while it is
> "default n" (which is redundant - 'n' is the default anyway), it
> should likely instead be "depends on MPTCP".
>
> Because right now, if you say no to MPTCP, it will _still_ ask you
> about MPTCP_HMAC_TEST, which makes no sense. Even if you were to say
> 'y', there won't be any tests done since MPTCP isn't built at all.
>

Thanks for noting this. A fix is on the way:

https://patchwork.ozlabs.org/patch/1231045/

--
Mat Martineau
Intel
