Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238C54C9ACF
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 02:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238970AbiCBB7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 20:59:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiCBB7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 20:59:32 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85BA5A167;
        Tue,  1 Mar 2022 17:58:50 -0800 (PST)
Received: from dggeme762-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4K7cgH4gNCzBrST;
        Wed,  2 Mar 2022 09:56:59 +0800 (CST)
Received: from linux-suse12sp5.huawei.com (10.67.133.175) by
 dggeme762-chm.china.huawei.com (10.3.19.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Wed, 2 Mar 2022 09:58:48 +0800
From:   Yan Zhu <zhuyan34@huawei.com>
To:     <mcgrof@kernel.org>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <john.fastabend@gmail.com>, <kafai@fb.com>,
        <keescook@chromium.org>, <kpsingh@kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <liucheng32@huawei.com>, <netdev@vger.kernel.org>,
        <nixiaoming@huawei.com>, <songliubraving@fb.com>,
        <xiechengliang1@huawei.com>, <yhs@fb.com>, <yzaikin@google.com>,
        <zengweilin@huawei.com>, <zhuyan34@huawei.com>
Subject: Re: [PATCH v2 sysctl-next] bpf: move the bpf syscall sysctl table to bpf module
Date:   Wed, 2 Mar 2022 09:58:42 +0800
Message-ID: <20220302015842.128491-1-zhuyan34@huawei.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <Yh1dtBTeRtjD0eGp@bombadil.infradead.org>
References: <Yh1dtBTeRtjD0eGp@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.133.175]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeme762-chm.china.huawei.com (10.3.19.108)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, 28 Feb 2022 15:41:40 -0800, Luis Chamberlain wrote:
> On Mon, Feb 28, 2022 at 04:53:44PM +0100, Daniel Borkmann wrote:
> > Hi Yan,
> > 
> > On 2/23/22 11:28 AM, Yan Zhu wrote:
> > > Aggregating the code of the feature in the code file of the feature
> > > itself can improve readability and reduce merge conflicts. So move
> > > the bpf syscall sysctl table to kernel/bpf/syscall.c
> > > 
> > > Signed-off-by: Yan Zhu <zhuyan34@huawei.com>
> > > 
> > > ---
> > > v1->v2:
> > >    1.Added patch branch identifier sysctl-next.
> > >    2.Re-describe the reason for the patch submission.
> > 
> > I'm not applying it given there is very little value in this change, see also what
> > has been said earlier:
> > 
> > https://lore.kernel.org/bpf/CAADnVQKmBoQEG1+nmrCg2ePVncn9rZJX9R4eucP9ULiY=xVGjQ@mail.gmail.com/
> 
> Daniel,
> 
> sorry folk are seing you patches with crap commit logs. The
> justification should be made clearer: we're moving sysctls out of
> kernel/sysctl.c as its a mess. I already moved all filesystem sysctls
> out. And with time the goal is to move all sysctls out to their own
> susbsystem/actual user.
> kernel/sysctl.c has grown to an insane mess and its easy to run
> into conflicts with it. The effort to move them out is part of this.
Luis,

Thanks for the suggestion, I will use it as my patch from the commit
message to be able to clearly describe the purpose of the patch.

> The commit logs should not suck though...

