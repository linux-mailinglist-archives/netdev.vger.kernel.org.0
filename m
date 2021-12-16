Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6A9476EB1
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 11:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235816AbhLPKRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 05:17:18 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58192 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233295AbhLPKRS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 05:17:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=7cHF8EBj6oBLX8y97sB0qh1FWn7nTv1Irfge/igfui8=; b=L1
        s1mrRZvZ20IJrPqZ7NNGQeOqvYooxPKqMf8JmH77VrbdOfa+bJQuMY1dD2/3E9bQ4KiNZALksBbJS
        WqvzNj4UC1rDRysT83PooVCUqUv6D7XegaG7PCDBTIoxR00Pmes4XzaYCHStSioljToHJxR4T8GLd
        hnr6pDllL5UUH/c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mxnor-00GjDg-EJ; Thu, 16 Dec 2021 11:17:01 +0100
Date:   Thu, 16 Dec 2021 11:17:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     KARL_TSOU =?utf-8?B?KOmEkuejiik=?= <KARL_TSOU@ubiqconn.com>
Cc:     "woojung.huh@microchip.com" <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: dsa: microchip: Add supported ksz9897 port6
Message-ID: <YbsSHSmxrZZ4jhvD@lunn.ch>
References: <HK2PR03MB43070C126204965988B2299DE0779@HK2PR03MB4307.apcprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <HK2PR03MB43070C126204965988B2299DE0779@HK2PR03MB4307.apcprd03.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 09:24:13AM +0000, KARL_TSOU (鄒磊) wrote:
> This fix driver ksz9897 port6 with PHY ksz8081 by hardware setup

Please explain in more details what the problem is you are fixing. It
is not clear from the code.

   Thanks
	Andrew
