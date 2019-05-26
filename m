Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4CCD2AC00
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 22:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725863AbfEZUKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 16:10:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45752 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfEZUKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 16:10:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DC24013F3270F;
        Sun, 26 May 2019 13:04:34 -0700 (PDT)
Date:   Sun, 26 May 2019 13:04:32 -0700 (PDT)
Message-Id: <20190526.130432.605011257219662109.davem@davemloft.net>
To:     michal.kalderon@marvell.com
Cc:     ariel.elior@marvell.com, dledford@redhat.com, jgg@ziepe.ca,
        leon@kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 net-next 00/11] qed*: Improve performance on 100G
 link for offload protocols
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190526122230.30039-1-michal.kalderon@marvell.com>
References: <20190526122230.30039-1-michal.kalderon@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 26 May 2019 13:04:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kalderon <michal.kalderon@marvell.com>
Date: Sun, 26 May 2019 15:22:19 +0300

> This patch series modifies the current implementation of PF selection.
> The refactoring of the llh code enables setting additional filters
> (mac / protocol) per PF, and improves performance for offload protocols
> (RoCE, iWARP, iSCSI, fcoe) on 100G link (was capped at 90G per single
> PF).
> 
> Improved performance on 100G link is achieved by configuring engine
> affinty to each PF.
> The engine affinity is read from the Management FW and hw is configured accordingly.
> A new hw resource called PPFID is exposed and an API is introduced to utilize
> it. This additional resource enables setting the affinity of a PF and providing
> more classification rules per PF.
> qedr,qedi,qedf are also modified as part of the series. Without the
> changes functionality is broken.
> 
> v1 --> v2
> ---------
> - Remove iWARP module parameter. Instead use devlink param infrastructure
>   for setting the iwarp_cmt mode. Additional patch added to the series for
>   adding the devlink support.
> 
> - Fix kbuild test robot warning on qed_llh_filter initialization.
> 
> - Remove comments inside function calls

Series applied, thanks.
