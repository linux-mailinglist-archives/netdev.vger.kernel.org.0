Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23096500A65
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 11:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbiDNJuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 05:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiDNJuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 05:50:21 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5BB6393;
        Thu, 14 Apr 2022 02:47:56 -0700 (PDT)
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1new4o-0005MU-Dc; Thu, 14 Apr 2022 11:47:46 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1new4o-000Xad-41; Thu, 14 Apr 2022 11:47:46 +0200
Subject: Re: [RFC PATCH 0/1] sample: bpf: introduce irqlat
To:     Song Chen <chensong_2000@189.cn>, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1649927240-18991-1-git-send-email-chensong_2000@189.cn>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2e6ee265-903c-2b5c-aefd-ec24f930c999@iogearbox.net>
Date:   Thu, 14 Apr 2022 11:47:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1649927240-18991-1-git-send-email-chensong_2000@189.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26512/Thu Apr 14 10:28:56 2022)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/14/22 11:07 AM, Song Chen wrote:
> I'm planning to implement a couple of ebpf tools for preempt rt,
> including irq latency, preempt latency and so on, how does it sound
> to you?

Sounds great, thanks! Please add these tools for upstream inclusion either to bpftrace [0] or
bcc [1], then a wider range of users would be able to benefit from them as well as they are
also shipped as distro packages and generally more widely used compared to kernel samples.

Thanks Song!

   [0] https://github.com/iovisor/bpftrace/tree/master/tools
   [1] https://github.com/iovisor/bcc/tree/master/libbpf-tools

> Song Chen (1):
>    sample: bpf: introduce irqlat
> 
>   samples/bpf/.gitignore    |   1 +
>   samples/bpf/Makefile      |   5 ++
>   samples/bpf/irqlat_kern.c |  81 ++++++++++++++++++++++++++++++
>   samples/bpf/irqlat_user.c | 100 ++++++++++++++++++++++++++++++++++++++
>   4 files changed, 187 insertions(+)
>   create mode 100644 samples/bpf/irqlat_kern.c
>   create mode 100644 samples/bpf/irqlat_user.c
> 

