Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E31AA2ADD1
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 06:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbfE0E5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 00:57:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50564 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbfE0E5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 00:57:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 513BD148AE7F2;
        Sun, 26 May 2019 21:57:50 -0700 (PDT)
Date:   Sun, 26 May 2019 21:57:49 -0700 (PDT)
Message-Id: <20190526.215749.1864392969022878522.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: bcm87xx: improve
 bcm87xx_config_init and feature detection
From:   David Miller <davem@davemloft.net>
In-Reply-To: <9ab5f57a-a0be-ca78-a824-df406244ed7b@gmail.com>
References: <9ab5f57a-a0be-ca78-a824-df406244ed7b@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 26 May 2019 21:57:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Fri, 24 May 2019 22:24:19 +0200

> PHY drivers don't have to and shouldn't fiddle with phylib internals.
> Most of the code in bcm87xx_config_init() can be removed because
> phylib takes care.
> 
> In addition I replaced usage of PHY_10GBIT_FEC_FEATURES with an
> implementation of the get_features callback. PHY_10GBIT_FEC_FEATURES
> is used by this driver only and it's questionable whether there
> will be any other PHY supporting this mode only. Having said that
> in one of the next kernel versions we may decide to remove it.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
