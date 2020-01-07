Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE47C1333FE
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 22:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbgAGVXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 16:23:02 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38018 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728134AbgAGVBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 16:01:37 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B237515A15B85;
        Tue,  7 Jan 2020 13:01:35 -0800 (PST)
Date:   Tue, 07 Jan 2020 13:01:33 -0800 (PST)
Message-Id: <20200107.130133.1900367587695369052.davem@davemloft.net>
To:     Jiping.Ma2@windriver.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] stmmac: debugfs entry name is not be changed when udev
 rename device name.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <99d183bc-7668-7749-54d6-3649c549dec8@windriver.com>
References: <15aedd71-e077-4c6c-e30c-9396d16eaeec@windriver.com>
        <20200106.182259.1907306689510314367.davem@davemloft.net>
        <99d183bc-7668-7749-54d6-3649c549dec8@windriver.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jan 2020 13:01:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiping Ma <Jiping.Ma2@windriver.com>
Date: Tue, 7 Jan 2020 10:59:22 +0800

> 
> 
> On 01/07/2020 10:22 AM, David Miller wrote:
>> From: Jiping Ma <Jiping.Ma2@windriver.com>
>> Date: Tue, 7 Jan 2020 09:00:53 +0800
>>
>>>
>>> On 01/07/2020 05:45 AM, David Miller wrote:
>>>> From: Jiping Ma <jiping.ma2@windriver.com>
>>>> Date: Mon, 6 Jan 2020 10:33:41 +0800
>>>>
>>>>> Add one notifier for udev changes net device name.
>>>>>
>>>>> Signed-off-by: Jiping Ma <jiping.ma2@windriver.com>
>>>> This doesn't apply to 'net' and since this is a bug fix that is where
>>>> you should target this change.
>>> What's the next step that I can do?
>> Respin your patch against the net GIT tree so that it applies clean.y
> OK, I will generate the new patch based on the latest linux kernel
> code.
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

That's not the networking GIT tree.
