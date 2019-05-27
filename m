Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3212ADFA
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 07:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbfE0FVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 01:21:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50848 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbfE0FVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 01:21:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AE032149CD306;
        Sun, 26 May 2019 22:21:31 -0700 (PDT)
Date:   Sun, 26 May 2019 22:21:31 -0700 (PDT)
Message-Id: <20190526.222131.1622041712717839672.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: improve RTL8168d PHY initialization
From:   David Miller <davem@davemloft.net>
In-Reply-To: <a0697e71-d695-19af-974d-56e53cb1a3a0@gmail.com>
References: <a0697e71-d695-19af-974d-56e53cb1a3a0@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 26 May 2019 22:21:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sat, 25 May 2019 20:57:42 +0200

> Certain parts of the PHY initialization are the same for sub versions
> 1 and 2 of RTL8168d. So let's factor this out to simplify the code.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
