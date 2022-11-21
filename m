Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2B56329BC
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 17:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbiKUQjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 11:39:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiKUQix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 11:38:53 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8948322A;
        Mon, 21 Nov 2022 08:38:48 -0800 (PST)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1ox9od-000Ixi-4J; Mon, 21 Nov 2022 17:38:39 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ox9oc-000Gc2-Bg; Mon, 21 Nov 2022 17:38:38 +0100
Subject: Re: [PATCH bpf 0/4] bpf, sockmap: Fix some issues with using
 apply_bytes
To:     Pengcheng Yang <yangpc@wangsu.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <1668598161-15455-1-git-send-email-yangpc@wangsu.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b32669ff-6cec-0966-20c2-b5598137ee48@iogearbox.net>
Date:   Mon, 21 Nov 2022 17:38:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1668598161-15455-1-git-send-email-yangpc@wangsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26727/Mon Nov 21 09:50:51 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/22 12:29 PM, Pengcheng Yang wrote:
> Patch 0001~0003 fixes three issues with using apply_bytes when redirecting.
> Patch 0004 adds ingress tests for txmsg with apply_bytes in selftests.
> 
> Pengcheng Yang (4):
>    bpf, sockmap: Fix repeated calls to sock_put() when msg has more_data
>    bpf, sockmap: Fix missing BPF_F_INGRESS flag when using apply_bytes
>    bpf, sockmap: Fix data loss caused by using apply_bytes on ingress
>      redirect
>    selftests/bpf: Add ingress tests for txmsg with apply_bytes

Patch 1 & 3 didn't make it to the list [0], could you resend your series?

   [0] https://lore.kernel.org/bpf/1668598161-15455-1-git-send-email-yangpc@wangsu.com/

>   include/linux/skmsg.h                      |  1 +
>   net/core/skmsg.c                           |  1 +
>   net/ipv4/tcp_bpf.c                         |  9 +++++++--
>   net/tls/tls_sw.c                           |  1 +
>   tools/testing/selftests/bpf/test_sockmap.c | 18 ++++++++++++++++++
>   5 files changed, 28 insertions(+), 2 deletions(-)
> 

