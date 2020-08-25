Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60BBD251EC9
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 20:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgHYSD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 14:03:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50846 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbgHYSD2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 14:03:28 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kAdI4-00BoEm-6D; Tue, 25 Aug 2020 20:03:24 +0200
Date:   Tue, 25 Aug 2020 20:03:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com
Subject: Re: [PATCH 2/3] ARM: dts: Add ethernet
Message-ID: <20200825180324.GO2403519@lunn.ch>
References: <20200825170311.24886-1-l.stelmach@samsung.com>
 <CGME20200825170323eucas1p2d299a6ac365e6a70d802757d439bc77c@eucas1p2.samsung.com>
 <20200825170311.24886-2-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200825170311.24886-2-l.stelmach@samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 07:03:10PM +0200, Łukasz Stelmach wrote:
> Add node for ax88796c ethernet chip.

Hi Łukasz

You need to document the device tree binding.

    Andrew
