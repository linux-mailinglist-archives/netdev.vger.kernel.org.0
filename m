Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213581D1EF7
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390526AbgEMTXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732218AbgEMTXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:23:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0BCC061A0C;
        Wed, 13 May 2020 12:23:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 124F2127E5AC1;
        Wed, 13 May 2020 12:23:39 -0700 (PDT)
Date:   Wed, 13 May 2020 12:23:38 -0700 (PDT)
Message-Id: <20200513.122338.1849377923675371554.davem@davemloft.net>
To:     martin.blumenstingl@googlemail.com
Cc:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        jianxin.pan@amlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 0/8] dwmac-meson8b Ethernet RX delay configuration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200512211103.530674-1-martin.blumenstingl@googlemail.com>
References: <20200512211103.530674-1-martin.blumenstingl@googlemail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 May 2020 12:23:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Tue, 12 May 2020 23:10:55 +0200

> The Ethernet TX performance has been historically bad on Meson8b and
> Meson8m2 SoCs because high packet loss was seen. I found out that this
> was related (yet again) to the RGMII TX delay configuration.
> In the process of discussing the big picture (and not just a single
> patch) [0] with Andrew I discovered that the IP block behind the
> dwmac-meson8b driver actually seems to support the configuration of the
> RGMII RX delay (at least on the Meson8b SoC generation).
> 
> Since I sent the first RFC I got additional documentation from Jianxin
> (many thanks!). Also I have discovered some more interesting details:
> - Meson8b Odroid-C1 requires an RX delay (by either the PHY or the MAC)
>   Based on the vendor u-boot code (not upstream) I assume that it will
>   be the same for all Meson8b and Meson8m2 boards
> - Khadas VIM2 seems to have the RX delay built into the PCB trace
>   length. When I enable the RX delay on the PHY or MAC I can't get any
>   data through. I expect that we will have the same situation on all
>   GXBB, GXM, AXG, G12A, G12B and SM1 boards. Further clarification is
>   needed here though (since I can't visually see these lengthened
>   traces on the PCB). This will be done before sending patches for
>   these boards.
 ...

Series applied to net-next, thanks Martin.
