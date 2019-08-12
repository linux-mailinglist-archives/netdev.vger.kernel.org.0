Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C552189642
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 06:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbfHLE0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 00:26:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38512 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbfHLE0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 00:26:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7A8A0145487BD;
        Sun, 11 Aug 2019 21:26:01 -0700 (PDT)
Date:   Sun, 11 Aug 2019 21:26:01 -0700 (PDT)
Message-Id: <20190811.212601.616620268753444689.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: inline rtl8169_free_rx_databuff
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e0902cae-4557-dcda-9c96-ad19b3c05993@gmail.com>
References: <e0902cae-4557-dcda-9c96-ad19b3c05993@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 11 Aug 2019 21:26:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Fri, 9 Aug 2019 22:59:07 +0200

> rtl8169_free_rx_databuff is used in only one place, so let's inline it.
> We can improve the loop because rtl8169_init_ring zero's RX_databuff
> before calling rtl8169_rx_fill, and rtl8169_rx_fill fills
> Rx_databuff starting from index 0.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks Heiner.
