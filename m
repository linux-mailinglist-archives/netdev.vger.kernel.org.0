Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACA821974F0
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 09:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729438AbgC3HLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 03:11:41 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:49352 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728685AbgC3HLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 03:11:41 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jIoa2-005FIC-6k; Mon, 30 Mar 2020 09:11:30 +0200
Message-ID: <a87a06a85bbb41bdc98600ac6d05c8e4d56e57be.camel@sipsolutions.net>
Subject: Re: 5.6.0-rc7+ fails to connect to wifi network
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Chris Clayton <chris2553@googlemail.com>,
        Jouni Malinen <jouni@codeaurora.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Date:   Mon, 30 Mar 2020 09:11:28 +0200
In-Reply-To: <2fae533d-8b38-3462-f862-aab60b9bd419@googlemail.com>
References: <870207cc-2b47-be26-33b6-ec3971122ab8@googlemail.com>
         <58a4d4b4-a372-9f38-2ceb-8386f8444d61@googlemail.com>
         <20200329195109.GA10156@jouni.qca.qualcomm.com>
         <2fae533d-8b38-3462-f862-aab60b9bd419@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-03-29 at 20:45 +0000, Chris Clayton wrote:

> > https://patchwork.kernel.org/patch/11464207/
> > 
>   CC [M]  net/mac80211/tx.o
> In file included from ./include/linux/export.h:43,
>                  from ./include/linux/linkage.h:7,
>                  from ./include/linux/kernel.h:8,
>                  from net/mac80211/tx.c:13:
> net/mac80211/tx.c: In function 'ieee80211_tx_dequeue':
> net/mac80211/tx.c:3613:37: error: 'struct ieee80211_hdr' has no member named 'fc'
>  3613 |   if (unlikely(ieee80211_is_data(hdr->fc) &&
>       |                                     ^~
> ./include/linux/compiler.h:78:42: note: in definition of macro 'unlikely'
>    78 | # define unlikely(x) __builtin_expect(!!(x), 0)
>       |                                          ^
> make[2]: *** [scripts/Makefile.build:267: net/mac80211/tx.o] Error 1
> make[1]: *** [scripts/Makefile.build:505: net/mac80211] Error 2
> make: *** [Makefile:1683: net] Error 2
> make: *** Waiting for unfinished jobs....

Yeah, sorry. I saw that, and did something wrong in "git commit --amend" 
so the change didn't get sent out. Or maybe I just forgot something.

Sadly it _just_ missed 5.6, but it's here now:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=be8c827f50a0bcd56361b31ada11dc0a3c2fd240

My apologies!

johannes

