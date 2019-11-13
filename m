Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 849F1FA7C9
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 05:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfKMEGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 23:06:46 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54666 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727032AbfKMEGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 23:06:46 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AF907155010EA;
        Tue, 12 Nov 2019 20:06:44 -0800 (PST)
Date:   Tue, 12 Nov 2019 20:06:44 -0800 (PST)
Message-Id: <20191112.200644.1626534982196475617.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     wahrenst@gmx.net, matthias.bgg@kernel.org, mbrugger@suse.com,
        robh+dt@kernel.org, eric@anholt.net, nsaenzjulienne@suse.de,
        opendmb@gmail.com, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH V5 net-next 0/7] ARM: Enable GENET support for RPi 4
From:   David Miller <davem@davemloft.net>
In-Reply-To: <a7ac4b21-822a-3170-29b6-85cfd80796a0@gmail.com>
References: <1573501766-21154-1-git-send-email-wahrenst@gmx.net>
        <20191112.193557.2087258530355949302.davem@davemloft.net>
        <a7ac4b21-822a-3170-29b6-85cfd80796a0@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 20:06:45 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Tue, 12 Nov 2019 19:56:36 -0800

> 
> 
> On 11/12/2019 7:35 PM, David Miller wrote:
>> From: Stefan Wahren <wahrenst@gmx.net>
>> Date: Mon, 11 Nov 2019 20:49:19 +0100
>> 
>>> Raspberry Pi 4 uses the broadcom genet chip in version five.
>>> This chip has a dma controller integrated. Up to now the maximal
>>> burst size was hard-coded to 0x10. But it turns out that Raspberry Pi 4
>>> does only work with the smaller maximal burst size of 0x8.
>>>
>>> Additionally the patch series has some IRQ retrieval improvements and
>>> adds support for a missing PHY mode.
>>>
>>> This series based on Matthias Brugger's V1 series [1].
>>>
>>> [1] - https://patchwork.kernel.org/cover/11186193/
>> 
>> What tree should this be applied to?  Patch #7 does not apply to net-next.
> 
> Do you mind taking 1-6 and I take patch 7 through the Broadcom ARM SoC tree?

Sure, I'll do that right now, thanks!
