Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCBBA130A6E
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 23:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbgAEWvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 17:51:18 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41786 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727210AbgAEWvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 17:51:17 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4DEA21557B503;
        Sun,  5 Jan 2020 14:51:17 -0800 (PST)
Date:   Sun, 05 Jan 2020 14:51:16 -0800 (PST)
Message-Id: <20200105.145116.517086738576726939.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org, parav@mellanox.com
Subject: Re: [PATCH v4 net-next 0/2] ionic: add sriov support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200103175508.32176-1-snelson@pensando.io>
References: <20200103175508.32176-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 Jan 2020 14:51:17 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Fri,  3 Jan 2020 09:55:06 -0800

> Set up the basic support for enabling SR-IOV devices in the
> ionic driver.  Since most of the management work happens in
> the NIC firmware, the driver becomes mostly a pass-through
> for the network stack commands that want to control and
> configure the VFs.
> 
> v4:	changed "vf too big" checks to use pci_num_vf()
> 	changed from vf[] array of pointers of individually allocated
> 	  vf structs to single allocated vfs[] array of vf structs
> 	added clean up of vfs[] on probe fail
> 	added setup for vf stats dma
> 
> v3:	added check in probe for pre-existing VFs
> 	split out the alloc and dealloc of vf structs to better deal
> 	  with pre-existing VFs (left enabled on remove)
> 	restored the checks for vf too big because of a potential
> 	  case where VFs are already enabled but driver failed to
> 	  alloc the vf structs
> 
> v2:	use pci_num_vf() and kcalloc()
> 	remove checks for vf too big
> 	add locking for the VF operations
> 	disable VFs in ionic_remove() if they are still running

Series applied, thanks Shannon.
