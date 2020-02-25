Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 142AC16EE26
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 19:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731609AbgBYSj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 13:39:29 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48454 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731439AbgBYSj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 13:39:28 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 798D7133EF6B3;
        Tue, 25 Feb 2020 10:39:27 -0800 (PST)
Date:   Tue, 25 Feb 2020 10:39:27 -0800 (PST)
Message-Id: <20200225.103927.302026645880403716.davem@davemloft.net>
To:     yangerkun@huawei.com
Cc:     netdev@vger.kernel.org, maowenan@huawei.com
Subject: Re: [RFC] slip: not call free_netdev before rtnl_unlock in
 slip_open
From:   David Miller <davem@davemloft.net>
In-Reply-To: <5f3e0e02-c900-1956-9628-e25babad2dd9@huawei.com>
References: <2e9edf1e-5f4f-95d6-4381-6675cded02ac@huawei.com>
        <c6bbb6ef-2ae5-6450-fb01-1fc9265f0483@huawei.com>
        <5f3e0e02-c900-1956-9628-e25babad2dd9@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Feb 2020 10:39:27 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: yangerkun <yangerkun@huawei.com>
Date: Tue, 25 Feb 2020 16:57:16 +0800

> Ping. And anyone can give some advise about this patch?

You've pinged us 5 or 6 times already.

Obviously that isn't causing anyone to look more deeply into your
patch.

You have to accept the fact that using the same exact strategy over
and over again to get someone to look at this is not working.

Please.

Thank you.
