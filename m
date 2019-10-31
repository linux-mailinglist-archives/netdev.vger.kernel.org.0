Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1EDEA861
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 01:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbfJaAvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 20:51:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49026 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbfJaAvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 20:51:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E2FDD14E7974B;
        Wed, 30 Oct 2019 17:51:39 -0700 (PDT)
Date:   Wed, 30 Oct 2019 17:51:39 -0700 (PDT)
Message-Id: <20191030.175139.1223819923695473265.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next 0/8][pull request] 1GbE Intel Wired LAN Driver
 Updates 2019-10-29
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191030043633.26249-1-jeffrey.t.kirsher@intel.com>
References: <20191030043633.26249-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Oct 2019 17:51:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Tue, 29 Oct 2019 21:36:25 -0700

> This series contains updates to e1000e, igb, ixgbe and i40e drivers.
> 
> Sasha adds support for Intel client platforms Comet Lake and Tiger Lake
> to the e1000e driver.  Also adds a fix for a compiler warning that was
> recently introduced, when CONFIG_PM_SLEEP is not defined, so wrap the
> code that requires this kernel configuration to be defined.
> 
> Alex fixes a potential race condition between network configuration and
> power management for e1000e, which is similar to a past issue in the igb
> driver.  Also provided a bit of code cleanup since the driver no longer
> checks for __E1000_DOWN.
> 
> Josh Hunt adds UDP segmentation offload support for igb, ixgbe and i40e.
> 
> The following are changes since commit 199f3ac319554f1ffddcc8e832448843f073d4c7:
>   ionic: Remove set but not used variable 'sg_desc'
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Pulled, thanks Jeff.
