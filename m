Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3711449ADC
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 18:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240741AbhKHRkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 12:40:06 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51102 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240611AbhKHRkF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 12:40:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=I16W4tV7Z3BXv4EoVtNowix1nDv2eZoiNuOGWVOpLk8=; b=pdxjUu8vocfYIDlyRuTm61X+Vj
        UCLYjfJq1r5zfQnz97jKq7u3iK+GIFf12e1CU/KvoVDGEWT97sjOpcnxoStSdKKDg9+zLkbD2MgQn
        946Vew2kcTpI5uvW4Ia6Juh+Dx3HS0OTP7Vq6nTTJo/LXoSPj28YWhpRySIrdWEUDTVE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mk8a2-00Cuxt-OM; Mon, 08 Nov 2021 18:37:14 +0100
Date:   Mon, 8 Nov 2021 18:37:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [RFC PATCH v2 1/5] leds: trigger: add API for HW offloading of
 triggers
Message-ID: <YYlgSpK5kwvW5PV2@lunn.ch>
References: <20211108002500.19115-1-ansuelsmth@gmail.com>
 <20211108002500.19115-2-ansuelsmth@gmail.com>
 <YYkuZwQi66slgfTZ@lunn.ch>
 <YYk/Pbm9ZZ/Ikckg@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYk/Pbm9ZZ/Ikckg@Ansuel-xps.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> So we have PHYs that can only work in offload or off. Correct?

No, they can only work in offload. There is no off. You just get to
chose different offload settings.

      Andrew
