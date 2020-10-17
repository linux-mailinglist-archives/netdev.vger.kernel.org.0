Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A27291284
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 16:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438403AbgJQOoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 10:44:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60792 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438399AbgJQOoh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 10:44:37 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kTnRf-0029rJ-0S; Sat, 17 Oct 2020 16:44:31 +0200
Date:   Sat, 17 Oct 2020 16:44:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Masahisa Kojima <masahisa.kojima@linaro.org>
Subject: Re: realtek PHY commit bbc4d71d63549 causes regression
Message-ID: <20201017144430.GI456889@lunn.ch>
References: <CAMj1kXEEF_Un-4NTaD5iUN0NoZYaJQn-rPediX0S6oRiuVuW-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXEEF_Un-4NTaD5iUN0NoZYaJQn-rPediX0S6oRiuVuW-A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 17, 2020 at 04:20:36PM +0200, Ard Biesheuvel wrote:
> Hello all,
> 
> I just upgraded my arm64 SynQuacer box to 5.8.16 and lost all network
> connectivity.

Hi Ard

Please could you point me at the DT files.

> This box has a on-SoC socionext 'netsec' network controller wired to
> a Realtek 80211e PHY, and this was working without problems until
> the following commit was merged

It could be this fix has uncovered a bug in the DT file. Before this
fix, if there is an phy-mode property in DT, it could of been ignored.
Now the phy-handle property is correctly implemented. So it could be
the DT has the wrong value, e.g. it has rgmii-rxid when maybe it
should have rgmii-id.

       Andrew
