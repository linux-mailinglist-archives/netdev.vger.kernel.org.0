Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2BB2BA8ED
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 12:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgKTLWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 06:22:44 -0500
Received: from mailout09.rmx.de ([94.199.88.74]:41691 "EHLO mailout09.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727197AbgKTLWo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 06:22:44 -0500
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout09.rmx.de (Postfix) with ESMTPS id 4CcvKQ4dDfzbd1H;
        Fri, 20 Nov 2020 12:22:34 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CcvK35Hd5z2TTHp;
        Fri, 20 Nov 2020 12:22:15 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.143) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Fri, 20 Nov
 2020 12:21:28 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <robh+dt@kernel.org>
CC:     Richard Cochran <richardcochran@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Kurt Kanzenbach" <kurt.kanzenbach@linutronix.de>,
        Marek Vasut <marex@denx.de>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "Christian Eggers" <ceggers@arri.de>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 0/4] dt-bindings: net: dsa: microchip: convert KSZ bindings to yaml
Date:   Fri, 20 Nov 2020 12:21:03 +0100
Message-ID: <20201120112107.16334-1-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.143]
X-RMX-ID: 20201120-122219-4CcvK35Hd5z2TTHp-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches are orginally from the series

"net: dsa: microchip: PTP support for KSZ956x"

As the the device tree conversion to yaml is not really related to the
PTP patches and the original series is going to take more time than
I expected, I would like to split this.

Changes (original series -> v1)
--------------------------------
- dts: moved "allOf" below "maintainers"
- dts: use "unevaluatedProperties" instead of "additionalProperties"
- dts: removed "spi-cpha" and "spi-cpol" flags as the hardware is fixed
- ksz8795: setup SPI for mode 3
- ksz9477: dito



