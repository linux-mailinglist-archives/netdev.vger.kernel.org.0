Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F280916F619
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 04:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgBZDaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 22:30:46 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52804 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgBZDaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 22:30:46 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AD6BA14E20281;
        Tue, 25 Feb 2020 19:30:45 -0800 (PST)
Date:   Tue, 25 Feb 2020 19:30:43 -0800 (PST)
Message-Id: <20200225.193043.522116649502857666.davem@davemloft.net>
To:     yangerkun@huawei.com
Cc:     netdev@vger.kernel.org, maowenan@huawei.com
Subject: Re: [RFC] slip: not call free_netdev before rtnl_unlock in
 slip_open
From:   David Miller <davem@davemloft.net>
In-Reply-To: <38005566-2319-9a13-00d9-5a4f88d4bc46@huawei.com>
References: <5f3e0e02-c900-1956-9628-e25babad2dd9@huawei.com>
        <20200225.103927.302026645880403716.davem@davemloft.net>
        <38005566-2319-9a13-00d9-5a4f88d4bc46@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Feb 2020 19:30:45 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: yangerkun <yangerkun@huawei.com>
Date: Wed, 26 Feb 2020 09:35:38 +0800

> 
> 
> On 2020/2/26 2:39, David Miller wrote:
>> From: yangerkun <yangerkun@huawei.com>
>> Date: Tue, 25 Feb 2020 16:57:16 +0800
>> 
>>> Ping. And anyone can give some advise about this patch?
>> You've pinged us 5 or 6 times already.
> Hi,
> 
> Thanks for your reply!
> 
> I am so sorry for the frequently ping which can make some
> noise. Wont't happen again after this...

Ok.  But please repost your patch without the RFC tag.
