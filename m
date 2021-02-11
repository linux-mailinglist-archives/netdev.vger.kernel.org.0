Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13D63182B2
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 01:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhBKAos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 19:44:48 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33924 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229575AbhBKAos (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 19:44:48 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lA05Q-005R5u-3k; Thu, 11 Feb 2021 01:44:00 +0100
Date:   Thu, 11 Feb 2021 01:44:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Masahiro Yamada <masahiroy@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH V4 net-next 2/2] net: broadcom: bcm4908_enet: add BCM4908
 controller driver
Message-ID: <YCR90GhMgNTXbKOd@lunn.ch>
References: <20210209230130.4690-2-zajec5@gmail.com>
 <20210210094702.24348-1-zajec5@gmail.com>
 <20210210094702.24348-2-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210210094702.24348-2-zajec5@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 10:47:02AM +0100, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> BCM4908 SoCs family has integrated Ethernel controller that includes
> UniMAC but uses different DMA engine (than other controllers) and
> requires different programming.
> 
> Ethernet controller in BCM4908 is always connected to the internal SF2
> switch's port and uses fixed link.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
