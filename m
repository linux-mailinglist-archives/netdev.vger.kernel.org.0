Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBCEB476DB
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 22:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbfFPUx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 16:53:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52030 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfFPUx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 16:53:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 85CF9151BF939;
        Sun, 16 Jun 2019 13:53:58 -0700 (PDT)
Date:   Sun, 16 Jun 2019 13:53:57 -0700 (PDT)
Message-Id: <20190616.135357.658647099528379354.davem@davemloft.net>
To:     martin.blumenstingl@googlemail.com
Cc:     netdev@vger.kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        linus.walleij@linaro.org, andrew@lunn.ch,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1 0/5] stmmac: cleanups for stmmac_mdio_reset
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190615100932.27101-1-martin.blumenstingl@googlemail.com>
References: <20190615100932.27101-1-martin.blumenstingl@googlemail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Jun 2019 13:53:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Sat, 15 Jun 2019 12:09:27 +0200

> This is a successor to my previous series "stmmac: honor the GPIO flags
> for the PHY reset GPIO" from [0]. It contains only the "cleanup"
> patches from that series plus some additional cleanups on top.
> 
> I broke out the actual GPIO flag handling into a separate patch which
> is already part of net-next: "net: stmmac: use GPIO descriptors in
> stmmac_mdio_reset" from [1]
> 
> I have build and runtime tested this on my ARM Meson8b Odroid-C1.
> 
> 
> [0] https://patchwork.kernel.org/cover/10983801/
> [1] https://patchwork.ozlabs.org/patch/1114798/

Looks good, series applied.
