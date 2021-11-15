Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CA4450646
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 15:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbhKOOK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 09:10:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:60558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231765AbhKOOK5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 09:10:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EA4B61B3A;
        Mon, 15 Nov 2021 14:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636985282;
        bh=DXGnhAXzvOOvEwPqwyXzIxg7taPUAJGCb974M+y4pxo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rB5wMSEyUy15G5o4on0W1JekMZjfYViDT+z/Rr5Ai0pD44f3FAhU+c/fl+np2rcts
         s3wVLuEjcsB/J4jAFgbbaReJWAbzWsOonLFLtIoywF42BbejYPTZ7RAQi1zgoZ2FmI
         qBKaa29ydXf0mTj/diTLbOGs6bK8oNjJS9gEOHrKiHbP6YvdonDD2E8tCmxZHbbR2u
         DqLpkY9l7RWighwFnonF40INjg5TlU78M3NjToAt9tMJwHxgKaA0QNLlwa2cvC63qt
         7InEiFuMXncLH+pnvZzPoANn3qnZmY8rkEMo1xYyao1xAsE3Xi0Wqlwc9G2nLVChsE
         M0M00Q1KI6uVw==
Date:   Mon, 15 Nov 2021 06:08:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH v2 3/6] net: ocelot: pre-compute injection frame header
 content
Message-ID: <20211115060800.44493c2f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211115111344.03376026@fixe.home>
References: <20211103091943.3878621-1-clement.leger@bootlin.com>
        <20211103091943.3878621-4-clement.leger@bootlin.com>
        <20211103123811.im5ua7kirogoltm7@skbuf>
        <20211103145351.793538c3@fixe.home>
        <20211115111344.03376026@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Nov 2021 11:13:44 +0100 Cl=C3=A9ment L=C3=A9ger wrote:
> Test on standard packets with UDP (iperf3 -t 100 -l 1460 -u -b 0 -c *)
> - With pre-computed header: UDP TX: 	33Mbit/s
> - Without UDP TX: 			31Mbit/s
> -> 6.5% improvement =20
>=20
> Test on small packets with UDP (iperf3 -t 100 -l 700 -u -b 0 -c *)
> - With pre-computed header: UDP TX: 	15.8Mbit/s
> - Without UDP TX: 			16.4Mbit/s
> -> 4.3% improvement =20

Something's wrong with these numbers or I'm missing context.
You say improvement in both cases yet in the latter case the=20
new number is lower?
