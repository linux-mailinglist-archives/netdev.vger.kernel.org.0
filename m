Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03F7A64C1B4
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 02:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237651AbiLNBR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 20:17:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236705AbiLNBRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 20:17:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB151A22B;
        Tue, 13 Dec 2022 17:17:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21EE36122E;
        Wed, 14 Dec 2022 01:17:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D117BC433EF;
        Wed, 14 Dec 2022 01:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670980642;
        bh=Qho4Ur9kLtiOlZ6VM+JZ+GHPKbL31M5XCDrCAVRNOsA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r/n1jshs+E49EDrjrSJgMY4Djrxh/eD48ZTNhtKJYx+shBibbdg1xwy/1YHHz6inn
         budV7FINzMovmERaZI6yL8pjAJ/gn8DXid22LfWyrka6spkE0jd0AfInhXuOoVkaLF
         f/jgCWBwftx04aqWy9FXxg3mqU9crCJ0lPAGc7y/AnX2IerTI0EWd4AdbjSag6aMh0
         LZIxxrIYvat1yE/FEuFDG1+M7ndZxVpYh/XQn7CdSG9k1j+2klGBGy/Ad8McoYJsyO
         uNVY4LYwE9MGdaE04AdPwRBoHsIt6IFVF7mwZ0kK5UWlKGNkZCvpPk5eONtt5xT9q4
         bUqveBRm79mdQ==
Date:   Tue, 13 Dec 2022 17:17:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: Re: [PATCH net-next] net: dsa: mt7530: remove reduntant assignment
Message-ID: <20221213171720.3af6fc05@kernel.org>
In-Reply-To: <Y5f6h8q7rlnk1jnD@makrotopia.org>
References: <Y5b/Tm4GwPGzd9sR@shell.armlinux.org.uk>
        <Y5f6h8q7rlnk1jnD@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Dec 2022 04:07:35 +0000 Daniel Golle wrote:
> Fixes: e19de30d20 ("net: dsa: mt7530: add support for in-band link status")

Apart from the changes requested by Russell, could you also correct
this Fixes tag to have the required 12 characters of the commit ID?

You can post as [PATCH net v2], net-next has just made it to Linus
and became net.
