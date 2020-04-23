Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2211B52D7
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 05:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgDWC7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 22:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbgDWC7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 22:59:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C03C03C1AA;
        Wed, 22 Apr 2020 19:59:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BA994127B6239;
        Wed, 22 Apr 2020 19:59:47 -0700 (PDT)
Date:   Wed, 22 Apr 2020 19:59:47 -0700 (PDT)
Message-Id: <20200422.195947.725312745030873910.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     richardcochran@gmail.com, lokeshvutla@ti.com, tony@atomide.com,
        netdev@vger.kernel.org, nsekhar@ti.com,
        linux-kernel@vger.kernel.org, m-karicheri2@ti.com,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH net-next v4 00/10] net: ethernet: ti: cpts: add irq and
 HW_TS_PUSH events
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200422.195705.2021017077827664261.davem@davemloft.net>
References: <20200422201254.15232-1-grygorii.strashko@ti.com>
        <20200422.195705.2021017077827664261.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Apr 2020 19:59:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 22 Apr 2020 19:57:05 -0700 (PDT)

> From: Grygorii Strashko <grygorii.strashko@ti.com>
> Date: Wed, 22 Apr 2020 23:12:44 +0300
> 
>> This is re-spin of patches to add CPSW IRQ and HW_TS_PUSH events support I've
>> sent long time ago [1]. In this series, I've tried to restructure and split changes,
>> and also add few additional optimizations comparing to initial RFC submission [1].
>  ...
> 
> Series applied, thanks.

Actually I had to revert, this breaks the build:

[davem@localhost net-next]$ make -s -j14
ERROR: modpost: "cpts_misc_interrupt" [drivers/net/ethernet/ti/ti_cpsw_new.ko] undefined!
ERROR: modpost: "cpts_misc_interrupt" [drivers/net/ethernet/ti/ti_cpsw.ko] undefined!
make[1]: *** [scripts/Makefile.modpost:94: __modpost] Error 1
make: *** [Makefile:1319: modules] Error 2
