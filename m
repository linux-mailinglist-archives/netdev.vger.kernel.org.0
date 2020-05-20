Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 056D01DC0F4
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 23:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728319AbgETVIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 17:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728046AbgETVIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 17:08:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5684C061A0E;
        Wed, 20 May 2020 14:08:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1EB0F1210A409;
        Wed, 20 May 2020 14:08:45 -0700 (PDT)
Date:   Wed, 20 May 2020 14:08:42 -0700 (PDT)
Message-Id: <20200520.140842.1711606625827492143.davem@davemloft.net>
To:     jhubbard@nvidia.com
Cc:     syzbot+118ac0af4ac7f785a45b@syzkaller.appspotmail.com,
        akpm@linux-foundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        rds-devel@oss.oracle.com, santosh.shilimkar@oracle.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] rds: fix crash in rds_info_getsockopt()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200520194147.127137-1-jhubbard@nvidia.com>
References: <00000000000000d71e05a6185662@google.com>
        <20200520194147.127137-1-jhubbard@nvidia.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 May 2020 14:08:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>
Date: Wed, 20 May 2020 12:41:47 -0700

> The conversion to pin_user_pages() had a bug: it overlooked
> the case of allocation of pages failing. Fix that by restoring
> an equivalent check.
> 
> Reported-by: syzbot+118ac0af4ac7f785a45b@syzkaller.appspotmail.com
> Fixes: dbfe7d74376e ("rds: convert get_user_pages() --> pin_user_pages()")
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Applied to net-next, thanks.
