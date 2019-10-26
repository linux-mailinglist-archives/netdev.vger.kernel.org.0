Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A17DDE5858
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 05:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbfJZD3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 23:29:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40290 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfJZD3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 23:29:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 20E0D14B7CD11;
        Fri, 25 Oct 2019 20:29:39 -0700 (PDT)
Date:   Fri, 25 Oct 2019 20:29:38 -0700 (PDT)
Message-Id: <20191025.202938.1986517512835433449.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: improve rtl8169_rx_fill
From:   David Miller <davem@davemloft.net>
In-Reply-To: <fb0f8c51-6ef4-ed93-254e-871f482f8f6e@gmail.com>
References: <fb0f8c51-6ef4-ed93-254e-871f482f8f6e@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 25 Oct 2019 20:29:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Wed, 23 Oct 2019 21:36:14 +0200

> We have only one user of the error path, so we can inline it.
> In addition the call to rtl8169_make_unusable_by_asic() can be removed
> because rtl8169_alloc_rx_data() didn't call rtl8169_mark_to_asic() yet
> for the respective index if returning NULL.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
