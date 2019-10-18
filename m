Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8D64DCE0D
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 20:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505545AbfJRSgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 14:36:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56244 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730701AbfJRSgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 14:36:04 -0400
Received: from localhost (unknown [IPv6:2607:fb90:8372:e906:3458:7e9:fdcd:4249])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CF5961265125A;
        Fri, 18 Oct 2019 11:36:03 -0700 (PDT)
Date:   Fri, 18 Oct 2019 14:36:00 -0400 (EDT)
Message-Id: <20191018.143600.2140930720172918832.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: remove support for RTL8100e
From:   David Miller <davem@davemloft.net>
In-Reply-To: <80d28162-65fa-eb1a-2042-ae98f8f28260@gmail.com>
References: <2b48266a-7fdc-039b-a11d-622da58acf42@gmail.com>
        <20191017.154014.1196156125754339202.davem@davemloft.net>
        <80d28162-65fa-eb1a-2042-ae98f8f28260@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 18 Oct 2019 11:36:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Fri, 18 Oct 2019 20:31:28 +0200

> On 17.10.2019 21:40, David Miller wrote:
>> From: Heiner Kallweit <hkallweit1@gmail.com>
>> Date: Thu, 17 Oct 2019 21:26:35 +0200
>> 
>>> To be on the safe side, let me check with Realtek directly.
>> 
>> That's a great idea, let us know what you find out.
>> 
> Realtek suggested to keep the two chip definitions.
> Supposedly RTL_GIGA_MAC_VER_15 is the same as RTL_GIGA_MAC_VER_12,
> and RTL_GIGA_MAC_VER_14 is the same as RTL_GIGA_MAC_VER_11.
> So let's keep it as it is.

Ok, great.
