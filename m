Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5013F258AC
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 22:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbfEUUMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 16:12:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44640 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727283AbfEUUMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 16:12:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EA1F014C7E003;
        Tue, 21 May 2019 13:12:21 -0700 (PDT)
Date:   Tue, 21 May 2019 13:12:21 -0700 (PDT)
Message-Id: <20190521.131221.353352458158209115.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phylink: ensure inband AN works correctly
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1hSjsm-0000o3-Q7@rmk-PC.armlinux.org.uk>
References: <E1hSjsm-0000o3-Q7@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 May 2019 13:12:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Mon, 20 May 2019 16:07:20 +0100

> Do not update the link interface mode while the link is down to avoid
> spurious link interface changes.
> 
> Always call mac_config if we have a PHY to propagate the pause mode
> settings to the MAC.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied.
