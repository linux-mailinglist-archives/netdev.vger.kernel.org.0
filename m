Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4A06E9844
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 17:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbjDTP1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 11:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjDTP1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 11:27:14 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1048AE69;
        Thu, 20 Apr 2023 08:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ZIh7X3Hg0zgJSWfk7ukimasZ+fd2z71MtBN7Lri4xSI=; b=VKUEoirwxIGgWesEl68e5P1YPA
        YzSyskoU4nGativgYNuY7TG5ylFZOANFA1Mfh8wYbrAjlBxV/yQ0oB0j/+oN8tMSI8oGx5trjEGkb
        H0R7Bm3TicD96ul7Y5sQh48PkJLxh+h17Ci1XV6TdywGLfRt+zsIMRVxkaAKFaeALR/g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ppWBT-00Anmo-1W; Thu, 20 Apr 2023 17:26:55 +0200
Date:   Thu, 20 Apr 2023 17:26:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     kernel test robot <lkp@intel.com>, llvm@lists.linux.dev,
        oe-kbuild-all@lists.linux.dev,
        Christian Marangi <ansuelsmth@gmail.com>,
        Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [lunn:v6.3-rc2-net-next-phy-leds 5/15] ld.lld: error: undefined
 symbol: devm_mdiobus_alloc_size
Message-ID: <2e7f5511-08e2-4ee0-ab3f-481ba6724824@lunn.ch>
References: <202303241935.xRMa6mc6-lkp@intel.com>
 <f16fb810-f70d-40ac-8e9d-2ada008c446d@app.fastmail.com>
 <758fff85-aefc-4e0a-97b1-fe7179fafac6@lunn.ch>
 <91c716f0-bf7f-4fdf-8cb7-83f1bdc0cbd4@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91c716f0-bf7f-4fdf-8cb7-83f1bdc0cbd4@app.fastmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I think the best way is to drop your MDIO_DEVRES patch and instead
> apply mine (or some variation of that) from
> 
> https://lore.kernel.org/lkml/20230420084624.3005701-1-arnd@kernel.org/
> 
> Once any missing or recursive dependencies are handled, the devres
> problem should be fixed as well. I have completed around 150
> randconfig builds with that patch and have not seen any further
> problems.

Hi Arnd

Is this on top of my patch? Or does it require mine is reverted?  I
can send a revert if it is needed.

   Andrew
