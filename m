Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1D0404360
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 03:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349878AbhIIB5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 21:57:36 -0400
Received: from h2.fbrelay.privateemail.com ([131.153.2.43]:57079 "EHLO
        h2.fbrelay.privateemail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242103AbhIIB5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 21:57:32 -0400
Received: from MTA-09-3.privateemail.com (mta-09-1.privateemail.com [198.54.122.59])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by h1.fbrelay.privateemail.com (Postfix) with ESMTPS id CE8F780AA6
        for <netdev@vger.kernel.org>; Wed,  8 Sep 2021 21:56:22 -0400 (EDT)
Received: from mta-09.privateemail.com (localhost [127.0.0.1])
        by mta-09.privateemail.com (Postfix) with ESMTP id DDF701800227;
        Wed,  8 Sep 2021 21:56:20 -0400 (EDT)
Received: from [192.168.0.46] (unknown [10.20.151.225])
        by mta-09.privateemail.com (Postfix) with ESMTPA id F23511800209;
        Wed,  8 Sep 2021 21:56:18 -0400 (EDT)
Date:   Wed, 08 Sep 2021 21:56:12 -0400
From:   Hamza Mahfooz <someguy@effective-light.com>
Subject: Re: [PATCH] wireguard: convert index_hashtable and pubkey_hashtable
 into rhashtables
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>, Thomas Graf <tgraf@suug.ch>,
        Herbert Xu <herbert@gondor.apana.org.au>
Message-Id: <OD95ZQ.FW5WHNPSV04F@effective-light.com>
In-Reply-To: <CAHmME9oSo=4BtfO+=327n=gsor5gWcvhzAMS_BpqQ-6=6yxVRA@mail.gmail.com>
References: <20210806044315.169657-1-someguy@effective-light.com>
        <OD24ZQ.IQOQXX8U0YST@effective-light.com>
        <CAHmME9oSo=4BtfO+=327n=gsor5gWcvhzAMS_BpqQ-6=6yxVRA@mail.gmail.com>
X-Mailer: geary/40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Jason,
On Wed, Sep 8 2021 at 01:27:12 PM +0200, Jason A. Donenfeld 
<Jason@zx2c4.com> wrote:
> - What's performance like? Does the abstraction of rhashtable
> introduce overhead? These are used in fast paths -- for every packet
> -- so being quick is important.

Are you familiar with any (micro)benchmarks (for WireGuard) that, you
believe would be particularly informative in assessing the outlined
performance characteristics?

> - How does this interact with the timing side channel concerns in the
> comment of the file? Will the time required to find an unused index
> leak the number of items in the hash table? Do we need stochastic
> masking? Or is the construction of rhashtable such that we always get
> ball-park same time?

I think the maintainers of rhashtable are best positioned to answer 
these
questions (I have cc'd them).


