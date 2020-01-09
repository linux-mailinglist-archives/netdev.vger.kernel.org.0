Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17012135040
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 01:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbgAIAFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 19:05:05 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50032 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbgAIAFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 19:05:05 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7048315371C53;
        Wed,  8 Jan 2020 16:05:04 -0800 (PST)
Date:   Wed, 08 Jan 2020 16:05:04 -0800 (PST)
Message-Id: <20200108.160504.70835632792570059.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: add constant EnAnaPLL
From:   David Miller <davem@davemloft.net>
In-Reply-To: <14a9a6bd-ff54-0912-07ec-a38e3dfd55f2@gmail.com>
References: <14a9a6bd-ff54-0912-07ec-a38e3dfd55f2@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jan 2020 16:05:04 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Wed, 8 Jan 2020 07:36:08 +0100

> Use constant EnAnaPLL for bit 14 as in vendor driver. The vendor
> driver sets this bit for chip version 02 only, but I'm not aware of
> any issues, so better leave it as it is.
> In addition remove the useless debug message.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
