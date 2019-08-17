Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8990F912B6
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 21:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfHQTfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 15:35:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55476 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfHQTfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 15:35:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9EA8314DB6DEB;
        Sat, 17 Aug 2019 12:35:08 -0700 (PDT)
Date:   Sat, 17 Aug 2019 12:35:03 -0700 (PDT)
Message-Id: <20190817.123503.1634208808108251879.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, khilman@baylibre.com,
        vivien.didelot@gmail.com, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org
Subject: Re: [PATCH net-next v3 0/3] net: phy: remove genphy_config_init
From:   David Miller <davem@davemloft.net>
In-Reply-To: <8790db9d-af10-c3b1-bc65-ee21bb99e6d9@gmail.com>
References: <8790db9d-af10-c3b1-bc65-ee21bb99e6d9@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 17 Aug 2019 12:35:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sat, 17 Aug 2019 12:28:18 +0200

> Supported PHY features are either auto-detected or explicitly set.
> In both cases calling genphy_config_init isn't needed. All that
> genphy_config_init does is removing features that are set as
> supported but can't be auto-detected. Basically it duplicates the
> code in genphy_read_abilities. Therefore remove genphy_config_init.
> 
> v2:
> - remove call also from new adin driver
> v3:
> - pass NULL as config_init function pointer for dp83848

Series applied.
