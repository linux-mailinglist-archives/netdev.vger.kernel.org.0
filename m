Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0650B1B4CCD
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 20:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgDVSnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 14:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbgDVSnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 14:43:47 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B629C03C1A9;
        Wed, 22 Apr 2020 11:43:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7D3ED120ED563;
        Wed, 22 Apr 2020 11:43:46 -0700 (PDT)
Date:   Wed, 22 Apr 2020 11:43:45 -0700 (PDT)
Message-Id: <20200422.114345.1554399485217894854.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/3] dt-bindings: net: mdio.yaml fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200420180723.27936-1-f.fainelli@gmail.com>
References: <20200420180723.27936-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Apr 2020 11:43:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Mon, 20 Apr 2020 11:07:20 -0700

> This patch series documents some common MDIO devices properties such as
> resets (and delays) and broken-turn-around. The second patch also
> rephrases some descriptions to be more general towards MDIO devices and
> not specific towards Ethernet PHYs.
> 
> Changes in v3:
> 
> - corrected wording of 'broken-turn-around' in ethernet-phy.yaml and
>   mdio.yaml, add Andrew's R-b tag to patch #3

Series applied, thanks Florian.
