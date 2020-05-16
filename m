Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE4F21D647A
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 00:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbgEPWUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 18:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726290AbgEPWUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 18:20:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855A4C061A0C
        for <netdev@vger.kernel.org>; Sat, 16 May 2020 15:20:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3743E119385CD;
        Sat, 16 May 2020 15:20:54 -0700 (PDT)
Date:   Sat, 16 May 2020 15:20:53 -0700 (PDT)
Message-Id: <20200516.152053.1210211589384440479.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: remove remaining call to
 mdiobus_unregister
From:   David Miller <davem@davemloft.net>
In-Reply-To: <4cf54a6a-cc51-58cf-3ad8-dd488ba44e60@gmail.com>
References: <4cf54a6a-cc51-58cf-3ad8-dd488ba44e60@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 May 2020 15:20:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sun, 17 May 2020 00:05:08 +0200

> After having switched to devm_mdiobus_register() also this remaining
> call to mdiobus_unregister() can be removed.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks.
