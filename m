Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA80F19046E
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 05:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgCXEVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 00:21:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56114 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbgCXEVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 00:21:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A25521572D5FD;
        Mon, 23 Mar 2020 21:21:48 -0700 (PDT)
Date:   Mon, 23 Mar 2020 21:21:47 -0700 (PDT)
Message-Id: <20200323.212147.1469413642043253547.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next 0/9][pull request] 100GbE Intel Wired LAN Driver
 Updates 2020-03-21
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200321081028.2763550-1-jeffrey.t.kirsher@intel.com>
References: <20200321081028.2763550-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 21:21:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Sat, 21 Mar 2020 01:10:19 -0700

> Implement basic support for the devlink interface in the ice driver.
> Additionally pave some necessary changes for adding a devlink region that
> exposes the NVM contents.
> 
> This series first contains 5 patches for enabling and implementing full NVM
> read access via the ETHTOOL_GEEPROM interface. This includes some cleanup of
> endian-types, a new function for reading from the NVM and Shadow RAM as a flat
> addressable space, a function to calculate the available flash size during
> load, and a change to how some of the NVM version fields are stored in the
> ice_nvm_info structure.
> 
> Following this is 3 patches for implementing devlink support. First, one patch
> which implements the basic framework and introduces the ice_devlink.c file.
> Second, a patch to implement basic .info_get support. Finally, a patch which
> reads the device PBA identifier and reports it as the `board.id` value in the
> .info_get response.
> 
> The following are changes since commit 0d7043f355d0045bd38b025630a7defefa3ec07f:
>   Merge tag 'mac80211-next-for-net-next-2020-03-20' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Pulled, thanks Jeff.
