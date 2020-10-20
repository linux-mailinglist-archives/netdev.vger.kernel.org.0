Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E16293C2F
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 14:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406663AbgJTMtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 08:49:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36508 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406585AbgJTMtm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 08:49:42 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUr57-002fST-F2; Tue, 20 Oct 2020 14:49:37 +0200
Date:   Tue, 20 Oct 2020 14:49:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, Jassi Brar <jaswinder.singh@linaro.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahisa Kojima <masahisa.kojima@linaro.org>,
        Serge Semin <fancer.lancer@gmail.com>
Subject: Re: [PATCH net] netsec: ignore 'phy-mode' device property on ACPI
 systems
Message-ID: <20201020124937.GW456889@lunn.ch>
References: <20201018163625.2392-1-ardb@kernel.org>
 <20201018175218.GG456889@lunn.ch>
 <20201018203225.GA1790657@apalos.home>
 <CAMj1kXEtLx_5_Hyuk=nU6PhnYZm3F33uWGiRHH2Yb3X2ENxRSw@mail.gmail.com>
 <20201020084759.GA1837463@apalos.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020084759.GA1837463@apalos.home>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I hope Andrew is fine with the current changes

Yes, i'm O.K. with it. Making phy-mode optional would just make the
driver more uniform with others.

       Andrew
