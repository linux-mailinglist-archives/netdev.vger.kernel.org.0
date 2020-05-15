Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222A31D428E
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 02:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgEOA7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 20:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728063AbgEOA7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 20:59:05 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D25C061A0C;
        Thu, 14 May 2020 17:59:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E7AB614DD3DAB;
        Thu, 14 May 2020 17:59:04 -0700 (PDT)
Date:   Thu, 14 May 2020 17:59:04 -0700 (PDT)
Message-Id: <20200514.175904.679977118713201529.davem@davemloft.net>
To:     brgl@bgdev.pl
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bgolaszewski@baylibre.com
Subject: Re: [PATCH] net: phy: mdio-moxart: remove unneeded include
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200514165938.21725-1-brgl@bgdev.pl>
References: <20200514165938.21725-1-brgl@bgdev.pl>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 17:59:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 14 May 2020 18:59:38 +0200

> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> mdio-moxart doesn't use regulators in the driver code. We can remove
> the regulator include.
> 
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Applied to net-next.
