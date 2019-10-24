Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F382E29A0
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 06:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408360AbfJXEpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 00:45:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42020 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbfJXEpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 00:45:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::b7e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B8D2A14B7F8A4;
        Wed, 23 Oct 2019 21:45:38 -0700 (PDT)
Date:   Wed, 23 Oct 2019 21:45:37 -0700 (PDT)
Message-Id: <20191023.214537.487334280636522885.davem@davemloft.net>
To:     martin.fuzzey@flowbird.group
Cc:     andrew@lunn.ch, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: smsc: LAN8740: add PHY_RST_AFTER_CLK_EN flag
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1571823889-16834-1-git-send-email-martin.fuzzey@flowbird.group>
References: <1571823889-16834-1-git-send-email-martin.fuzzey@flowbird.group>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 23 Oct 2019 21:45:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Fuzzey <martin.fuzzey@flowbird.group>
Date: Wed, 23 Oct 2019 11:44:24 +0200

> The LAN8740, like the 8720, also requires a reset after enabling clock.
> The datasheet [1] 3.8.5.1 says:
> 	"During a Hardware reset, an external clock must be supplied
> 	to the XTAL1/CLKIN signal."
> 
> I have observed this issue on a custom i.MX6 based board with
> the LAN8740A.
> 
> [1] http://ww1.microchip.com/downloads/en/DeviceDoc/8740a.pdf
> 
> Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>

Applied, thanks.
