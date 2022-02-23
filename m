Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2944C07C3
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 03:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236775AbiBWCYp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 22 Feb 2022 21:24:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233174AbiBWCYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 21:24:44 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F9C38798;
        Tue, 22 Feb 2022 18:24:17 -0800 (PST)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4K3KVm6hR1z1FDC2;
        Wed, 23 Feb 2022 10:19:44 +0800 (CST)
Received: from dggeme762-chm.china.huawei.com (10.3.19.108) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.21; Wed, 23 Feb 2022 10:24:15 +0800
Received: from dggeme762-chm.china.huawei.com ([10.8.68.53]) by
 dggeme762-chm.china.huawei.com ([10.8.68.53]) with mapi id 15.01.2308.021;
 Wed, 23 Feb 2022 10:24:15 +0800
From:   "zhuyan (M)" <zhuyan34@huawei.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
CC:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "yzaikin@google.com" <yzaikin@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Zengweilin <zengweilin@huawei.com>,
        "liucheng (G)" <liucheng32@huawei.com>,
        Nixiaoming <nixiaoming@huawei.com>,
        xiechengliang <xiechengliang1@huawei.com>
Subject: Re: [PATCH] bpf: move the bpf syscall sysctl table to its own module
Thread-Topic: [PATCH] bpf: move the bpf syscall sysctl table to its own module
Thread-Index: AdgoXFmzqljRJYDFQxeMKq5SCoOUoA==
Date:   Wed, 23 Feb 2022 02:24:14 +0000
Message-ID: <457a005e9fc84eeea93a19f99c11a683@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.108.69]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 23, 2022 at 09:42:00AM +0800, Luis Chamberlain wrote:
> On Wed, Feb 23, 2022 at 09:35:29AM +0800, Yan Zhu wrote:
> > Sysctl table is easier to read under its own module.
> 
> Hey Yan, thanks for you patch!
> 
> This does not explain how this is being to help with maitenance as otherwise this makes
> kernel/sysctl.c hard to maintain and we also tend to get many conflicts. It also does not
> explain how all the filesystem sysctls are not gone and that this is just the next step, 
> moving slowly the rest of the sysctls. Explaining this in the commit log will help patch
> review and subsystem maintainers understand the conext / logic behind the move.
> 
> I'd be more than happy to take this if bpf folks Ack. To avoid conflicts I can route this
> through sysctl-next which is put forward in particular to avoid conflicts across trees for
> this effort. Let me know.

Thank you for your reply. 

My patch is based on sysctl-next, sorry I forgot to identify it as a patch from the
sysctl-next branch. I will send the v2 patch later.
