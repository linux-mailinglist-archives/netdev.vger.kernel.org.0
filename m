Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D56B0209731
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 01:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388527AbgFXXeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 19:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388094AbgFXXen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 19:34:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63536C061573;
        Wed, 24 Jun 2020 16:34:43 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1DA8212778941;
        Wed, 24 Jun 2020 16:34:40 -0700 (PDT)
Date:   Wed, 24 Jun 2020 16:34:37 -0700 (PDT)
Message-Id: <20200624.163437.878978558101234300.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     Jisheng.Zhang@synaptics.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] net: phy: call phy_disable_interrupts() in
 phy_init_hw()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <7a71ba71-b6cf-653d-967d-b74f930a69c5@gmail.com>
References: <20200624112516.7fcd6677@xhacker.debian>
        <20200624.144309.110827193136110443.davem@davemloft.net>
        <7a71ba71-b6cf-653d-967d-b74f930a69c5@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jun 2020 16:34:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Wed, 24 Jun 2020 15:10:51 -0700

> Did you mean that you applied v4? It does not look like you pushed your
> local changes to net-next yet, so I cannot tell for sure.

I ended up applying v4, yes.
