Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850C729142D
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 21:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439610AbgJQTtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 15:49:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32782 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439606AbgJQTtI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 15:49:08 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kTsCO-002Bby-9o; Sat, 17 Oct 2020 21:49:04 +0200
Date:   Sat, 17 Oct 2020 21:49:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Masahisa Kojima <masahisa.kojima@linaro.org>
Subject: Re: realtek PHY commit bbc4d71d63549 causes regression
Message-ID: <20201017194904.GP456889@lunn.ch>
References: <20201017144430.GI456889@lunn.ch>
 <CAMj1kXHsNrRSkZfSJ_VatES+V1obLcvfo=Qab_4jy58Znpjy6Q@mail.gmail.com>
 <20201017151132.GK456889@lunn.ch>
 <CAMj1kXH+Z56dkZz8OYMhPuqbjPPCqW=UMV6w--=XXh87UyHVaQ@mail.gmail.com>
 <20201017161435.GA1768480@apalos.home>
 <CAMj1kXHXYprdC19m1S5p_LQ2BOHtDCbyCWCJ0eJ5xPxFv8hgoA@mail.gmail.com>
 <20201017180453.GM456889@lunn.ch>
 <CAMj1kXEcrULejk+h1Jv42W=r7odQ9Z_G0XDX_KrEnYYPEVgHkA@mail.gmail.com>
 <20201017182738.GN456889@lunn.ch>
 <CAMj1kXHwYkd0L63K3+e_iwfoSYEUOmYdWf_cKv90_qVXSxEesg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHwYkd0L63K3+e_iwfoSYEUOmYdWf_cKv90_qVXSxEesg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> So we can fix this firmware by just setting phy-mode to the empty
> string, right?

I've never actually tried it, but i think so. There are no DT files
actually doing that, so you really do need to test it and see. And
there might be some differences between device_get_phy_mode() and
of_get_phy_mode().

	Andrew
