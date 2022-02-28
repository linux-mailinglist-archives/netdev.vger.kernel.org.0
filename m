Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED9284C7E8A
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 00:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbiB1Xm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 18:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbiB1Xm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 18:42:29 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04916EBAFB;
        Mon, 28 Feb 2022 15:41:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EB9oE9Oa7EmtoZ1Lx803QHV2N2v7wotOXn74UfZHS+0=; b=cB9s1pIx16Y4LGAgwHkxzEhBJ/
        4fHVywdn15fIhMBTlSwjxeP6GAqFfbYARgdvSGkTTc13RV+1Gxvv4OojrS0KGNJSroguP3Uc0uuWb
        CKTPLVm/Yopu+qCmVQ0SAkVz2N9w7L4nzZKB/eGIlxvpdgD7IZQpNQjZ++FHjxk2XjX0fYtHRwNQe
        vXQdIKj4wmRnKIi7tPUGI1mPKhTLFLdKSodWM/jhZf9d/SXDiuzAXhq6s0enVmPneQ7GgI/E1hsy2
        OPA4p0oHWRDSu9Tfu9HsrdgL0ygWhpDI3BqaKoApeBMdz6/zM1K591v17H2r74LEmjAShj3dCeY3t
        ZXdAUydw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nOpe8-00EQ0Q-40; Mon, 28 Feb 2022 23:41:40 +0000
Date:   Mon, 28 Feb 2022 15:41:40 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Yan Zhu <zhuyan34@huawei.com>, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        keescook@chromium.org, kpsingh@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        liucheng32@huawei.com, netdev@vger.kernel.org,
        nixiaoming@huawei.com, songliubraving@fb.com,
        xiechengliang1@huawei.com, yhs@fb.com, yzaikin@google.com,
        zengweilin@huawei.com
Subject: Re: [PATCH v2 sysctl-next] bpf: move the bpf syscall sysctl table to
 bpf module
Message-ID: <Yh1dtBTeRtjD0eGp@bombadil.infradead.org>
References: <YhWQ+0qPorcJ/Z8l@bombadil.infradead.org>
 <20220223102808.80846-1-zhuyan34@huawei.com>
 <df1146a2-c718-fa6c-ec35-de75ff27484f@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df1146a2-c718-fa6c-ec35-de75ff27484f@iogearbox.net>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 28, 2022 at 04:53:44PM +0100, Daniel Borkmann wrote:
> Hi Yan,
> 
> On 2/23/22 11:28 AM, Yan Zhu wrote:
> > Aggregating the code of the feature in the code file of the feature
> > itself can improve readability and reduce merge conflicts. So move
> > the bpf syscall sysctl table to kernel/bpf/syscall.c
> > 
> > Signed-off-by: Yan Zhu <zhuyan34@huawei.com>
> > 
> > ---
> > v1->v2:
> >    1.Added patch branch identifier sysctl-next.
> >    2.Re-describe the reason for the patch submission.
> 
> I'm not applying it given there is very little value in this change, see also what
> has been said earlier:
> 
> https://lore.kernel.org/bpf/CAADnVQKmBoQEG1+nmrCg2ePVncn9rZJX9R4eucP9ULiY=xVGjQ@mail.gmail.com/

Daniel,

sorry folk are seing you patches with crap commit logs. The
justification should be made clearer: we're moving sysctls out of
kernel/sysctl.c as its a mess. I already moved all filesystem sysctls
out. And with time the goal is to move all sysctls out to their own
susbsystem/actual user.

kernel/sysctl.c has grown to an insane mess and its easy to run
into conflicts with it. The effort to move them out is part of this.

The commit logs should not suck though...

  Luis
