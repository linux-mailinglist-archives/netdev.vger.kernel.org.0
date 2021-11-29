Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31D44610BE
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 10:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242852AbhK2JFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 04:05:20 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:1070 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240879AbhK2JDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 04:03:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1638176392; x=1669712392;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JGQEhKZEDXqkd/Ogc1/RxwdisJVEHm2gXp5mT/zaQPc=;
  b=HVRimucFvjSQ6tx/v25ISE+csZyDBZwrAhJN+PhW4MYInpra/fqplwRo
   /seCO3UioOShfweq71Zt3lp+CKXdJ6ESkg2+21ONuHDMih5yajRqn7og5
   jrEP+a/31jz/di3ac7SYmN/Aa+wINHbptoU+MpDaREA+/vxEiYTlO/Jyk
   f5NkQiUjFRu2fZhAdHoPCcY93tEAhcE9cllleGhNWJHopzgJ+YSekdD2s
   7u5gX/bg8vzK4kMOArAd+6QJjQNt0rPeOtuiRlfu3iYcAykCTMLZEkis6
   6fUp0PsWNqaUHBwjPWEoYpqk7xEuj4N2RAh8KezfWiEVKgZet/wDTVxrq
   A==;
IronPort-SDR: tqQaOY0u+rztD/YLqcNp5EjmW/UKTJpTUxezEn3FqL8lW8PwjpxDeIe/yIyYIPrLfOR1qR7l7V
 SQ96iYZa/EoHOJDm3gHXOqofvQtLSsln2ZLfjxnpjtGAPAqAnKEFPeIifsrYznDiz1+cSSRIsD
 FgQBOqC1JeFdVXrraN97NzhZ2fyZQp5t8Gnkk61YRkP6wcJUkVltgTQhctfCuOMy3SA1Ga7LVt
 3/T+Q+OilsHfqoVPIX7NcLfMiMepDI06uQlUyxAgvcpPlmzK8d9GPV8FybrXVz918wSVmM6ndJ
 aefmsdvZLCJ5z1C1azbXUpN/
X-IronPort-AV: E=Sophos;i="5.87,272,1631602800"; 
   d="scan'208";a="140550577"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Nov 2021 01:59:51 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 29 Nov 2021 01:59:51 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Mon, 29 Nov 2021 01:59:51 -0700
Date:   Mon, 29 Nov 2021 10:01:47 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: micrel: Add config_init for LAN8814
Message-ID: <20211129090147.7fjvop2g6zkbre6s@soft-dev3-1.localhost>
References: <20211126103833.3609945-1-horatiu.vultur@microchip.com>
 <YaD6Iita1y6m1Zya@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <YaD6Iita1y6m1Zya@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/26/2021 16:15, Andrew Lunn wrote:

Hi Andrew,

> 
> > - swap the MDI-X A,B transmit so that there will not be any link flip-flaps
> >   when the PHY gets a link.
> 
> Isn't this a board issue, rather than generic? Or does the datasheet
> have the pins labelled wrongly and all boards following the datasheet
> are wrong?

From my understanding it is not a board issue. This is needed in case
the link partners can't do the A/B swapping based on MDI/MDIX. It would
not harm if this is set also for link partners that can do this.

> 
>         Andrew

-- 
/Horatiu
