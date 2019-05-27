Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16D232ADFB
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 07:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbfE0FVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 01:21:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50862 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbfE0FVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 01:21:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 26428149CD307;
        Sun, 26 May 2019 22:21:37 -0700 (PDT)
Date:   Sun, 26 May 2019 22:21:36 -0700 (PDT)
Message-Id: <20190526.222136.618523121010690050.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: remove support for RTL_GIGA_MAC_VER_01
From:   David Miller <davem@davemloft.net>
In-Reply-To: <48cd2f91-3fbb-00d9-c02f-259b7583ce8e@gmail.com>
References: <48cd2f91-3fbb-00d9-c02f-259b7583ce8e@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 26 May 2019 22:21:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sat, 25 May 2019 21:14:39 +0200

> RTL_GIGA_MAC_VER_01 is RTL8169, the ancestor of the chip family.
> It didn't have an internal PHY and I've never seen it in the wild.
> What isn't there doesn't need to be maintained, so let's remove
> support for it.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
