Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B44702242C8
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 20:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgGQSDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 14:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbgGQSDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 14:03:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4462C0619D2
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 11:03:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 97C10135962EA;
        Fri, 17 Jul 2020 11:03:00 -0700 (PDT)
Date:   Fri, 17 Jul 2020 11:02:59 -0700 (PDT)
Message-Id: <20200717.110259.1742782189944982464.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     sundeep.lkml@gmail.com, sbhatta@marvell.com,
        richardcochran@gmail.com, netdev@vger.kernel.org,
        sgoutham@marvell.com, amakarov@marvell.com
Subject: Re: [PATCH v4 net-next 3/3] octeontx2-pf: Add support for PTP clock
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200717104812.1a92abcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200716171109.7d8c6d17@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CALHRZupxX5Cbvb03s-xxA7gobjwo8cM7n4_-U6oGysU3R18-Bw@mail.gmail.com>
        <20200717104812.1a92abcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jul 2020 11:03:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Fri, 17 Jul 2020 10:48:12 -0700

> On Fri, 17 Jul 2020 10:41:49 +0530 sundeep subbaraya wrote:
>> I can separate this out and put in another patch #4 if you insist.
> 
> Does someone need to insist for you to fix your bugs in the current
> release cycle? That's a basic part of the kernel release process :/

Please submit the bug fix for the 'net' tree.

Wait for the net tree to eventually get merged into net-next.

Then you can resubmit this series on top.

That's how we do development, and we would appreciate it if you
would submit bug fixes and new features properly.

Thank you.
