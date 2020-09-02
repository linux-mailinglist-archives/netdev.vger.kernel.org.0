Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B18425A272
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 02:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgIBAuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 20:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgIBAuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 20:50:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88579C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 17:50:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9758913664841;
        Tue,  1 Sep 2020 17:33:24 -0700 (PDT)
Date:   Tue, 01 Sep 2020 17:50:08 -0700 (PDT)
Message-Id: <20200901.175008.1418791168024768796.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH 0/2 v2] RTL8366 stabilization
From:   David Miller <davem@davemloft.net>
In-Reply-To: <b3f4f867-3395-a861-936a-43463812ce06@gmail.com>
References: <20200901190854.15528-1-linus.walleij@linaro.org>
        <20200901.153959.1284935680059177248.davem@davemloft.net>
        <b3f4f867-3395-a861-936a-43463812ce06@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 01 Sep 2020 17:33:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Tue, 1 Sep 2020 15:42:40 -0700

> 
> 
> On 9/1/2020 3:39 PM, David Miller wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
>> Date: Tue,  1 Sep 2020 21:08:52 +0200
>> 
>>> This stabilizes the RTL8366 driver by checking validity
>>> of the passed VLANs and refactoring the member config
>>> (MC) code so we do not require strict call order and
>>> de-duplicate some code.
>>>
>>> Changes from v1: incorporate review comments on patch
>>> 2.
>> Series applied, thank you.
> 
> There was a v3 submitted about 30 minutes ago, is that the one you
> applied?

No I applied the v2 :-/
