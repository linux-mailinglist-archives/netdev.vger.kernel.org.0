Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB70F476DE
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 22:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbfFPUyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 16:54:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52048 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbfFPUyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 16:54:46 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 04C47151C2872;
        Sun, 16 Jun 2019 13:54:45 -0700 (PDT)
Date:   Sun, 16 Jun 2019 13:54:45 -0700 (PDT)
Message-Id: <20190616.135445.822152500838073831.davem@davemloft.net>
To:     decui@microsoft.com
Cc:     sunilmut@microsoft.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, mikelley@microsoft.com,
        netdev@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] hvsock: fix epollout hang from race condition
From:   David Miller <davem@davemloft.net>
In-Reply-To: <PU1P153MB0169BACDA500F94910849770BFE90@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <MW2PR2101MB11164C6EEAA5C511B395EF3AC0EC0@MW2PR2101MB1116.namprd21.prod.outlook.com>
        <20190614.191456.407433636343988177.davem@davemloft.net>
        <PU1P153MB0169BACDA500F94910849770BFE90@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Jun 2019 13:54:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>
Date: Sat, 15 Jun 2019 03:22:32 +0000

> These warnings are not introduced by this patch from Sunil.
> 
> I'm not sure why I didn't notice these warnings before.  
> Probably my gcc version is not new eought? 
> 
> Actually these warnings are bogus, as I checked the related functions,
> which may confuse the compiler's static analysis.
> 
> I'm going to make a patch to initialize the pointers to NULL to suppress
> the warnings. My patch will be based on the latest's net.git + this patch
> from Sunil.

Sunil should then resubmit his patch against something that has the
warning suppression patch applied.
