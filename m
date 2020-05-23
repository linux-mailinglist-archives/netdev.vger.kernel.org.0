Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C87B1DFBFE
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 01:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388138AbgEWXyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 19:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388111AbgEWXyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 19:54:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA1DC061A0E
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 16:54:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 93B1E12873757;
        Sat, 23 May 2020 16:54:51 -0700 (PDT)
Date:   Sat, 23 May 2020 16:54:50 -0700 (PDT)
Message-Id: <20200523.165450.885720721813634154.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] r8169: remove mask argument from few
 ERI/OCP functions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <ba72d0ee-713b-0721-ed50-5dbfe502ffba@gmail.com>
References: <ba72d0ee-713b-0721-ed50-5dbfe502ffba@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 23 May 2020 16:54:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sat, 23 May 2020 13:20:33 +0200

> Few ERI/OCP functions have a mask argument that isn't needed.
> Remove it to simplify the functions.

Series applied, thanks Heiner.
