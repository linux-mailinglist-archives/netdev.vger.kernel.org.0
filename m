Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC5E526528
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 16:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381257AbiEMOrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 10:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358226AbiEMOq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 10:46:58 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3AA3483AB;
        Fri, 13 May 2022 07:46:28 -0700 (PDT)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1npWYk-000BJn-I1; Fri, 13 May 2022 16:46:26 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1npWYk-000BED-7X; Fri, 13 May 2022 16:46:26 +0200
Subject: Re: [PATCHv2 bpf-next 0/2] selftests/bpf: fix ima_setup.sh missing
 issue
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        linux-kselftest@vger.kernel.org, bpf@vger.kernel.org
References: <20220513010110.319061-1-liuhangbin@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f602858b-98c8-9b82-7b00-f2716ff15071@iogearbox.net>
Date:   Fri, 13 May 2022 16:46:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220513010110.319061-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26540/Fri May 13 10:03:59 2022)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/13/22 3:01 AM, Hangbin Liu wrote:
> The ima_setup.sh is needed by test_progs test_ima. But the file is
> missed if we build test_progs separately or installed bpf test to
> another folder. This patch set fixed the issue in 2 different
> scenarios.
> 
> v2: no code update, just repost to bpf-next

Is this against an old tree? This doesn't apply to bpf-next, fwiw, please
rebase your series.

> Hangbin Liu (2):
>    selftests/bpf: Fix build error with ima_setup.sh
>    selftests/bpf: add missed ima_setup.sh in Makefile
> 
>   tools/testing/selftests/bpf/Makefile | 11 ++++++-----
>   1 file changed, 6 insertions(+), 5 deletions(-)
> 

Thanks,
Daniel
