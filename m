Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6665BBDD67
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 13:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405021AbfIYLsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 07:48:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34778 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbfIYLsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 07:48:08 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BEDA7154EB6ED;
        Wed, 25 Sep 2019 04:48:06 -0700 (PDT)
Date:   Wed, 25 Sep 2019 13:48:04 +0200 (CEST)
Message-Id: <20190925.134804.822373952298090025.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        tinywrkb@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] Attempt to fix regression with AR8035 speed
 downgrade
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190922105932.GP25745@shell.armlinux.org.uk>
References: <20190922105932.GP25745@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Sep 2019 04:48:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Sun, 22 Sep 2019 11:59:32 +0100

> tinywrkb, please can you test this series to ensure that it fixes
> your problem - the previous version has turned out to be a non-starter
> as it introduces more problems, thanks!
> 
> The following series attempts to address an issue spotted by tinywrkb
> with the AR8035 on the Cubox-i2 in a situation where the PHY downgrades
> the negotiated link.
 ...

This doesn't apply cleanly to the current 'net' tree, please respin.
