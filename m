Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52EE863AA17
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 14:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbiK1NwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 08:52:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbiK1NwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 08:52:16 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 742A41FA;
        Mon, 28 Nov 2022 05:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=SjoNT10Qv8JOdsg/OOKFDpuB8vaH46PjVcMypqrbfy8=; b=Qj
        MU3r4UKiyzXncJUhj2hUcnfuhC9E1vspiClJMPHECS4esLR1/iW10qhHSTmWJBNqvVpqPm00VnwGo
        K2YZG16j1GG9TFOnsW26zHDLzUrHoKevkS1i0TRMfw1//rJ3GGSE+gHEz+cNjbaiSqRI2YS0GFz8k
        DJ1xrjqF2qi6Rk0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ozeXz-003erh-Jf; Mon, 28 Nov 2022 14:51:47 +0100
Date:   Mon, 28 Nov 2022 14:51:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
Subject: Re: [PATCH v1 00/26] net: dsa: microchip: stats64, fdb, error
Message-ID: <Y4S88w7BNWuWQLdh@lunn.ch>
References: <20221128115958.4049431-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221128115958.4049431-1-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 12:59:32PM +0100, Oleksij Rempel wrote:
> This patch series is a result of maintaining work on ksz8 part of
> microchip driver. It includes stats64 and fdb support. Error handling.
> Loopback fix and so on...
> 
> Oleksij Rempel (26):

The netdev FAQ says:

* don’t post large series (> 15 patches), break them up

This seems like something which could easily be broken up.

     Andrew
