Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B61D36F31D
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 02:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhD3AJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 20:09:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36788 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhD3AJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 20:09:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id C84A44F4130CC;
        Thu, 29 Apr 2021 17:08:19 -0700 (PDT)
Date:   Thu, 29 Apr 2021 17:08:15 -0700 (PDT)
Message-Id: <20210429.170815.956010543291313915.davem@davemloft.net>
To:     dqfext@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kuba@kernel.org, Landen.Chao@mediatek.com, matthias.bgg@gmail.com,
        linux@armlinux.org.uk, sean.wang@mediatek.com,
        vivien.didelot@gmail.com, olteanv@gmail.com, robh+dt@kernel.org,
        linus.walleij@linaro.org, gregkh@linuxfoundation.org,
        sergio.paracuellos@gmail.com, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-staging@lists.linux.dev,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        weijie.gao@mediatek.com, gch981213@gmail.com,
        opensource@vdorst.com, frank-w@public-files.de, tglx@linutronix.de,
        maz@kernel.org
Subject: Re: [PATCH net-next 0/4] MT7530 interrupt support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210429062130.29403-1-dqfext@gmail.com>
References: <20210429062130.29403-1-dqfext@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 29 Apr 2021 17:08:20 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please fix this:

error: the following would cause module name conflict:
  drivers/net/phy/mediatek.ko
  drivers/usb/musb/mediatek.ko


Thanks.
