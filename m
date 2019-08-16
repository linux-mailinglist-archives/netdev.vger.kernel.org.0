Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04940907FC
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 20:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbfHPS54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 14:57:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38032 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727466AbfHPS5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 14:57:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 50175133FACBC;
        Fri, 16 Aug 2019 11:57:55 -0700 (PDT)
Date:   Fri, 16 Aug 2019 11:57:54 -0700 (PDT)
Message-Id: <20190816.115754.393902669786330872.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, khilman@baylibre.com,
        vivien.didelot@gmail.com, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org
Subject: Re: [PATCH net-next 0/3] net: phy: remove genphy_config_init
From:   David Miller <davem@davemloft.net>
In-Reply-To: <95dfdb55-415c-c995-cba3-1902bdd46aec@gmail.com>
References: <95dfdb55-415c-c995-cba3-1902bdd46aec@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 16 Aug 2019 11:57:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Thu, 15 Aug 2019 14:01:43 +0200

> Supported PHY features are either auto-detected or explicitly set.
> In both cases calling genphy_config_init isn't needed. All that
> genphy_config_init does is removing features that are set as
> supported but can't be auto-detected. Basically it duplicates the
> code in genphy_read_abilities. Therefore remove genphy_config_init.

Heiner you will need to respin this series as the new adin driver
added a new call to genphy_config_init().

Thank you.
