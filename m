Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5B91D3E33
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728948AbgENT54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 15:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727117AbgENT5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 15:57:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B77C061A0C;
        Thu, 14 May 2020 12:57:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7E265128D325E;
        Thu, 14 May 2020 12:57:52 -0700 (PDT)
Date:   Thu, 14 May 2020 12:57:51 -0700 (PDT)
Message-Id: <20200514.125751.2175402701800030395.davem@davemloft.net>
To:     David.Laight@ACULAB.COM
Cc:     joe@perches.com, hch@lst.de, kuba@kernel.org, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, vyasevich@gmail.com,
        nhorman@tuxdriver.com, marcelo.leitner@gmail.com,
        jmaloy@redhat.com, ying.xue@windriver.com,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-nvme@lists.infradead.org, target-devel@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
        cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com,
        netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        ceph-devel@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-nfs@vger.kernel.org
Subject: Re: remove kernel_setsockopt and kernel_getsockopt
From:   David Miller <davem@davemloft.net>
In-Reply-To: <756758e8f0e34e2e97db470609f5fbba@AcuMS.aculab.com>
References: <20200513062649.2100053-1-hch@lst.de>
        <ecc165c33962d964d518c80de605af632eee0474.camel@perches.com>
        <756758e8f0e34e2e97db470609f5fbba@AcuMS.aculab.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 12:57:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Laight <David.Laight@ACULAB.COM>
Date: Thu, 14 May 2020 08:29:30 +0000

> You need to export functions that do most of the socket options
> for all protocols.

If all in-tree users of this stuff are converted, there is no argument
for keeping these routines.

You seemed to be concerned about out of tree stuff.  If so, that's not
of our concern.
