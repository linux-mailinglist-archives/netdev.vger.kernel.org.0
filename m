Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7DE65528B4
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 02:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242643AbiFUAsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 20:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244974AbiFUAsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 20:48:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC27B5F8D
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 17:48:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67619B81647
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 00:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9042AC3411B;
        Tue, 21 Jun 2022 00:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655772482;
        bh=ZWdcxb7ffmmSLKr0H+JOXXW+5JLpQp3l6aZ4hxdtHVg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sOR6dHje+YED5L4KHjyrYYvc+cq39+SZc4tNcz4ZyKjNMYavWvkVdEod4ApJlxpS4
         I7kBmvMU/zAPsZF/7CTQpxNygwSy1iAwY5FbFkdludTxluHZtpM+m6SBGHGQo6RKe6
         ca7CXJVUNez4TeA/OQBXpSQ7yNqS7NUJuYy8+RIOVsyn3A5Wz/alRPwEBMoDTHTVHP
         GE9C+LN42JyuC/zLOtcCBY/qrkGN6qqGlYp+2r8msVUXYR2IX/raBDvFKzM6BSGDge
         82xpkdydIS0awKlNpz7JoqgpwuI5nCgVmjzKmkp3D1Xw5oo1aBAIo36CFpJ4273wgP
         K36wkSEGxUD+Q==
Date:   Mon, 20 Jun 2022 17:48:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     kernel test robot <lkp@intel.com>
Cc:     davem@davemloft.net, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        boon.leong.ong@intel.com, rmk+kernel@armlinux.org.uk
Subject: Re: [PATCH net-next] net: pcs: xpcs: select PHYLINK in Kconfig
Message-ID: <20220620174800.6dc60a5b@kernel.org>
In-Reply-To: <202206210551.Fhz4xcTc-lkp@intel.com>
References: <20220620201915.1195280-1-kuba@kernel.org>
        <202206210551.Fhz4xcTc-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jun 2022 05:49:57 +0800 kernel test robot wrote:
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on net-next/master]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Jakub-Kicinski/net-pcs-xpcs-select-PHYLINK-in-Kconfig/20220621-042123
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git dbca1596bbb08318f5e3b3b99f8ca0a0d3830a65
> config: i386-tinyconfig
> compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
> reproduce (this is a W=1 build):
>         # https://github.com/intel-lab-lkp/linux/commit/a3120516f7ee66896bb0d3c90fe653ce0cb3a09f
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Jakub-Kicinski/net-pcs-xpcs-select-PHYLINK-in-Kconfig/20220621-042123
>         git checkout a3120516f7ee66896bb0d3c90fe653ce0cb3a09f
>         make W=1 ARCH=i386  tinyconfig
>         make W=1 ARCH=i386 
> 
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
> >> drivers/net/phy/Kconfig:16:error: recursive dependency detected!  
>    drivers/net/phy/Kconfig:16: symbol PHYLIB is selected by PHYLINK
>    drivers/net/phy/Kconfig:6: symbol PHYLINK is selected by PCS_XPCS
>    drivers/net/pcs/Kconfig:8: symbol PCS_XPCS depends on MDIO_DEVICE
>    drivers/net/mdio/Kconfig:6: symbol MDIO_DEVICE is selected by PHYLIB
>    For a resolution refer to Documentation/kbuild/kconfig-language.rst
>    subsection "Kconfig recursive dependency limitations"

Dunno what the best practice is in that case :S
I'll leave this to the experts.
