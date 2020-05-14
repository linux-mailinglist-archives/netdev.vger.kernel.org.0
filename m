Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31661D3E54
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 22:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgENUCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 16:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727850AbgENUCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 16:02:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C191C061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 13:02:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 818D9128AE859;
        Thu, 14 May 2020 13:02:00 -0700 (PDT)
Date:   Thu, 14 May 2020 13:01:59 -0700 (PDT)
Message-Id: <20200514.130159.1188703412067742485.davem@davemloft.net>
To:     irusskikh@marvell.com
Cc:     netdev@vger.kernel.org, aelior@marvell.com, mkalderon@marvell.com,
        dbolotin@marvell.com, kuba@kernel.org
Subject: Re: [PATCH v2 net-next 00/11] net: qed/qede: critical hw error
 handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200514095727.1361-1-irusskikh@marvell.com>
References: <20200514095727.1361-1-irusskikh@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 13:02:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <irusskikh@marvell.com>
Date: Thu, 14 May 2020 12:57:16 +0300

> FastLinQ devices as a complex systems may observe various hardware
> level error conditions, both severe and recoverable.
> 
> Driver is able to detect and report this, but so far it only did
> trace/dmesg based reporting.
> 
> Here we implement an extended hw error detection, service task
> handler captures a dump for the later analysis.
> 
> I also resubmit a patch from Denis Bolotin on tx timeout handler,
> addressing David's comment regarding recovery procedure as an extra
> reaction on this event.
> 
> v2:
> 
> Removing the patch with ethtool dump and udev magic. Its quite isolated,
> I'm working on devlink based logic for this separately.
> 
> v1:
> 
> https://patchwork.ozlabs.org/project/netdev/cover/cover.1588758463.git.irusskikh@marvell.com/

I'm only applying this series because I trust that you will actually do the
devlink work, and you will have it done and submitted in a reasonable amount
of ti me.

Also, patch #4 had trailing empty lines added to a file, which is
warned about by 'git' when I apply your patches.  I fixed it up, but
this is the kind of thing you should have sorted out before you submit
changes to the list.

Thank you.
