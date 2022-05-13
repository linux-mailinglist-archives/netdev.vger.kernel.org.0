Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18C84526592
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 17:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381671AbiEMPC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 11:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381684AbiEMPBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 11:01:49 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160523ED17;
        Fri, 13 May 2022 08:01:43 -0700 (PDT)
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1npWnL-000Cqj-Rq; Fri, 13 May 2022 17:01:31 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1npWnL-0006OI-At; Fri, 13 May 2022 17:01:31 +0200
Subject: Re: [PATCH bpf-next v3 0/2] Introduce access remote cpu elem support
 in BPF percpu map
To:     Feng zhou <zhoufeng.zf@bytedance.com>, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, jolsa@kernel.org, davemarchevsky@fb.com,
        joannekoong@fb.com, geliang.tang@suse.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, duanxiongchun@bytedance.com,
        songmuchun@bytedance.com, wangdongdong.6@bytedance.com,
        cong.wang@bytedance.com, zhouchengming@bytedance.com,
        yosryahmed@google.com
References: <20220513063952.41794-1-zhoufeng.zf@bytedance.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d8447eee-31d0-f730-bc31-7e55c76135f4@iogearbox.net>
Date:   Fri, 13 May 2022 17:01:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220513063952.41794-1-zhoufeng.zf@bytedance.com>
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

On 5/13/22 8:39 AM, Feng zhou wrote:
[...]
> Changelog:
> ----------
> v2->v3: Addressed comments from Andrii Nakryiko.
> - use /* */ instead of //
> - use libbpf_num_possible_cpus() instead of sysconf(_SC_NPROCESSORS_ONLN)
> - use 8 bytes for value size
> - fix memory leak
> - use ASSERT_EQ instead of ASSERT_OK
> - add bpf_loop to fetch values on each possible CPU
> some details in here:
> https://lore.kernel.org/lkml/20220511093854.411-1-zhoufeng.zf@bytedance.com/T/

The v2 of your series is already in bpf-next tree, please just send a relative diff for
the selftest patch.

https://lore.kernel.org/lkml/165231901346.29050.11394051230756915389.git-patchwork-notify@kernel.org/

Thanks,
Daniel
