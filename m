Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB3D35787D
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 01:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbhDGX0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 19:26:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39336 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229459AbhDGX0g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 19:26:36 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lUHYw-00FP6O-Sy; Thu, 08 Apr 2021 01:26:18 +0200
Date:   Thu, 8 Apr 2021 01:26:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH RFC net 1/2] net: dsa: lantiq_gswip: Don't use PHY auto
 polling
Message-ID: <YG4/mo4njuV7Bv5Z@lunn.ch>
References: <20210406203508.476122-1-martin.blumenstingl@googlemail.com>
 <20210406203508.476122-2-martin.blumenstingl@googlemail.com>
 <YGz8FRBsj68xIbX/@lunn.ch>
 <CAFBinCD-jEUbyuuV=SLER8O1+PwhmiqHXFMaEX=h5mca=SDLgg@mail.gmail.com>
 <YG4Lku8sgwokW0NH@lunn.ch>
 <CAFBinCBE7BtEvDF044BeONCfCAaJOTYNkTTkhTJidaM97BQmYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFBinCBE7BtEvDF044BeONCfCAaJOTYNkTTkhTJidaM97BQmYQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If dropping the modifications to gswip_phylink_mac_config is my only change:
> do you want me to keep or drop your Reviewed-by in v2?

You can keep it.

    Andrew
