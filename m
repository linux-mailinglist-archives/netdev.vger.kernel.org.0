Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3AAF4FF943
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 16:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbiDMOsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 10:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236260AbiDMOrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 10:47:35 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEE23CFD0;
        Wed, 13 Apr 2022 07:45:13 -0700 (PDT)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1neeEw-000Duc-5q; Wed, 13 Apr 2022 16:45:02 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1neeEv-000Pag-LE; Wed, 13 Apr 2022 16:45:01 +0200
Subject: Re: [PATCH v4 sysctl-next] bpf: move bpf sysctls from kernel/sysctl.c
 to bpf module
To:     Yan Zhu <zhuyan34@huawei.com>, mcgrof@kernel.org
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, keescook@chromium.org,
        kpsingh@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, liucheng32@huawei.com,
        netdev@vger.kernel.org, nixiaoming@huawei.com,
        songliubraving@fb.com, xiechengliang1@huawei.com, yhs@fb.com,
        yzaikin@google.com, zengweilin@huawei.com, leeyou.li@huawei.com,
        laiyuanyuan.lai@huawei.com
References: <Yk4XE/hKGOQs5oq0@bombadil.infradead.org>
 <20220407070759.29506-1-zhuyan34@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3a82460b-6f58-6e7e-a3d9-141f42069eda@iogearbox.net>
Date:   Wed, 13 Apr 2022 16:45:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220407070759.29506-1-zhuyan34@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26511/Wed Apr 13 10:22:45 2022)
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/7/22 9:07 AM, Yan Zhu wrote:
> We're moving sysctls out of kernel/sysctl.c as its a mess. We
> already moved all filesystem sysctls out. And with time the goal is
> to move all sysctls out to their own subsystem/actual user.
> 
> kernel/sysctl.c has grown to an insane mess and its easy to run
> into conflicts with it. The effort to move them out is part of this.
> 
> Signed-off-by: Yan Zhu <zhuyan34@huawei.com>

Acked-by: Daniel Borkmann <daniel@iogearbox.net>

Given the desire is to route this via sysctl-next and we're not shortly
before but after the merge win, could we get a feature branch for bpf-next
to pull from to avoid conflicts with ongoing development cycle?

Thanks,
Daniel
