Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B46F5EBA8
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 20:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbfGCSbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 14:31:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60598 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfGCSbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 14:31:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4A978140F4EA9;
        Wed,  3 Jul 2019 11:31:52 -0700 (PDT)
Date:   Wed, 03 Jul 2019 11:31:51 -0700 (PDT)
Message-Id: <20190703.113151.206946398577844828.davem@davemloft.net>
To:     hayeswang@realtek.com
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH net] r8152: move calling r8153b_rx_agg_chg_indicate()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-287-albertk@realtek.com>
References: <1394712342-15778-287-albertk@realtek.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 03 Jul 2019 11:31:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Wed, 3 Jul 2019 15:11:56 +0800

> r8153b_rx_agg_chg_indicate() needs to be called after enabling TX/RX and
> before calling rxdy_gated_en(tp, false). Otherwise, the change of the
> settings of RX aggregation wouldn't work.
> 
> Besides, adjust rtl8152_set_coalesce() for the same reason. If
> rx_coalesce_usecs is changed, restart TX/RX to let the setting work.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied.
