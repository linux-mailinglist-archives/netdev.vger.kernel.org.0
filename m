Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 220F4674ADB
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 05:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbjATEht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 23:37:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjATEhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 23:37:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E544BD15C;
        Thu, 19 Jan 2023 20:34:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BE3BB8200C;
        Thu, 19 Jan 2023 04:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687DBC433EF;
        Thu, 19 Jan 2023 04:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674103131;
        bh=nSxoYdjigztZycnvezceYi7+q11Ika9lX+K1p3DlcWk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AHu2lrF1ncE2tLq0F3+BGWcWAvfjH5q6L3XoKfM8LmOQuMoDQ6M6yIJSjHiAMMYxo
         zZeoAepiIimC95u5ZmLuUguxCICnadkWhBxOF3Kv0DWlTCPNx0VM8C1sDZia0c9HZE
         1pXOIWBW1z3CUBKJSOETIQsAP/eInR7Wbov9JvZxABuzBCI3OqMHaoYuDNZCmncww5
         eRxnZRsuyl5RMyd/2IGFoc+XiakgG2v7rFXJuj3iENCz4UtgFhjnpkpWDqM2U6Qq+3
         XFReZDhp3OFbrOTo1qyAyNhkbr7owOFQJDlDN5R5BKZi+jzHJEabqPAVwv8lKuVKLV
         yAn8rJszFI5NA==
Date:   Wed, 18 Jan 2023 20:38:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jon Maxwell <jmaxwell37@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, martin.lau@kernel.org,
        joel@joelfernandes.org, paulmck@kernel.org, eyal.birger@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrea.mayer@uniroma2.it
Subject: Re: [net-next v2] ipv6: Document that max_size sysctl is
 depreciated
Message-ID: <20230118203849.7c00187a@kernel.org>
In-Reply-To: <20230117221858.734596-1-jmaxwell37@gmail.com>
References: <20230117221858.734596-1-jmaxwell37@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Jan 2023 09:18:58 +1100 Jon Maxwell wrote:
> Subject: [net-next v2] ipv6: Document that max_size sysctl is depreciated
>
> v2: use correct commit syntax.

change log under the --- lines

> Document that max_size is depreciated due to:
> 
> af6d10345ca7 ("ipv6: remove max_size check inline with ipv4")

 ^ commit

the word "commit" should be there before the hash

> Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
> ---
>  Documentation/networking/ip-sysctl.rst | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index 7fbd060d6047..edf1fcd10c5c 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -156,6 +156,9 @@ route/max_size - INTEGER
>  	From linux kernel 3.6 onwards, this is deprecated for ipv4
>  	as route cache is no longer used.
>  
> +	From linux kernel 6.2 onwards, this is deprecated for ipv6

6.2 or 6.3? 6.2 is what's currently in Linus's tree, net-next 
is 6.3 and the commit in the commit msg is in net-next only.

> +	as garbage collection manages cached route entries.
