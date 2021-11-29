Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F094615B4
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 14:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346598AbhK2NF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 08:05:29 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56672 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1377319AbhK2ND2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 08:03:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=HDc1o/B4vfmKQoJFWo8BmBrk7PDXDp+/EECoB/Wvu8k=; b=XM
        wUSC/PGYDp10c6karXvlR05J/n1Zbw/Fva4FYXGpO3JpduI96EMC/glt+jmQ5ua2s0goAPozRnvPc
        sM48U+RwPD9FSS7xNGmMpmHnjYKVV0UKfyXLC3QcaPnfWAmcFmedjJVwN4N2bcxJLwYsgRvf5suGE
        tpJ+hmyqs7J4ssc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mrgGQ-00Eulp-0e; Mon, 29 Nov 2021 14:00:10 +0100
Date:   Mon, 29 Nov 2021 14:00:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linus.walleij@linaro.org, f.fainelli@gmail.com, olteanv@gmail.com,
        vivien.didelot@gmail.com, hkallweit1@gmail.com,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH net v2 3/3] net: dsa: rtl8365mb: set RGMII RX delay in
 steps of 0.3 ns
Message-ID: <YaTO2hO2/vPbijCu@lunn.ch>
References: <20211129103019.1997018-1-alvin@pqrs.dk>
 <20211129103019.1997018-3-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211129103019.1997018-3-alvin@pqrs.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 29, 2021 at 11:30:19AM +0100, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> A contact at Realtek has clarified what exactly the units of RGMII RX
> delay are. The answer is that the unit of RX delay is "about 0.3 ns".
> Take this into account when parsing rx-internal-delay-ps by
> approximating the closest step value. Delays of more than 2.1 ns are
> rejected.
> 
> This obviously contradicts the previous assumption in the driver that a
> step value of 4 was "about 2 ns", but Realtek also points out that it is
> easy to find more than one RX delay step value which makes RGMII work.
> 
> Fixes: 4af2950c50c8 ("net: dsa: realtek-smi: add rtl8365mb subdriver for RTL8365MB-VC")
> Cc: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> Acked-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
