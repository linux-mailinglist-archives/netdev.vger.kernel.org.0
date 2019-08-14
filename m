Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 593C68DB98
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729543AbfHNR0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:26:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56760 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728956AbfHNR0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:26:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::202])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1625B154EA092;
        Wed, 14 Aug 2019 10:26:36 -0700 (PDT)
Date:   Wed, 14 Aug 2019 13:26:35 -0400 (EDT)
Message-Id: <20190814.132635.688267055362981937.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: realtek: add NBase-T PHY
 auto-detection
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e69e636d-9109-aec9-4d8a-e36af37a706b@gmail.com>
References: <e69e636d-9109-aec9-4d8a-e36af37a706b@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 14 Aug 2019 10:26:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Tue, 13 Aug 2019 08:09:32 +0200

> Realtek provided information on how the new NIC-integrated PHY's
> expose whether they support 2.5G/5G/10G. This allows to automatically
> differentiate 1Gbps and 2.5Gbps PHY's, and therefore allows to
> remove the fake PHY ID mechanism for RTL8125.
> So far RTL8125 supports 2.5Gbps only, but register layout for faster
> modes has been defined already, so let's use this information to be
> future-proof.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
