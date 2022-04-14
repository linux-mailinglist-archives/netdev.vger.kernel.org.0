Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B9C500BBF
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 13:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242293AbiDNLFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 07:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242099AbiDNLFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 07:05:32 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327B75DE5A;
        Thu, 14 Apr 2022 04:03:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A4DE5CE2957;
        Thu, 14 Apr 2022 11:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B51C385A5;
        Thu, 14 Apr 2022 11:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649934184;
        bh=18Q/itAirA+kzeuhe2m6kPqg09KM+ob1KjY/V/Lx0mY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wjcdcw3DoDLvR/HawB5I+GNuZHc5vBuDcNxij5Z2gyegwob8LschsdaSa3/DEJAa/
         DmO4yEY4kcUvp/bVJu523rcVvp7BBBf1SqrrQetptbIbtCCZP7b20GL67JUBwW6ouo
         cyc09V98qlybaJ5M76jZ8UirUw3rfrZW4vhT1SIM=
Date:   Thu, 14 Apr 2022 13:03:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Rasmussen <mir@bang-olufsen.dk>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH stable 5.16+ 0/3] backported Realtek DSA driver fixes for
 5.16 and 5.17
Message-ID: <Ylf/Zl9QL2M2+LYd@kroah.com>
References: <20220412173253.2247196-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220412173253.2247196-1-alvin@pqrs.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 12, 2022 at 07:32:49PM +0200, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> These fixes can be applied to both 5.16 and 5.17 - the subtree of
> drivers/net/dsa/realtek is identical save for a few unrelated places.
> 
> The main backporting effort was to remove some parts of the patches
> which touched the newly introduced MDIO interface, which was introduced
> in the 5.18 development cycle, and to work around a mass-rename of a
> single variable (smi -> priv). Regrettably this rename will make future
> stable backports equally tedious and hard to automate.
> 
> Please let me know if you would like me to send the series again for
> 5.17.

5.16 is now end-of-life, but I've queued these up for 5.17 now, thanks!

greg k-h
