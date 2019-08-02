Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 818437FE88
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 18:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391044AbfHBQWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 12:22:20 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:46412 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389867AbfHBQWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 12:22:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=JiPRz1b1DB02obaqCC3z20a5XEDkM8AtFJgDiFd1iVo=; b=AIBv+30IiFOPBIKyKY90cKN7C
        c7RI1W+PPUsBiM7EcXVDttqHmkSyweMEcecPRoVFyAqtHoFbazefx7dgXUo4qTjtWbKsJ9f6C6EFB
        0iv6ei++jHrxflsJto44ZAzCS2R3R1furjP8FvzjMaZLnrad4n62SQbhYm27XgHh9TjWCdbRdOIv4
        J0D25W2MWjxZoh+7WyYdRLk6qTedaW1x179xjzSBr9fl0TdbMdK4qGBymCrGIQe4Rrdy9CxFDJ726
        kUcO2YdaGL7m8LRrHaAoaOcdRqT4p+00MCj3hv205btJQxYRZzguwA6qUET1DWdjlq2q6hyxUgL+I
        JzZTQ0GuA==;
Received: from static-50-53-52-16.bvtn.or.frontiernet.net ([50.53.52.16] helo=[192.168.1.17])
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1htaJu-00047k-7l; Fri, 02 Aug 2019 16:22:18 +0000
Subject: Re: linux-next: Tree for Aug 2 (staging/octeon/)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Matthew Wilcox <willy@infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>
References: <20190802155223.41b0be6e@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <9f6374e6-2175-0e0c-6be3-a2aca53bd865@infradead.org>
Date:   Fri, 2 Aug 2019 09:22:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190802155223.41b0be6e@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/1/19 10:52 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20190801:
> 

on x86_64:
when CONFIG_OF is not set/enabled.


WARNING: unmet direct dependencies detected for MDIO_OCTEON
  Depends on [n]: NETDEVICES [=y] && MDIO_DEVICE [=y] && MDIO_BUS [=y] && 64BIT [=y] && HAS_IOMEM [=y] && OF_MDIO [=n]
  Selected by [y]:
  - OCTEON_ETHERNET [=y] && STAGING [=y] && (CAVIUM_OCTEON_SOC || COMPILE_TEST [=y]) && NETDEVICES [=y]

ld: drivers/net/phy/mdio-octeon.o: in function `octeon_mdiobus_probe':
mdio-octeon.c:(.text+0x31c): undefined reference to `cavium_mdiobus_read'
ld: mdio-octeon.c:(.text+0x35a): undefined reference to `cavium_mdiobus_write'


OCTEON_ETHERNET should not select MDIO_OCTEON when OF_MDIO is not set/enabled.


-- 
~Randy
