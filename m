Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 725B289616
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 06:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfHLEYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 00:24:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38502 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbfHLEYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 00:24:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CAAC2145487AB;
        Sun, 11 Aug 2019 21:24:46 -0700 (PDT)
Date:   Sun, 11 Aug 2019 21:24:46 -0700 (PDT)
Message-Id: <20190811.212446.1460580794689510464.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/4] net: phy: realtek: add support for
 integrated 2.5Gbps PHY in RTL8125
From:   David Miller <davem@davemloft.net>
In-Reply-To: <755b2bc9-22cb-f529-4188-0f4b6e48efbd@gmail.com>
References: <755b2bc9-22cb-f529-4188-0f4b6e48efbd@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 11 Aug 2019 21:24:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Fri, 9 Aug 2019 20:41:58 +0200

> This series adds support for the integrated 2.5Gbps PHY in RTL8125.
> First three patches add necessary functionality to phylib.
> 
> Changes in v2:
> - added patch 1
> - changed patch 4 to use a fake PHY ID that is injected by the
>   network driver. This allows to use a dedicated PHY driver.

Series applied, thanks Heiner.
