Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5983D1F109B
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 02:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbgFHAKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 20:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727878AbgFHAKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 20:10:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC9CC08C5C3;
        Sun,  7 Jun 2020 17:10:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 905CD12741D61;
        Sun,  7 Jun 2020 17:10:07 -0700 (PDT)
Date:   Sun, 07 Jun 2020 17:10:06 -0700 (PDT)
Message-Id: <20200607.171006.1687043130909899357.davem@davemloft.net>
To:     martin.blumenstingl@googlemail.com
Cc:     hauke@hauke-m.de, netdev@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v1] net: dsa: lantiq_gswip: fix and improve the
 unsupported interface error
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200607130258.3020392-1-martin.blumenstingl@googlemail.com>
References: <20200607130258.3020392-1-martin.blumenstingl@googlemail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 07 Jun 2020 17:10:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Sun,  7 Jun 2020 15:02:58 +0200

> While trying to use the lantiq_gswip driver on one of my boards I made
> a mistake when specifying the phy-mode (because the out-of-tree driver
> wants phy-mode "gmii" or "mii" for the internal PHYs). In this case the
> following error is printed multiple times:
>   Unsupported interface: 3
> 
> While it gives at least a hint at what may be wrong it is not very user
> friendly. Print the human readable phy-mode and also which port is
> configured incorrectly (this hardware supports ports 0..6) to improve
> the cases where someone made a mistake.
> 
> Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Looks good, applied, thank you.
