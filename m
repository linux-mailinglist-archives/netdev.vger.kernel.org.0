Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E18520DFE8
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389573AbgF2Uky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731692AbgF2TOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:14:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C4EC03E97B
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 20:58:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A981F129AD879;
        Sun, 28 Jun 2020 20:58:13 -0700 (PDT)
Date:   Sun, 28 Jun 2020 20:58:12 -0700 (PDT)
Message-Id: <20200628.205812.198921706380361991.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] r8169: make RTL8401 a separate chip
 version
From:   David Miller <davem@davemloft.net>
In-Reply-To: <29ba5d31-9a0f-05c4-1472-5b15330f6408@gmail.com>
References: <29ba5d31-9a0f-05c4-1472-5b15330f6408@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 28 Jun 2020 20:58:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sun, 28 Jun 2020 23:14:34 +0200

> So far RTL8401 was treated like a RTL8101e, means we relied on the BIOS
> to configure MAC and PHY properly. Make RTL8401 a separate chip version
> and copy MAC / PHY config from r8101 vendor driver.

Series applied, thanks Heiner.
