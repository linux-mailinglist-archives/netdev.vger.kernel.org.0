Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1979354822
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 23:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235463AbhDEVZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 17:25:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34738 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232853AbhDEVZs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 17:25:48 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lTWij-00Ezaw-R6; Mon, 05 Apr 2021 23:25:17 +0200
Date:   Mon, 5 Apr 2021 23:25:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     kernel test robot <lkp@intel.com>
Cc:     Michael Walle <michael@walle.cc>, ath9k-devel@qca.qualcomm.com,
        UNGLinuxDriver@microchip.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-amlogic@lists.infradead.org, kbuild-all@lists.01.org
Subject: Re: [PATCH 1/2] of: net: pass the dst buffer to of_get_mac_address()
Message-ID: <YGuAPb1+AcFTOYdq@lunn.ch>
References: <20210405164643.21130-2-michael@walle.cc>
 <202104060306.lmTxeOmW-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202104060306.lmTxeOmW-lkp@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 03:19:11AM +0800, kernel test robot wrote:
> Hi Michael,
> 
> I love your patch! Yet something to improve:

Looks correct. You missed the #else case for #ifdef CONFIG_OF in
stmmac_platform.c

Lets see what else 0-day finds before i start reviewing.

      Andrew
