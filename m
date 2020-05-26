Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11FA1C1DAD
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 21:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730466AbgEATM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 15:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729930AbgEATM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 15:12:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8062EC061A0C
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 12:12:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5E5A814B81655;
        Fri,  1 May 2020 12:12:25 -0700 (PDT)
Date:   Fri, 01 May 2020 12:12:21 -0700 (PDT)
Message-Id: <20200501.121221.515599481926307230.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: remove not needed parameter in
 rtl8169_set_magic_reg
From:   David Miller <davem@davemloft.net>
In-Reply-To: <52b40061-60d2-d517-4e82-bb2077ede8d8@gmail.com>
References: <52b40061-60d2-d517-4e82-bb2077ede8d8@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 May 2020 12:12:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Fri, 1 May 2020 10:11:28 +0200

> Remove a not needed parameter in rtl8169_set_magic_reg.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks.
