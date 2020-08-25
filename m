Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8A25250DFF
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 03:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbgHYBCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 21:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHYBCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 21:02:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A75C061574
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 18:02:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8053D12952B98;
        Mon, 24 Aug 2020 17:45:13 -0700 (PDT)
Date:   Mon, 24 Aug 2020 18:01:58 -0700 (PDT)
Message-Id: <20200824.180158.1277052703074347320.davem@davemloft.net>
To:     irusskikh@marvell.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, aelior@marvell.com,
        mkalderon@marvell.com, jesse.brandeburg@intel.com
Subject: Re: [PATCH v7 net-next 00/10] qed: introduce devlink health support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200823111934.305-1-irusskikh@marvell.com>
References: <20200823111934.305-1-irusskikh@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Aug 2020 17:45:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <irusskikh@marvell.com>
Date: Sun, 23 Aug 2020 14:19:24 +0300

> This is a followup implementation after series
> 
> https://patchwork.ozlabs.org/project/netdev/cover/20200514095727.1361-1-irusskikh@marvell.com/
> 
> This is an implementation of devlink health infrastructure.
> 
> With this we are now able to report HW errors to devlink, and it'll take
> its own actions depending on user configuration to capture and store the
> dump at the bad moment, and to request the driver to recover the device.
> 
> So far we do not differentiate global device failures or specific PCI
> function failures. This means that some errors specific to one physical
> function will affect an entire device. This is not yet fully designed
> and verified, will followup in future.
> 
> Solution was verified with artificial HW errors generated, existing
> tools for dump analysis could be used.
> 
> v7: comments from Jesse and Jakub
>  - p2: extra edev check
>  - p9: removed extra indents
> v6: patch 4: changing serial to board.serial and fw to fw.app
> v5: improved patch 4 description
> v4:
>  - commit message and other fixes after Jiri's comments
>  - removed one patch (will send to net)
> v3: fix uninit var usage in patch 11
> v2: fix #include issue from kbuild test robot.

Series applied, thank you.
