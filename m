Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43DE91B15ED
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 21:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgDTT1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 15:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726141AbgDTT1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 15:27:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320E3C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 12:27:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E4F40127F9DC8;
        Mon, 20 Apr 2020 12:27:37 -0700 (PDT)
Date:   Mon, 20 Apr 2020 12:27:37 -0700 (PDT)
Message-Id: <20200420.122737.28755520427349098.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: inline rtl8169_make_unusable_by_asic
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d5d0e0fa-8947-88b6-5d6a-9cd7f1bf274a@gmail.com>
References: <d5d0e0fa-8947-88b6-5d6a-9cd7f1bf274a@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Apr 2020 12:27:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sun, 19 Apr 2020 23:16:55 +0200

> Inline rtl8169_make_unusable_by_asic() and simplify it:
> - Address field doesn't need to be poisoned because descriptor is
>   owned by CPU now
> - desc->opts1 is set by rtl8169_mark_to_asic() and rtl8169_rx_fill(),
>   therefore we don't have to preserve any field parts.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
