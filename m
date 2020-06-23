Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0142206727
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 00:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387635AbgFWWZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 18:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387586AbgFWWZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 18:25:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA39BC061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 15:25:30 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4AAE41294DBBA;
        Tue, 23 Jun 2020 15:25:30 -0700 (PDT)
Date:   Tue, 23 Jun 2020 15:25:29 -0700 (PDT)
Message-Id: <20200623.152529.1844437800442407638.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: rename RTL8125 to RTL8125A
From:   David Miller <davem@davemloft.net>
In-Reply-To: <639d7e95-baa6-6535-9ecf-008025dc446a@gmail.com>
References: <639d7e95-baa6-6535-9ecf-008025dc446a@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jun 2020 15:25:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Tue, 23 Jun 2020 23:04:42 +0200

> Realtek added new members to the RTL8125 chip family, therefore rename
> RTL8125 to RTL8125a. Then we use the same chip naming as in the r8125
> vendor driver.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.

