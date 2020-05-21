Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83AB1DC52F
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 04:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgEUC2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 22:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbgEUC2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 22:28:30 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13720C061A0E
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 19:28:30 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8C12812757020;
        Wed, 20 May 2020 19:28:29 -0700 (PDT)
Date:   Wed, 20 May 2020 19:28:28 -0700 (PDT)
Message-Id: <20200520.192828.1242706969153634308.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next 00/14][pull request] 1GbE Intel Wired LAN Driver
 Updates 2020-05-19
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200520000419.1595788-1-jeffrey.t.kirsher@intel.com>
References: <20200520000419.1595788-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 May 2020 19:28:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Tue, 19 May 2020 17:04:05 -0700

> This series contains updates to igc only.
> 
> Sasha cleans up the igc driver code that is not used or needed.
> 
> Vitaly cleans up driver code that was used to support Virtualization on
> a device that is not supported by igc, so remove the dead code.
> 
> Andre renames a few macros to align with register and field names
> described in the data sheet.  Also adds the VLAN Priority Queue Fliter
> and EType Queue Filter registers to the list of registers dumped by
> igc_get_regs().  Added additional debug messages and updated return codes
> for unsupported features.  Refactored the VLAN priority filtering code to
> move the core logic into igc_main.c.  Cleaned up duplicate code and
> useless code.
> 
> The following are changes since commit 2de499258659823b3c7207c5bda089c822b67d69:
>   Merge branch 's390-next'
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Pulled, thanks Jeff.
