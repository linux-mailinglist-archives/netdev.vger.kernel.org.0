Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECF23182B4
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 01:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbfEHXb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 19:31:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53790 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbfEHXb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 19:31:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3F0791433EAEB;
        Wed,  8 May 2019 16:31:56 -0700 (PDT)
Date:   Wed, 08 May 2019 16:31:52 -0700 (PDT)
Message-Id: <20190508.163152.1104213638206267502.davem@davemloft.net>
To:     fancer.lancer@gmail.com
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        olteanv@gmail.com, martin.blumenstingl@googlemail.com,
        Sergey.Semin@t-platforms.ru, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/2] net: phy: realtek: Fix RGMII TX/RX-delays
 initial config of rtl8211(e|f)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190508215115.19802-1-fancer.lancer@gmail.com>
References: <20190508012920.13710-1-fancer.lancer@gmail.com>
        <20190508215115.19802-1-fancer.lancer@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 May 2019 16:31:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Serge Semin <fancer.lancer@gmail.com>
Date: Thu,  9 May 2019 00:51:13 +0300

> It has been discovered that RX/TX delays of rtl8211e ethernet PHY
> can be configured via a MDIO register hidden in the extension pages
> layout. Particularly the extension page 0xa4 provides a register 0x1c,
> which bits 1 and 2 control the described delays. They are used to
> implement the "rgmii-{id,rxid,txid}" phy-mode support in patch 1.
> 
> The second patch makes sure the rtl8211f TX-delay is configured only
> if RGMII interface mode is specified including the rgmii-rxid one.
> In other cases (most importantly for NA mode) the delays are supposed
> to be preconfigured by some other software or hardware and should be
> left as is without any modification. The similar thing is also done
> for rtl8211e in the patch 1 of this series.
> 
> Signed-off-by: Serge Semin <fancer.lancer@gmail.com>
> 
> Changelog v3
> - Add this cover-letter.
> - Add Andrew' Reviewed-by tag to patch 1.
> - Accept RGMII_RXID interface mode for rtl8211f and clear the TX_DELAY
>   bit in this case.
> - Initialize ret variable with 0 to prevent the "may be used uninitialized"
>   warning in patch 1.
> 
> Changelog v4
> - Rebase onto net-next

Series applied.
