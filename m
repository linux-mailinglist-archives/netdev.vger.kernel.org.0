Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0097A281E5A
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 00:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725808AbgJBW31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 18:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgJBW31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 18:29:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84697C0613D0;
        Fri,  2 Oct 2020 15:29:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E9B2B11E48261;
        Fri,  2 Oct 2020 15:12:38 -0700 (PDT)
Date:   Fri, 02 Oct 2020 15:29:25 -0700 (PDT)
Message-Id: <20201002.152925.826224771231840847.davem@davemloft.net>
To:     colyli@suse.de
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, chaitanya.kulkarni@wdc.com,
        cleech@redhat.com, hch@lst.de, amwang@redhat.com,
        eric.dumazet@gmail.com, hare@suse.de, idryomov@gmail.com,
        jack@suse.com, jlayton@kernel.org, axboe@kernel.dk,
        lduncan@suse.com, michaelc@cs.wisc.edu,
        mskorzhinskiy@solarflare.com, philipp.reisner@linbit.com,
        sagi@grimberg.me, vvs@virtuozzo.com, vbabka@suse.com
Subject: Re: [PATCH v9 0/7] Introduce sendpage_ok() to detect misused
 sendpage in network related drivers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <3a46f056-8314-4467-4a11-40d11ddad99e@suse.de>
References: <20201001.124345.2303686561459641833.davem@davemloft.net>
        <20201001.124815.793423380665613978.davem@davemloft.net>
        <3a46f056-8314-4467-4a11-40d11ddad99e@suse.de>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 02 Oct 2020 15:12:39 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Coly Li <colyli@suse.de>
Date: Fri, 2 Oct 2020 16:30:12 +0800

> Obviously my fault and no excuse for leaking this uncompleted version to
> you. I just re-post a v10 version which I make sure all patches are the
> latest version.
> 
> Sorry for the inconvenience and thank you in advance for taking this set.

How did this happen?

How did you functionally test the patch set if it didn't even compile?

I want you to explain why you sent a completely untested patch set.
