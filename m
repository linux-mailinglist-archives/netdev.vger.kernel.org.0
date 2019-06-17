Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B60A748D16
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 20:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbfFQS4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 14:56:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36412 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbfFQS4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 14:56:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C7F4A150FC722;
        Mon, 17 Jun 2019 11:56:17 -0700 (PDT)
Date:   Mon, 17 Jun 2019 11:56:15 -0700 (PDT)
Message-Id: <20190617.115615.91633577273679753.davem@davemloft.net>
To:     sunilmut@microsoft.com
Cc:     decui@microsoft.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, mikelley@microsoft.com,
        netdev@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] hvsock: fix epollout hang from race condition
From:   David Miller <davem@davemloft.net>
In-Reply-To: <MW2PR2101MB111697FDA0BEDA81237FECB3C0EB0@MW2PR2101MB1116.namprd21.prod.outlook.com>
References: <PU1P153MB0169BACDA500F94910849770BFE90@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
        <20190616.135445.822152500838073831.davem@davemloft.net>
        <MW2PR2101MB111697FDA0BEDA81237FECB3C0EB0@MW2PR2101MB1116.namprd21.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Jun 2019 11:56:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Muthuswamy <sunilmut@microsoft.com>
Date: Mon, 17 Jun 2019 18:47:08 +0000

> 
> 
>> -----Original Message-----
>> From: linux-hyperv-owner@vger.kernel.org <linux-hyperv-owner@vger.kernel.org> On Behalf Of David Miller
>> Sent: Sunday, June 16, 2019 1:55 PM
>> To: Dexuan Cui <decui@microsoft.com>
>> Cc: Sunil Muthuswamy <sunilmut@microsoft.com>; KY Srinivasan <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>;
>> Stephen Hemminger <sthemmin@microsoft.com>; sashal@kernel.org; Michael Kelley <mikelley@microsoft.com>;
>> netdev@vger.kernel.org; linux-hyperv@vger.kernel.org; linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH net] hvsock: fix epollout hang from race condition
>> 
>> From: Dexuan Cui <decui@microsoft.com>
>> Date: Sat, 15 Jun 2019 03:22:32 +0000
>> 
>> > These warnings are not introduced by this patch from Sunil.
>> >
>> > I'm not sure why I didn't notice these warnings before.
>> > Probably my gcc version is not new eought?
>> >
>> > Actually these warnings are bogus, as I checked the related functions,
>> > which may confuse the compiler's static analysis.
>> >
>> > I'm going to make a patch to initialize the pointers to NULL to suppress
>> > the warnings. My patch will be based on the latest's net.git + this patch
>> > from Sunil.
>> 
>> Sunil should then resubmit his patch against something that has the
>> warning suppression patch applied.
> 
> David, Dexuan's patch to suppress the warnings seems to be applied now
> to the 'net' branch. Can we please get this patch applied as well?

I don't know how else to say "Suni should then resubmit his patch"

Please just resubmit it!
