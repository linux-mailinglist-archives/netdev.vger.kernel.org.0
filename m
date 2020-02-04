Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8814151B8E
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 14:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbgBDNmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 08:42:49 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43490 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727174AbgBDNmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 08:42:49 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 739DE147065ED;
        Tue,  4 Feb 2020 05:42:47 -0800 (PST)
Date:   Tue, 04 Feb 2020 14:42:43 +0100 (CET)
Message-Id: <20200204.144243.914260869258980952.davem@davemloft.net>
To:     tbogendoerfer@suse.de
Cc:     ralf@linux-mips.org, paulburton@kernel.org,
        linux-mips@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: sgi: ioc3-eth: Remove leftover free_irq()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200204125833.f4fd62590d0539cf87527286@suse.de>
References: <20200204113628.13654-1-tbogendoerfer@suse.de>
        <20200204.124455.1858606436930758654.davem@davemloft.net>
        <20200204125833.f4fd62590d0539cf87527286@suse.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Feb 2020 05:42:48 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Date: Tue, 4 Feb 2020 12:58:33 +0100

> On Tue, 04 Feb 2020 12:44:55 +0100 (CET)
> David Miller <davem@davemloft.net> wrote:
> 
>> From: Thomas Bogendoerfer <tbogendoerfer@suse.de>
>> Date: Tue,  4 Feb 2020 12:36:28 +0100
>> 
>> > Commit 0ce5ebd24d25 ("mfd: ioc3: Add driver for SGI IOC3 chip") moved
>> > request_irq() from ioc3_open into probe function, but forgot to remove
>> > free_irq() from ioc3_close.
>> > 
>> > Fixes: 0ce5ebd24d25 ("mfd: ioc3: Add driver for SGI IOC3 chip")
>> > Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
>> 
>> ioc3_open() still has the request_irq() in my tree.
> 
> then I guess you don't have commit 0ce5ebd24d25 in your tree. My Patch is
> against linus/master, where it is already applied. Should I rebase against your
> net tree, when the commit shows up ?

I just sync'd with Linus's tree so you should be able to rebase right now.

Thanks.
