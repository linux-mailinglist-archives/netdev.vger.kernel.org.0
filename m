Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAA896942
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 21:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730657AbfHTTTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 15:19:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49882 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730615AbfHTTTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 15:19:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 165CE146A552D;
        Tue, 20 Aug 2019 12:19:20 -0700 (PDT)
Date:   Tue, 20 Aug 2019 12:19:14 -0700 (PDT)
Message-Id: <20190820.121914.353969420673277374.davem@davemloft.net>
To:     hayeswang@realtek.com
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] r8152: divide the tx and rx bottom
 functions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-303-Taiwan-albertk@realtek.com>
References: <1394712342-15778-301-Taiwan-albertk@realtek.com>
        <1394712342-15778-303-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 20 Aug 2019 12:19:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Mon, 19 Aug 2019 14:40:36 +0800

> Move the tx bottom function from NAPI to a new tasklet. Then, for
> multi-cores, the bottom functions of tx and rx may be run at same
> time with different cores. This is used to improve performance.
> 
> On x86, Tx/Rx 943/943 Mbits/sec -> 945/944.
> For arm platform, Tx/Rx: 917/917 Mbits/sec -> 933/933.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
> v2: add the performance number in the commit message.

Applied.
