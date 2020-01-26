Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBBEB149A40
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 11:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729353AbgAZKue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 05:50:34 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56022 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbgAZKue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 05:50:34 -0500
Received: from localhost (unknown [147.229.117.36])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 957E2151C491C;
        Sun, 26 Jan 2020 02:50:32 -0800 (PST)
Date:   Sun, 26 Jan 2020 11:50:28 +0100 (CET)
Message-Id: <20200126.115028.1635138302146567330.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next 0/8][pull request] 100GbE Intel Wired LAN Driver
 Updates 2020-01-25
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200126060737.3238027-1-jeffrey.t.kirsher@intel.com>
References: <20200126060737.3238027-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 26 Jan 2020 02:50:33 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Sat, 25 Jan 2020 22:07:29 -0800

> This series contains updates to the ice driver to add support for RSS.
> 
> Henry and Tony enable the driver to write the filtering hardware tables
> to allow for changing of RSS rules, also introduced and initialized the
> structures for storing the configuration.  Then followed it up by
> creating an extraction sequence based on the packet header protocols to
> be programmed.  Next was storing the TCAM entry with the profile data
> and VSI group in the respective software structures.
> 
> Md Fahad sets up the configuration to support RSS tables for the virtual
> function (VF) driver (iavf).  Add support for flow types TCP4, TCP6,
> UDP4, UDP6, SCTP4 and SCTP6 for RSS via ethtool.
> 
> The following are changes since commit 3333e50b64fe30b7e53cf02456a2f567f689ae4f:
>   Merge branch 'mlxsw-Offload-TBF'
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Pulled, thanks Jeff.
