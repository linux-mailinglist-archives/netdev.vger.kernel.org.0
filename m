Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D894A7D19A
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 00:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729805AbfGaW5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 18:57:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45114 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfGaW5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 18:57:08 -0400
Received: from localhost (c-24-20-22-31.hsd1.or.comcast.net [24.20.22.31])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6017F1264EC7E;
        Wed, 31 Jul 2019 15:57:07 -0700 (PDT)
Date:   Wed, 31 Jul 2019 18:57:05 -0400 (EDT)
Message-Id: <20190731.185705.323737673654483593.davem@davemloft.net>
To:     baijiaju1990@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: phy: phy_led_triggers: Fix a possible
 null-pointer dereference in phy_led_trigger_change_speed()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190730080813.15363-1-baijiaju1990@gmail.com>
References: <20190730080813.15363-1-baijiaju1990@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 31 Jul 2019 15:57:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>
Date: Tue, 30 Jul 2019 16:08:13 +0800

> In phy_led_trigger_change_speed(), there is an if statement on line 48
> to check whether phy->last_triggered is NULL: 
>     if (!phy->last_triggered)
> 
> When phy->last_triggered is NULL, it is used on line 52:
>     led_trigger_event(&phy->last_triggered->trigger, LED_OFF);
> 
> Thus, a possible null-pointer dereference may occur.
> 
> To fix this bug, led_trigger_event(&phy->last_triggered->trigger,
> LED_OFF) is called when phy->last_triggered is not NULL.
> 
> This bug is found by a static analysis tool STCheck written by
> the OSLAB group in Tsinghua University.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>

Applied, thanks.
