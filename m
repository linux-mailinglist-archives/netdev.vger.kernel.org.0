Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E17C6C3A97
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730883AbfJAQcw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 1 Oct 2019 12:32:52 -0400
Received: from hermes.aosc.io ([199.195.250.187]:38933 "EHLO hermes.aosc.io"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbfJAQcv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:32:51 -0400
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: icenowy@aosc.io)
        by hermes.aosc.io (Postfix) with ESMTPSA id B33DB82889;
        Tue,  1 Oct 2019 16:32:49 +0000 (UTC)
Date:   Wed, 02 Oct 2019 00:31:25 +0800
In-Reply-To: <20191001.093000.372726574458067639.davem@davemloft.net>
References: <20191001082912.12905-1-icenowy@aosc.io> <20191001.090651.796983023328992596.davem@davemloft.net> <2CCD0856-433E-4602-A079-9F7F5F2E00D6@aosc.io> <20191001.093000.372726574458067639.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH 0/3] Pine64+ specific hacks for RTL8211E Ethernet PHY
To:     linux-arm-kernel@lists.infradead.org,
        David Miller <davem@davemloft.net>
CC:     mark.rutland@arm.com, andrew@lunn.ch, f.fainelli@gmail.com,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mripard@kernel.org,
        linux-sunxi@googlegroups.com, robh+dt@kernel.org, wens@csie.org,
        hkallweit1@gmail.com
From:   Icenowy Zheng <icenowy@aosc.io>
Message-ID: <D1124458-D5CB-4AFF-B106-C6EA1A98100F@aosc.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



于 2019年10月2日 GMT+08:00 上午12:30:00, David Miller <davem@davemloft.net> 写到:
>From: Icenowy Zheng <icenowy@aosc.io>
>Date: Wed, 02 Oct 2019 00:08:39 +0800
>
>> 
>> 
>> 于 2019年10月2日 GMT+08:00 上午12:06:51, David Miller <davem@davemloft.net>
>写到:
>>>From: Icenowy Zheng <icenowy@aosc.io>
>>>Date: Tue,  1 Oct 2019 16:29:09 +0800
>>>
>>>> There're some Pine64+ boards known to have broken RTL8211E chips,
>and
>>>> a hack is given by Pine64+, which is said to be from Realtek.
>>>> 
>>>> This patchset adds the hack.
>>>> 
>>>> The hack is taken from U-Boot, and it contains magic numbers
>without
>>>> any document.
>>>
>>>Please contact Realtek and try to get an explanation about this.
>> 
>> Sorry, but Realtek never shows any idea to add more infomation about
>this.
>> 
>> These hacks had existed and worked for years.
>
>Have you actually tried to communicate with an appropriate contact
>yourself?
>
>If not, I am asking you to do so.

I have tried to ask via TL Lim from Pine64, because I have no way
to communicate directly to Realtek. However TL cannot get anything
more from Realtek.

>
>_______________________________________________
>linux-arm-kernel mailing list
>linux-arm-kernel@lists.infradead.org
>http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
使用 K-9 Mail 发送自我的Android设备。
