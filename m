Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D506C8F3CA
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 20:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730383AbfHOSoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 14:44:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48084 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728579AbfHOSoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 14:44:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DC46113E99E02;
        Thu, 15 Aug 2019 11:44:04 -0700 (PDT)
Date:   Thu, 15 Aug 2019 11:44:04 -0700 (PDT)
Message-Id: <20190815.114404.1587903954041144157.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: swphy: emulate register MII_ESTATUS
From:   David Miller <davem@davemloft.net>
In-Reply-To: <25690798-5122-d5a2-7d2b-c166b8649a2e@gmail.com>
References: <25690798-5122-d5a2-7d2b-c166b8649a2e@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 Aug 2019 11:44:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Thu, 15 Aug 2019 13:19:22 +0200

> When the genphy driver binds to a swphy it will call
> genphy_read_abilites that will try to read MII_ESTATUS if BMSR_ESTATEN
> is set in MII_BMSR. So far this would read the default value 0xffff
> and 1000FD and 1000HD are reported as supported just by chance.
> Better add explicit support for emulating MII_ESTATUS.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied.
