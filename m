Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9285DA3B
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 03:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbfGCBFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 21:05:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45456 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727186AbfGCBFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 21:05:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DEAF8140125A1;
        Tue,  2 Jul 2019 15:28:54 -0700 (PDT)
Date:   Tue, 02 Jul 2019 15:28:54 -0700 (PDT)
Message-Id: <20190702.152854.1152604157842069056.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next] r8169: add random MAC address fallback
From:   David Miller <davem@davemloft.net>
In-Reply-To: <637b6d1f-85b1-dc9a-8e77-68ffcd82eae9@gmail.com>
References: <637b6d1f-85b1-dc9a-8e77-68ffcd82eae9@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Jul 2019 15:28:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Tue, 2 Jul 2019 20:46:09 +0200

> It was reported that the GPD MicroPC is broken in a way that no valid
> MAC address can be read from the network chip. The vendor driver deals
> with this by assigning a random MAC address as fallback. So let's do
> the same.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
> v2:
> - fix broken commit message

Applied, thanks.
