Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A89C291362
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 20:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438731AbgJQSBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 14:01:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60902 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438727AbgJQSBk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 14:01:40 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kTqWL-002AyG-Q3; Sat, 17 Oct 2020 20:01:33 +0200
Date:   Sat, 17 Oct 2020 20:01:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Masahisa Kojima <masahisa.kojima@linaro.org>
Subject: Re: realtek PHY commit bbc4d71d63549 causes regression
Message-ID: <20201017180133.GL456889@lunn.ch>
References: <CAMj1kXEEF_Un-4NTaD5iUN0NoZYaJQn-rPediX0S6oRiuVuW-A@mail.gmail.com>
 <20201017144430.GI456889@lunn.ch>
 <CAMj1kXHsNrRSkZfSJ_VatES+V1obLcvfo=Qab_4jy58Znpjy6Q@mail.gmail.com>
 <20201017151132.GK456889@lunn.ch>
 <CAMj1kXH+Z56dkZz8OYMhPuqbjPPCqW=UMV6w--=XXh87UyHVaQ@mail.gmail.com>
 <20201017161435.GA1768480@apalos.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201017161435.GA1768480@apalos.home>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Would EDK2 take care of the RGMII Rx/Tx delays even when configured to 
> use a DT instead of ACPI?

But what about those users using u-boot and DT, not EDK2?

    Andrew
