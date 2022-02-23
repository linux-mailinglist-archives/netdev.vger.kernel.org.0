Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 347C54C0F8D
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 10:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239392AbiBWJuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 04:50:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbiBWJuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 04:50:54 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE1BA8878F;
        Wed, 23 Feb 2022 01:50:26 -0800 (PST)
Received: from dggeme762-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4K3WPY6qKtzbbbh;
        Wed, 23 Feb 2022 17:45:53 +0800 (CST)
Received: from linux-suse12sp5.huawei.com (10.67.133.175) by
 dggeme762-chm.china.huawei.com (10.3.19.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Wed, 23 Feb 2022 17:50:24 +0800
From:   Yan Zhu <zhuyan34@huawei.com>
To:     <alexei.starovoitov@gmail.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <john.fastabend@gmail.com>, <kafai@fb.com>,
        <keescook@chromium.org>, <kpsingh@kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <liucheng32@huawei.com>, <mcgrof@kernel.org>,
        <netdev@vger.kernel.org>, <nixiaoming@huawei.com>,
        <songliubraving@fb.com>, <xiechengliang1@huawei.com>, <yhs@fb.com>,
        <yzaikin@google.com>, <zengweilin@huawei.com>,
        <zhuyan34@huawei.com>
Subject: Re: [PATCH] bpf: move the bpf syscall sysctl table to its own module
Date:   Wed, 23 Feb 2022 17:50:19 +0800
Message-ID: <20220223095019.80080-1-zhuyan34@huawei.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <CAADnVQKmBoQEG1+nmrCg2ePVncn9rZJX9R4eucP9ULiY=xVGjQ@mail.gmail.com>
References: <CAADnVQKmBoQEG1+nmrCg2ePVncn9rZJX9R4eucP9ULiY=xVGjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.133.175]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeme762-chm.china.huawei.com (10.3.19.108)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 9:06 PM Alexei Starovoitov wrote:
> On Tue, Feb 22, 2022 at 5:35 PM Yan Zhu <zhuyan34@huawei.com> wrote:
> >
> > Sysctl table is easier to read under its own module.
> 
> "own module"?
> What are you talking about?
I'm sorry I didn't express it clearly. The meaning here is that
the code of bpf syscall sysctl is moved to the bpf module

I will fix it in v2 patch.

> It's not "easier to read" and looks like a pointless churn.

