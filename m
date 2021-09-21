Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A4E413DE5
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 01:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhIUXO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 19:14:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229794AbhIUXO6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 19:14:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3179461186;
        Tue, 21 Sep 2021 23:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632266009;
        bh=xUW3BYOkIl9e4ZYi95qx8LMJN3OtYQDJC1C33QFBs/U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gd0D13e8hvrudEyfxw79wpW3mtbHiKfc0IRhJ6VKhWyAGs9Ipix6J6KRm/WgcTDeN
         f42Bw3fJXMxcULH3g4amDG1DgL4khVT2jTv8kGuUUzCfAS+OtWw/x4XyRKoxf0x50x
         LDnFven6IqFdrhfmeb9eLTqInoO/saenlABFxWe2pCZ+8BiYDOd0hVdP5SloriKmar
         F1cKDVJHGl6e0+d7mT/leoU00UKjg/Xqw7ub8iVIOXnhF+fsYCKpPtPtTEIEIGPHlI
         uORzCi711E+zkzsiNTZ9nr7ip14q0oaoIbtD27II+WGw42x8szxa9v5UMQAl4X6NTn
         SZDzBpXLRVB8w==
Date:   Tue, 21 Sep 2021 16:13:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leonard Crestez <cdleonard@gmail.com>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/19] tcp: Initial support for RFC5925 auth option
Message-ID: <20210921161327.10b29c88@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cover.1632240523.git.cdleonard@gmail.com>
References: <cover.1632240523.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Sep 2021 19:14:43 +0300 Leonard Crestez wrote:
> This is similar to TCP MD5 in functionality but it's sufficiently
> different that wire formats are incompatible. Compared to TCP-MD5 more
> algorithms are supported and multiple keys can be used on the same
> connection but there is still no negotiation mechanism.

Hopefully there will be some feedback / discussion, but even if
everyone acks this you'll need to fix all the transient build
failures, and kdoc warnings added - and repost. 
git rebase --exec='make' and scripts/kernel-doc are your allies.
