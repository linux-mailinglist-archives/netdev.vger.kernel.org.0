Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFE61DBCEF
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 20:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgETSdv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 20 May 2020 14:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgETSdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 14:33:51 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BAD3C061A0E
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 11:33:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 53ABA129A4D7A;
        Wed, 20 May 2020 11:33:50 -0700 (PDT)
Date:   Wed, 20 May 2020 11:33:49 -0700 (PDT)
Message-Id: <20200520.113349.506785638582427245.davem@davemloft.net>
To:     brambonne@google.com
Cc:     lorenzo@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, hannes@stressinduktion.org,
        netdev@vger.kernel.org, jeffv@google.com, maze@google.com
Subject: Re: [PATCH] ipv6: Add IN6_ADDR_GEN_MODE_STABLE_PRIVACY_SOFTMAC mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CABWXKLxGwWdYhzuUPFukUZ4F7=yHsYg+BJBi=OViyc42WSfKJg@mail.gmail.com>
References: <20200519120748.115833-1-brambonne@google.com>
        <CAKD1Yr2T2S__ZpPOwvwcUqbm=60E9OGODD7RXq+dUFAGQkWPWA@mail.gmail.com>
        <CABWXKLxGwWdYhzuUPFukUZ4F7=yHsYg+BJBi=OViyc42WSfKJg@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 May 2020 11:33:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bram Bonné <brambonne@google.com>
Date: Wed, 20 May 2020 15:16:53 +0200

> Trying to change the MAC when the device is up errors with EBUSY on my
> machines, so I was under the assumption that the device needs to be
> down to change the MAC. I could very well be wrong though.

Not all drivers/devices have this limitation, the generic code allows this
just fine.

