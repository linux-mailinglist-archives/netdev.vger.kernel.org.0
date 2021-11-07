Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A202447631
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 23:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235876AbhKGWJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 17:09:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:37756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235687AbhKGWJO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Nov 2021 17:09:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 323666056B;
        Sun,  7 Nov 2021 22:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636322790;
        bh=toI6HLlxwBPJ5YPKt3v20fsa6jRRPdPSmuMIZD208hs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Nre9H+8pGNFdOGG0uQxbXTanDSfBtfCUCT8iXIoMeRhHTHlRZWnBGAlpdE3S2+0E2
         /9t4B8MLVV2Defde7KvNb3Iyg10lBenk2MlIIZxOauBfpv73Kd1L/5kpo0izMf7FSc
         ZN7+vRLRaI/YSQ/zqcYOM2weeY6ofbDfaQUJrVIGxZZml6woT2djYsXNQpb2kjYzWc
         m4zcZSeHvC+tsojPfXBc8eCPNguo1Re6Az+HNkwqmfBh3nL4zxGss0zoQTU4nUfP1T
         Y5LQABiFLI5YQYmIUwwc+gZKb2FHZKEP7QUBwKJLEJf16FEOPIHcPGF+mC9MblRLQu
         srhmsugpzuQHQ==
Date:   Sun, 7 Nov 2021 23:06:24 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH 2/6] leds: permit to declare supported offload
 triggers
Message-ID: <20211107230624.5251eccb@thinkpad>
In-Reply-To: <20211107175718.9151-3-ansuelsmth@gmail.com>
References: <20211107175718.9151-1-ansuelsmth@gmail.com>
        <20211107175718.9151-3-ansuelsmth@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  7 Nov 2021 18:57:14 +0100
Ansuel Smith <ansuelsmth@gmail.com> wrote:

> With LEDs that can be offload driven, permit to declare supported triggers
> in the dts and add them to the cled struct to be used by the related
> offload trigger. This is particurally useful for phy that have support
> for HW blinking on tx/rx traffic or based on the speed link.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

NAK. The device-tree shouldn't define this, only the LED's function as
designated by the manufacturer of the device.

Marek
