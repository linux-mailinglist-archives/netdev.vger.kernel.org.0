Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2A6F79F91
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 05:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbfG3DlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 23:41:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43372 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726863AbfG3DlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 23:41:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1F764152F1AC6;
        Mon, 29 Jul 2019 20:41:16 -0700 (PDT)
Date:   Mon, 29 Jul 2019 20:41:13 -0700 (PDT)
Message-Id: <20190729.204113.316505378355498068.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     baijiaju1990@gmail.com, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: phy_led_triggers: Fix a possible
 null-pointer dereference in phy_led_trigger_change_speed()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190730033229.GA20628@lunn.ch>
References: <20190729134553.GC4110@lunn.ch>
        <f603f3c3-f7c9-8dff-5f30-74174282819c@gmail.com>
        <20190730033229.GA20628@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jul 2019 20:41:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Tue, 30 Jul 2019 05:32:29 +0200

> On Tue, Jul 30, 2019 at 10:25:36AM +0800, Jia-Ju Bai wrote:
>> 
>> 
>> On 2019/7/29 21:45, Andrew Lunn wrote:
>> >On Mon, Jul 29, 2019 at 05:24:24PM +0800, Jia-Ju Bai wrote:
>> >>In phy_led_trigger_change_speed(), there is an if statement on line 48
>> >>to check whether phy->last_triggered is NULL:
>> >>     if (!phy->last_triggered)
>> >>
>> >>When phy->last_triggered is NULL, it is used on line 52:
>> >>     led_trigger_event(&phy->last_triggered->trigger, LED_OFF);
>> >>
>> >>Thus, a possible null-pointer dereference may occur.
>> >>
>> >>To fix this bug, led_trigger_event(&phy->last_triggered->trigger,
>> >>LED_OFF) is called when phy->last_triggered is not NULL.
>> >>
>> >>This bug is found by a static analysis tool STCheck written by us.
>> >Who is 'us'?
>> 
>> Me and my colleague...
> 
> Well, we can leave it very vague, giving no idea who 'us' is. But
> often you want to name the company behind it, or the university, or
> the sponsor, etc.

I agree, if you are going to mention that there is a tool you should be
clear exactly who and what organization are behind it.

Thank you.
