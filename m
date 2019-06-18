Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C278F49A44
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 09:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbfFRHSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 03:18:38 -0400
Received: from mslow2.mail.gandi.net ([217.70.178.242]:58290 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfFRHSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 03:18:37 -0400
Received: from relay2-d.mail.gandi.net (unknown [217.70.183.194])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id 5B09B3A2057
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 06:38:51 +0000 (UTC)
X-Originating-IP: 90.88.23.150
Received: from bootlin.com (aaubervilliers-681-1-81-150.w90-88.abo.wanadoo.fr [90.88.23.150])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 698A640003;
        Tue, 18 Jun 2019 06:38:50 +0000 (UTC)
Date:   Tue, 18 Jun 2019 08:39:00 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: Cleanup of -Wunused-const-variable in
 drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
Message-ID: <20190618083900.78eb88bd@bootlin.com>
In-Reply-To: <CAJkfWY5ZuDsmV6u1p=DPZF84ijYS3Mu2NeySGgfCXgLGnruu_A@mail.gmail.com>
References: <CAJkfWY5ZuDsmV6u1p=DPZF84ijYS3Mu2NeySGgfCXgLGnruu_A@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Nathan,

On Thu, 13 Jun 2019 10:53:05 -0700
Nathan Huckleberry <nhuck@google.com> wrote:

>Hey all,
>
>I'm looking into cleaning up ignored warnings in the kernel so we can
>remove compiler flags to ignore warnings.
>
>There's an unused variable 'mvpp2_dbgfs_prs_pmap_fops' in
>mvpp2_debugfs.c. It looks like this code is for dumping useful
>information into userspace. I'd like to either remove the variable or
>dump it to userspace in the same way the other variables are.

Thanks for reporting this.

The ops should actually be used, fixing the warning should be as simple
as adding this into mvpp2_dbgfs_prs_entry_init :

+       debugfs_create_file("pmap", 0444, prs_entry_dir, entry,
+                           &mvpp2_dbgfs_prs_pmap_fops);
+

>Wanted to reach out for opinions on the best course of action before
>submitting a patch.

Can you submit a patch, or do you prefer me to do it ?

Thanks,

Maxime
