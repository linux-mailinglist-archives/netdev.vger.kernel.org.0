Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8F8D136074
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 19:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388517AbgAISsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 13:48:52 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57018 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732160AbgAISsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 13:48:52 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4201E158477DF;
        Thu,  9 Jan 2020 10:48:51 -0800 (PST)
Date:   Thu, 09 Jan 2020 10:48:48 -0800 (PST)
Message-Id: <20200109.104848.1859705889959376262.davem@davemloft.net>
To:     mparab@cadence.com
Cc:     andrew@lunn.ch, jakub.kicinski@netronome.com,
        rmk+kernel@armlinux.org.uk, nicolas.ferre@microchip.com,
        f.fainelli@gmail.com, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dkangude@cadence.com,
        pthombar@cadence.com
Subject: Re: [PATCH net-next] net: macb: add support for C45 MDIO read/write
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1578559006-16343-1-git-send-email-mparab@cadence.com>
References: <1578559006-16343-1-git-send-email-mparab@cadence.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Jan 2020 10:48:51 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Milind Parab <mparab@cadence.com>
Date: Thu, 9 Jan 2020 08:36:46 +0000

> This patch modify MDIO read/write functions to support
> communication with C45 PHY.
> 
> Signed-off-by: Milind Parab <mparab@cadence.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks.
