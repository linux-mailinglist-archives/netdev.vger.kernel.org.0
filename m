Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 356FC217860
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 21:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbgGGT41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 15:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727908AbgGGT40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 15:56:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CC2C061755;
        Tue,  7 Jul 2020 12:56:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AEC30120F93E0;
        Tue,  7 Jul 2020 12:56:25 -0700 (PDT)
Date:   Tue, 07 Jul 2020 12:56:24 -0700 (PDT)
Message-Id: <20200707.125624.2030141794702878802.davem@davemloft.net>
To:     alobakin@marvell.com
Cc:     kai.heng.feng@canonical.com, anthony.wong@canonical.com,
        irusskikh@marvell.com, kuba@kernel.org, ndanilov@marvell.com,
        mstarovoitov@marvell.com, dmitry.bezrukov@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: atlantic: Add support for firmware v4
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200707084657.205-1-alobakin@marvell.com>
References: <20200707063830.15645-1-kai.heng.feng@canonical.com>
        <20200707084657.205-1-alobakin@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jul 2020 12:56:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alobakin@marvell.com>
Date: Tue, 7 Jul 2020 11:46:57 +0300

> From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
> Date:   Tue,  7 Jul 2020 14:38:28 +0800
> 
>> We have a new ethernet card that is supported by the atlantic driver:
>> 01:00.0 Ethernet controller [0200]: Aquantia Corp. AQC107 NBase-T/IEEE 802.3bz Ethernet Controller [AQtion] [1d6a:07b1] (rev 02)
>> 
>> But the driver failed to probe the device:
>> kernel: atlantic: Bad FW version detected: 400001e
>> kernel: atlantic: probe of 0000:01:00.0 failed with error -95
>> 
>> As a pure guesswork, simply adding the firmware version to the driver
> 
> Please don't send "pure guessworks" to net-fixes tree. You should have
> reported this as a bug to LKML and/or atlantic team, so we could issue
> it.

Production hardware is shipping to customers and the driver
maintainers didn't add support for this ID yet?  What is that
"atlantic team" waiting for?

Honestly I don't blame someone for posting a patch like this to get it
to work.
