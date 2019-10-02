Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBC1C8DEB
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 18:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbfJBQKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 12:10:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33414 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbfJBQKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 12:10:09 -0400
Received: from localhost (unknown [172.58.43.221])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B12F3153BF449;
        Wed,  2 Oct 2019 09:10:07 -0700 (PDT)
Date:   Wed, 02 Oct 2019 12:10:04 -0400 (EDT)
Message-Id: <20191002.121004.2212668620537376356.davem@davemloft.net>
To:     linus.walleij@linaro.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: rtl8366: Check VLAN ID and not ports
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191001142843.10746-1-linus.walleij@linaro.org>
References: <20191001142843.10746-1-linus.walleij@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 02 Oct 2019 09:10:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>
Date: Tue,  1 Oct 2019 16:28:43 +0200

> There has been some confusion between the port number and
> the VLAN ID in this driver. What we need to check for
> validity is the VLAN ID, nothing else.
> 
> The current confusion came from assigning a few default
> VLANs for default routing and we need to rewrite that
> properly.
> 
> Instead of checking if the port number is a valid VLAN
> ID, check the actual VLAN IDs passed in to the callback
> one by one as expected.
> 
> Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Applied and queued up for -stable, thanks.
