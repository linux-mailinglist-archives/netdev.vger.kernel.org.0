Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5B214C7107
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 16:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237668AbiB1Pyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 10:54:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237667AbiB1Pyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 10:54:31 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB97E11A1E;
        Mon, 28 Feb 2022 07:53:52 -0800 (PST)
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nOiLJ-000F04-J5; Mon, 28 Feb 2022 16:53:45 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nOiLJ-0000ts-3v; Mon, 28 Feb 2022 16:53:45 +0100
Subject: Re: [PATCH v2 sysctl-next] bpf: move the bpf syscall sysctl table to
 bpf module
To:     Yan Zhu <zhuyan34@huawei.com>, mcgrof@kernel.org
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, keescook@chromium.org,
        kpsingh@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, liucheng32@huawei.com,
        netdev@vger.kernel.org, nixiaoming@huawei.com,
        songliubraving@fb.com, xiechengliang1@huawei.com, yhs@fb.com,
        yzaikin@google.com, zengweilin@huawei.com
References: <YhWQ+0qPorcJ/Z8l@bombadil.infradead.org>
 <20220223102808.80846-1-zhuyan34@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <df1146a2-c718-fa6c-ec35-de75ff27484f@iogearbox.net>
Date:   Mon, 28 Feb 2022 16:53:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220223102808.80846-1-zhuyan34@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26467/Mon Feb 28 10:24:05 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yan,

On 2/23/22 11:28 AM, Yan Zhu wrote:
> Aggregating the code of the feature in the code file of the feature
> itself can improve readability and reduce merge conflicts. So move
> the bpf syscall sysctl table to kernel/bpf/syscall.c
> 
> Signed-off-by: Yan Zhu <zhuyan34@huawei.com>
> 
> ---
> v1->v2:
>    1.Added patch branch identifier sysctl-next.
>    2.Re-describe the reason for the patch submission.

I'm not applying it given there is very little value in this change, see also what
has been said earlier:

https://lore.kernel.org/bpf/CAADnVQKmBoQEG1+nmrCg2ePVncn9rZJX9R4eucP9ULiY=xVGjQ@mail.gmail.com/

Thanks,
Daniel
