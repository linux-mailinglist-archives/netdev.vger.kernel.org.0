Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8578E3429F4
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 03:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhCTCRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 22:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhCTCRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 22:17:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0726BC061760;
        Fri, 19 Mar 2021 19:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Type:MIME-Version:
        References:Message-ID:In-Reply-To:Subject:cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IA73I/1Q4ljXGa9sXgEYE5o60oxpvFT5RGp43jgdUZI=; b=oT1daocC/37cd1COpnbbd3BeV0
        MtINmjA+3WKboa18UO3AFUWpkq/JC78nqf7ZqhP3lyvqbP21QlrEh0vntP04PXYEdRkXGpUXUxyhs
        em/3ieJH16VYASnhsGtGOL6sJdqJge4/9E6/qfBhXJZg8x9PNskUs6JzeqJgBG+iUOv1yOh70R0EK
        DHxGr7U4Ndnw/lKsXmQ5NiUEPp3BxMi42Izlg38k/w41YS4xJh+g30N6Ut0hanr5iIxuTfK8PKBK1
        SP2YCvtThGg+poc9uTlQybvbw1/ag3lBIUSTyvUw/1Yrbrh4aTvZKiR6KtD5PzXTlEj+TiRLLyUqP
        aE9IGPYw==;
Received: from rdunlap (helo=localhost)
        by bombadil.infradead.org with local-esmtp (Exim 4.94 #2 (Red Hat Linux))
        id 1lNRBK-001ejd-M6; Sat, 20 Mar 2021 02:17:39 +0000
Date:   Fri, 19 Mar 2021 19:17:38 -0700 (PDT)
From:   Randy Dunlap <rdunlap@bombadil.infradead.org>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
cc:     davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: net: forwarding: Fix a typo
In-Reply-To: <20210318232945.17834-1-unixbhaskar@gmail.com>
Message-ID: <f9256be2-5b5-fdb5-8e12-771c2f952e15@bombadil.infradead.org>
References: <20210318232945.17834-1-unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: Randy Dunlap <rdunlap@infradead.org>
X-CRM114-Version: 20100106-BlameMichelson ( TRE 0.8.0 (BSD) ) MR-646709E3 
X-CRM114-CacheID: sfid-20210319_191738_746279_4CAB6813 
X-CRM114-Status: GOOD (  11.75  )
X-Spam-Score: -0.0 (/)
X-Spam-Report: Spam detection software, running on the system "bombadil.infradead.org",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 Content preview:  On Fri, 19 Mar 2021, Bhaskar Chowdhury wrote: > s/verfied/verified/
    > > Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com> Acked-by: Randy
    Dunlap <rdunlap@infradead.org> 
 Content analysis details:   (-0.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -0.0 NO_RELAYS              Informational: message was not relayed via SMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Fri, 19 Mar 2021, Bhaskar Chowdhury wrote:

> s/verfied/verified/
>
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>


> ---
> tools/testing/selftests/net/forwarding/fib_offload_lib.sh | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/net/forwarding/fib_offload_lib.sh b/tools/testing/selftests/net/forwarding/fib_offload_lib.sh
> index 66496659bea7..e134a5f529c9 100644
> --- a/tools/testing/selftests/net/forwarding/fib_offload_lib.sh
> +++ b/tools/testing/selftests/net/forwarding/fib_offload_lib.sh
> @@ -224,7 +224,7 @@ fib_ipv4_plen_test()
> 	ip -n $ns link set dev dummy1 up
>
> 	# Add two routes with the same key and different prefix length and
> -	# make sure both are in hardware. It can be verfied that both are
> +	# make sure both are in hardware. It can be verified that both are
> 	# sharing the same leaf by checking the /proc/net/fib_trie
> 	ip -n $ns route add 192.0.2.0/24 dev dummy1
> 	ip -n $ns route add 192.0.2.0/25 dev dummy1
> --
> 2.26.2
>
>
