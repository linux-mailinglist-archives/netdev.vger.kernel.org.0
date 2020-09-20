Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80D227166A
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 19:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgITRo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 13:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgITRo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 13:44:59 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301A7C061755
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 10:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=o41vk8UBodzY4mC7DT2WzBu5AOSf35wXlVes3Lq78+E=; b=IH03ND6s0p8wFYG5/y2lVeZ2v9
        PmkWq+okqHT0AaEldSMwkAIAw4TDBZ1AQ/mCWeQ2+jJwFUHb2sHl+A8VqYTM6xLlz8dmcHjUSJh/G
        IQ4mxRuZEW1iHnUmPeLel5P0Up8DqITVpylQASFSSKXF+7V07TgykfPQ3tFTJMViiDZhWlOdba70H
        ciS/XzxumEOTYXPKiRVYlUJ5ezIOtNoNs1kkefflh9okRn8Gk1iG1vHpPGBtR00Kf4yP/SowZdfNc
        SeCtEx4Ip+uS46U+BRvi6xZZo9d/TwTceyk+CCNb9Bq91UkwgjRjgomn4/EEQTxPkRZjVESLqDifc
        bymiBHSQ==;
Received: from [2601:1c0:6280:3f0::19c2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kK3OR-0007pB-1R; Sun, 20 Sep 2020 17:44:55 +0000
Subject: Re: [PATCH net-next 0/5] PHY subsystem kernel doc
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20200920171703.3692328-1-andrew@lunn.ch>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <e1d2c08a-52c3-c463-75c7-b732a8666a3a@infradead.org>
Date:   Sun, 20 Sep 2020 10:44:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200920171703.3692328-1-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/20/20 10:16 AM, Andrew Lunn wrote:
> The first two patches just fixed warnings seen while trying to work on
> PHY documentation.
> 
> The following patches then first fix existing warnings in the
> kerneldoc for the PHY subsystem, and then extend the kernel
> documentation for the major structures and functions in the PHY
> subsystem.
> 
> Andrew Lunn (5):
>   net: netdevice.h: Document proto_down_reason
>   net: netdevice.h: Document xdp_state
>   net: phy: Fixup kernel doc
>   net: phy: Document core PHY structures
>   net: mdio: Add kerneldoc for main data structures and some functions
> 
>  Documentation/networking/kapi.rst |  24 ++
>  drivers/net/phy/mdio_bus.c        |  37 +++
>  drivers/net/phy/mdio_device.c     |  21 ++
>  drivers/net/phy/phy-core.c        |  30 +++
>  drivers/net/phy/phy.c             |  69 ++++-
>  include/linux/mdio.h              |  91 ++++++-
>  include/linux/netdevice.h         |   3 +
>  include/linux/phy.h               | 414 +++++++++++++++++++++---------
>  8 files changed, 554 insertions(+), 135 deletions(-)

Note: Jakub has already merged my fixes for your patches 1 & 2...


The series LGTM.  Thanks.

series:
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>


-- 
~Randy
