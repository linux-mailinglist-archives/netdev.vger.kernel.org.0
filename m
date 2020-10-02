Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3783281C3C
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 21:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388431AbgJBTpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 15:45:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41058 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387768AbgJBTpy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 15:45:54 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kOQzw-00HJDQ-6y; Fri, 02 Oct 2020 21:45:44 +0200
Date:   Fri, 2 Oct 2020 21:45:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, jim.cromie@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2 0/4] AX88796C SPI Ethernet Adapter
Message-ID: <20201002194544.GH3996795@lunn.ch>
References: <CGME20201002192215eucas1p2c8f4a4bf8e411ed8ba75383fd58e85ac@eucas1p2.samsung.com>
 <20201002192210.19967-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201002192210.19967-1-l.stelmach@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 02, 2020 at 09:22:06PM +0200, Łukasz Stelmach wrote:
> This is a driver for AX88796C Ethernet Adapter connected in SPI mode as
> found on ARTIK5 evaluation board. The driver has been ported from a
> v3.10.9 vendor kernel for ARTIK5 board.

Hi Łukasz

Please include a brief list of changes since the previous version.

       Andrew
