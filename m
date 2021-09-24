Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3ECD41753F
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 15:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347220AbhIXNSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 09:18:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52254 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346975AbhIXNQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 09:16:13 -0400
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 050B74F7CC988;
        Fri, 24 Sep 2021 06:14:32 -0700 (PDT)
Date:   Fri, 24 Sep 2021 14:14:26 +0100 (BST)
Message-Id: <20210924.141426.1767931642845359040.davem@davemloft.net>
To:     leon@kernel.org
Cc:     kuba@kernel.org, leonro@nvidia.com, alobakin@pm.me,
        anirudh.venkataramanan@intel.com, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, irusskikh@marvell.com,
        intel-wired-lan@lists.osuosl.org, jejb@linux.ibm.com,
        jhasan@marvell.com, jeffrey.t.kirsher@intel.com,
        jesse.brandeburg@intel.com, jiri@nvidia.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, michael.chan@broadcom.com,
        michal.kalderon@marvell.com, netdev@vger.kernel.org,
        sathya.perla@broadcom.com, skashyap@marvell.com,
        anthony.l.nguyen@intel.com, vasundhara-v.volam@broadcom.com
Subject: Re: [PATCH net-next 0/6] Batch of devlink related fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1632420430.git.leonro@nvidia.com>
References: <cover.1632420430.git.leonro@nvidia.com>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 24 Sep 2021 06:14:38 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leon@kernel.org>
Date: Thu, 23 Sep 2021 21:12:47 +0300

> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Hi,
> 
> I'm asking to apply this batch of devlink fixes to net-next and not to
> net, because most if not all fixes are for old code or/and can be considered
> as cleanup.
> 
> It will cancel the need to deal with merge conflicts for my next devlink series :).

ok, but just this one time.

I much rather this kind of stuff goes to net and we deal with the merge
conflicts that arise.

Thsnks!
