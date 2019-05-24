Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96C9F29FF7
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 22:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404140AbfEXUju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 16:39:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42920 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404054AbfEXUju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 16:39:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 983CB14E2E4D7;
        Fri, 24 May 2019 13:39:49 -0700 (PDT)
Date:   Fri, 24 May 2019 13:39:48 -0700 (PDT)
Message-Id: <20190524.133948.727397431564765766.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     madalin.bucur@nxp.com, shawnguo@kernel.org, leoyang.li@nxp.com,
        robh+dt@kernel.org, mark.rutland@arm.com, andrew@lunn.ch,
        f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/3] net: phy: add interface mode
 PHY_INTERFACE_MODE_USXGMII
From:   David Miller <davem@davemloft.net>
In-Reply-To: <9d284f4d-93ee-fb27-e386-80825f92adc8@gmail.com>
References: <9d284f4d-93ee-fb27-e386-80825f92adc8@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 May 2019 13:39:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Thu, 23 May 2019 20:06:10 +0200

> Add support for interface mode USXGMII.
> 
> On Freescale boards LS1043A and LS1046A a warning may pop up now
> because mode xgmii should be changed to usxgmii (as the used
> Aquantia PHY doesn't support XGMII).

Series applied.
