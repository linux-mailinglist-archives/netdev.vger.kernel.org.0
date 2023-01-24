Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9286790F2
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 07:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbjAXGar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 01:30:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232847AbjAXG37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 01:29:59 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B7F3E09C;
        Mon, 23 Jan 2023 22:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4u7sdeygL2SI0vuOn3AQXqOOeojipj5nJ8JBXiSMSP4=; b=Y1N1Bp85zWT1Yc4mWO5RM/5swn
        z1s/ae7nZBU1XI2LeDBAOv+06U0Bu1PJWHXCDrEjlbbph1xr+oh6cmoXIod4hdcTSIhg05KsUMsH6
        Mt0SAUZbeNMdj95LikeyPio6/J/WyHzPQbupOE2KMJ+OXZv8xSLLdBNtO7Ot/A8dx2JalSA7ubKi2
        aFuBB1XW7qW1wiu2y2b/BJd4x/N6dLqevlGltWAruZGC7j2J5NPe6Xz6f5IgVH1uIF87LFk4mGzQ9
        1iI2DWcT8gQ30YpVU8YQ5BM2WIzRNm5oNr5lR1NU6lLpwGy0B15qzrZcjDOK9MRUi3zNGYFfM5749
        r4m38yZA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pKCny-002Vim-8c; Tue, 24 Jan 2023 06:29:14 +0000
Date:   Mon, 23 Jan 2023 22:29:14 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, jhubbard@nvidia.com,
        tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com,
        mkoutny@suse.com, daniel@ffwll.ch, linuxppc-dev@lists.ozlabs.org,
        linux-fpga@vger.kernel.org, linux-rdma@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org,
        bpf@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 01/19] mm: Introduce vm_account
Message-ID: <Y896ugI8HoXDRjp3@infradead.org>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <748338ffe4c42d86669923159fe0426808ecb04d.1674538665.git-series.apopple@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <748338ffe4c42d86669923159fe0426808ecb04d.1674538665.git-series.apopple@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/**
> + * vm_account_init - Initialise a new struct vm_account.
> + * @vm_account: pointer to uninitialised vm_account.
> + * @task: task to charge against.
> + * @user: user to charge against. Must be non-NULL for VM_ACCOUNT_USER.
> + * @flags: flags to use when charging to vm_account.
> + *
> + * Initialise a new uninitialiused struct vm_account. Takes references
> + * on the task/mm/user/cgroup as required although callers must ensure
> + * any references passed in remain valid for the duration of this
> + * call.
> + */
> +void vm_account_init(struct vm_account *vm_account, struct task_struct *task,
> +		struct user_struct *user, enum vm_account_flags flags);


kerneldoc comments are supposed to be next to the implementation, and
not the declaration in the header.

