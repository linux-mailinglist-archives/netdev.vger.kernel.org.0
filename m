Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0C1141A8
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 19:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbfEERwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 13:52:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53284 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbfEERwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 13:52:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0FD7814D9722B;
        Sun,  5 May 2019 10:52:30 -0700 (PDT)
Date:   Sun, 05 May 2019 10:52:29 -0700 (PDT)
Message-Id: <20190505.105229.126192729302844275.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: speed up rtl_loop_wait
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1d0fa904-b911-8349-27fb-6cec1d8f8287@gmail.com>
References: <1d0fa904-b911-8349-27fb-6cec1d8f8287@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 10:52:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sat, 4 May 2019 15:20:38 +0200

> When testing I figured out that most operations signal finish even
> before we trigger the first delay. Seems like PCI(e) access and
> memory barriers typically add enough latency. Therefore move the
> first delay after the first check.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks.
