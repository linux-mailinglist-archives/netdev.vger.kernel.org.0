Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E46CD623BA4
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 07:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiKJGNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 01:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiKJGNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 01:13:52 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4449D26565;
        Wed,  9 Nov 2022 22:13:51 -0800 (PST)
Message-ID: <ba68a753-2024-d02f-cd47-8aba9f6d6715@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668060825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dYfMXbucASYlRNtyKAlY7JBTVHHLnJFyX2WUJ6aRo04=;
        b=BoaAOATzOZ+Z8Sb8jgZEgLXoco4czKtJ8OYM0uzZab1aTefq9AA39FsyvYzT/D302c2dnR
        Xl/3ooTYMoCzvG+j6n+ek9PEod7iFR8hbBJY3XWuBkCSsjiZjbqVnnLxHLsHJpzB4qWuVD
        X94CM7Lb0SrJ8A/pqGbRavU5nKnQrF4=
Date:   Wed, 9 Nov 2022 22:13:41 -0800
MIME-Version: 1.0
Subject: Re: [PATCH net-next 0/2] net: vlan: claim one bit from sk_buff
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        eric.dumazet@gmail.com, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
References: <20221109095759.1874969-1-edumazet@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20221109095759.1874969-1-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/9/22 1:57 AM, Eric Dumazet wrote:
> First patch claims skb->vlan_present.
> This means some bpf changes, eg for sparc32 that I could not test.
> 
> Second patch removes one conditional test in gro_list_prepare().

Acked-by: Martin KaFai Lau <martin.lau@kernel.org>

