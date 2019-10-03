Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9DC8C9596
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 02:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbfJCAZ1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Oct 2019 20:25:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38748 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfJCAZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 20:25:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E3C1B155283C1;
        Wed,  2 Oct 2019 17:25:26 -0700 (PDT)
Date:   Wed, 02 Oct 2019 17:25:26 -0700 (PDT)
Message-Id: <20191002.172526.1832563406015085740.davem@davemloft.net>
To:     j.neuschaefer@gmx.net
Cc:     linux-doc@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        corbet@lwn.net, snelson@pensando.io, drivers@pensando.io,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: networking: device drivers: Remove
 stray asterisks
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191002150956.16234-1-j.neuschaefer@gmx.net>
References: <20191002150956.16234-1-j.neuschaefer@gmx.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 02 Oct 2019 17:25:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Date: Wed,  2 Oct 2019 17:09:55 +0200

> These asterisks were once references to a line that said:
>   "* Other names and brands may be claimed as the property of others."
> But now, they serve no purpose; they can only irritate the reader.
> 
> Fixes: de3edab4276c ("e1000: update README for e1000")
> Fixes: a3fb65680f65 ("e100.txt: Cleanup license info in kernel doc")
> Fixes: da8c01c4502a ("e1000e.txt: Add e1000e documentation")
> Fixes: f12a84a9f650 ("Documentation: fm10k: Add kernel documentation")
> Fixes: b55c52b1938c ("igb.txt: Add igb documentation")
> Fixes: c4e9b56e2442 ("igbvf.txt: Add igbvf Documentation")
> Fixes: d7064f4c192c ("Documentation/networking/: Update Intel wired LAN driver documentation")
> Fixes: c4b8c01112a1 ("ixgbevf.txt: Update ixgbevf documentation")
> Fixes: 1e06edcc2f22 ("Documentation: i40e: Prepare documentation for RST conversion")
> Fixes: 105bf2fe6b32 ("i40evf: add driver to kernel build system")
> Fixes: 1fae869bcf3d ("Documentation: ice: Prepare documentation for RST conversion")
> Fixes: df69ba43217d ("ionic: Add basic framework for IONIC Network device driver")
> Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

Jon, how do you want to handle changes like this?

I mean, there are unlikely to be conflicts from something like this so it
could simply go via the documentation tree.

Acked-by: David S. Miller <davem@davemloft.net>

I could also take it via net-next, either way is fine with me.

Just let me know.
