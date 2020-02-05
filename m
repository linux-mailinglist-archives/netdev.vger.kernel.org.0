Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0316153130
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 13:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgBEMyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 07:54:15 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46564 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbgBEMyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 07:54:15 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DF55F158CA29B;
        Wed,  5 Feb 2020 04:54:13 -0800 (PST)
Date:   Wed, 05 Feb 2020 13:54:12 +0100 (CET)
Message-Id: <20200205.135412.309051466403493424.davem@davemloft.net>
To:     tbogendoerfer@suse.de
Cc:     ralf@linux-mips.org, paulburton@kernel.org,
        linux-mips@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net] net: sgi: ioc3-eth: Remove leftover free_irq()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200204135820.21931-1-tbogendoerfer@suse.de>
References: <20200204135820.21931-1-tbogendoerfer@suse.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Feb 2020 04:54:15 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Date: Tue,  4 Feb 2020 14:58:20 +0100

> Commit 0ce5ebd24d25 ("mfd: ioc3: Add driver for SGI IOC3 chip") moved
> request_irq() from ioc3_open into probe function, but forgot to remove
> free_irq() from ioc3_close.
> 
> Fixes: 0ce5ebd24d25 ("mfd: ioc3: Add driver for SGI IOC3 chip")
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>

Applied, thank you.
