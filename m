Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 609791417A6
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 14:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbgARNay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 08:30:54 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41638 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726933AbgARNay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 08:30:54 -0500
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 62C40153CEEF6;
        Sat, 18 Jan 2020 05:30:53 -0800 (PST)
Date:   Sat, 18 Jan 2020 14:30:48 +0100 (CET)
Message-Id: <20200118.143048.1347480269328855855.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next 0/9][pull request] Intel Wired LAN Driver Updates
 2020-01-17
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200117185617.1585693-1-jeffrey.t.kirsher@intel.com>
References: <20200117185617.1585693-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 18 Jan 2020 05:30:54 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Fri, 17 Jan 2020 10:56:08 -0800

> This series contains updates to igc, i40e, fm10k and ice drivers.
> 
> Sasha fixes a typo in a code comment that referred to silicon that is
> not supported in the igc driver.  Cleaned up a defined that was not
> being used.  Added support for another i225 SKU which does not have an
> NVM.  Added support for TCP segmentation offload (TSO) into igc.  Added
> support for PHY power management control to provide a reliable and
> accurate indication of PHY reset completion.
> 
> Jake adds support for the new txqueue parameter to the transmit timeout
> function in fm10k which reduces the code complexity when determining
> which transmit queue is stuck.
> 
> Julio Faracco makes the similar changes that Jake did for fm10k, for
> i40e and ice drivers.  Added support for the new txqueue parameter in
> the transmit timeout functions for i40e and ice.
> 
> Colin Ian King cleans up a redundant initialization of a local variable.
> 
> The following are changes since commit 56f200c78ce4d94680a27a1ce97a29ebeb4f23e1:
>   netns: Constify exported functions
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Pulled, thanks Jeff.
