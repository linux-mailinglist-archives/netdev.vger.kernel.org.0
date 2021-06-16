Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F5B3A9B7B
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 15:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbhFPNId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 09:08:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40388 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232389AbhFPNIc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 09:08:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=7qPpfPmf10mQ7tyhqTFM0L4iBOExsVEFUzZo18liJj4=; b=z80RntKX7Rw/ZbPeLSo67NewTx
        NWFQwUH8cOn4WgsaqyR274ZZNinnpqbZZML1VDys2L9aqu6WU+E5/Frvntpio7ew74iLUPaGiGjtV
        JapC/0NNkpsg2xKHFmIzpAyWxwXgekNoI8e5CiY6yY8kXtVKIEAWX1uV4RmXnuI3drmM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ltVFJ-009jB2-Jt; Wed, 16 Jun 2021 15:06:17 +0200
Date:   Wed, 16 Jun 2021 15:06:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     David Miller <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "frieder.schrempf@kontron.de" <frieder.schrempf@kontron.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 net-next 0/2] net: fec: fix TX bandwidth fluctuations
Message-ID: <YMn3Sd65rzvKasEb@lunn.ch>
References: <20210611095005.3909-1-qiangqing.zhang@nxp.com>
 <20210611.132514.1451796354248475314.davem@davemloft.net>
 <DB8PR04MB679518CF771FEBE118E395A3E6309@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YMicuzWwAKz5ffWB@lunn.ch>
 <DB8PR04MB6795A2A1D51D95E996B7B75FE60F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB6795A2A1D51D95E996B7B75FE60F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I try below build options, also can't reproduce this issue, so really don't know how to fix it.
> 
> make ARCH=arm64 distclean
> make ARCH=arm64 allmodconfig
> make -j8 ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- W=1 / make -j8 ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- W=2 / make -j8 ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- W=3
> 
> I saw many unrelated warnings...

Then it could be sparse. Install sparse and use C=1.

     Andrew
