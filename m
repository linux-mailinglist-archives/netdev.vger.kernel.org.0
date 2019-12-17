Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A72CC123AB3
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 00:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfLQXVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 18:21:30 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44428 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfLQXVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 18:21:30 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BD4F714A6F7E9;
        Tue, 17 Dec 2019 15:21:29 -0800 (PST)
Date:   Tue, 17 Dec 2019 15:21:26 -0800 (PST)
Message-Id: <20191217.152126.1428798833164203299.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     opendmb@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/8] net: bcmgenet: use CHECKSUM_COMPLETE for
 NETIF_F_RXCSUM
From:   David Miller <davem@davemloft.net>
In-Reply-To: <042fad13-f6a2-6d1b-ba7a-61c60e394115@gmail.com>
References: <1576616549-39097-4-git-send-email-opendmb@gmail.com>
        <20191217.131631.2246524906428878009.davem@davemloft.net>
        <042fad13-f6a2-6d1b-ba7a-61c60e394115@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Dec 2019 15:21:30 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Tue, 17 Dec 2019 14:52:07 -0800

> On 12/17/19 1:16 PM, David Miller wrote:
>> From: Doug Berger <opendmb@gmail.com>
>> Date: Tue, 17 Dec 2019 13:02:24 -0800
>> 
>>> This commit updates the Rx checksum offload behavior of the driver
>>> to use the more generic CHECKSUM_COMPLETE method that supports all
>>> protocols over the CHECKSUM_UNNECESSARY method that only applies
>>> to some protocols known by the hardware.
>>>
>>> This behavior is perceived to be superior.
>>>
>>> Signed-off-by: Doug Berger <opendmb@gmail.com>
>> 
>> This has to be done in the same patch that you change to use
>> the NETIF_F_HW_CSUM feature flag.
> 
> Even if we were already advertising support for NETIF_F_RXCSUM before
> patch #2? Not questioning your comment, just trying to understand why
> this is deemed necessary here since it does not affect the same "direction".

My bad... I misunderstood the situation.

Ignore me :-)
