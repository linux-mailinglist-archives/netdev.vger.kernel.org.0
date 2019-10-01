Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4227C3A89
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390005AbfJAQaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:30:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49352 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729744AbfJAQaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 12:30:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F1319154B74EF;
        Tue,  1 Oct 2019 09:30:00 -0700 (PDT)
Date:   Tue, 01 Oct 2019 09:30:00 -0700 (PDT)
Message-Id: <20191001.093000.372726574458067639.davem@davemloft.net>
To:     icenowy@aosc.io
Cc:     linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com,
        andrew@lunn.ch, f.fainelli@gmail.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-sunxi@googlegroups.com,
        linux-kernel@vger.kernel.org, mripard@kernel.org, wens@csie.org,
        robh+dt@kernel.org, hkallweit1@gmail.com
Subject: Re: [PATCH 0/3] Pine64+ specific hacks for RTL8211E Ethernet PHY
From:   David Miller <davem@davemloft.net>
In-Reply-To: <2CCD0856-433E-4602-A079-9F7F5F2E00D6@aosc.io>
References: <20191001082912.12905-1-icenowy@aosc.io>
        <20191001.090651.796983023328992596.davem@davemloft.net>
        <2CCD0856-433E-4602-A079-9F7F5F2E00D6@aosc.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Oct 2019 09:30:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Icenowy Zheng <icenowy@aosc.io>
Date: Wed, 02 Oct 2019 00:08:39 +0800

> 
> 
> 于 2019年10月2日 GMT+08:00 上午12:06:51, David Miller <davem@davemloft.net> 写到:
>>From: Icenowy Zheng <icenowy@aosc.io>
>>Date: Tue,  1 Oct 2019 16:29:09 +0800
>>
>>> There're some Pine64+ boards known to have broken RTL8211E chips, and
>>> a hack is given by Pine64+, which is said to be from Realtek.
>>> 
>>> This patchset adds the hack.
>>> 
>>> The hack is taken from U-Boot, and it contains magic numbers without
>>> any document.
>>
>>Please contact Realtek and try to get an explanation about this.
> 
> Sorry, but Realtek never shows any idea to add more infomation about this.
> 
> These hacks had existed and worked for years.

Have you actually tried to communicate with an appropriate contact yourself?

If not, I am asking you to do so.
