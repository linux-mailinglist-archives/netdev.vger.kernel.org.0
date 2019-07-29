Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6485792C6
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 20:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387423AbfG2SFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 14:05:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37016 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727743AbfG2SFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 14:05:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EAC47140505D7;
        Mon, 29 Jul 2019 11:05:41 -0700 (PDT)
Date:   Mon, 29 Jul 2019 11:05:41 -0700 (PDT)
Message-Id: <20190729.110541.288160530723382059.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org, linux@eikelenboom.it,
        edumazet@google.com
Subject: Re: [PATCH net-next] r8169: make use of xmit_more
From:   David Miller <davem@davemloft.net>
In-Reply-To: <2950b2f7-7460-cce0-d964-ad654d897295@gmail.com>
References: <2950b2f7-7460-cce0-d964-ad654d897295@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jul 2019 11:05:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sun, 28 Jul 2019 11:25:19 +0200

> There was a previous attempt to use xmit_more, but the change had to be
> reverted because under load sometimes a transmit timeout occurred [0].
> Maybe this was caused by a missing memory barrier, the new attempt
> keeps the memory barrier before the call to netif_stop_queue like it
> is used by the driver as of today. The new attempt also changes the
> order of some calls as suggested by Eric.
> 
> [0] https://lkml.org/lkml/2019/2/10/39
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
