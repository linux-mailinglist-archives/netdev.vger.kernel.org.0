Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E7A46159C
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 13:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239203AbhK2NBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 08:01:39 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56650 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239540AbhK2M7j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 07:59:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=nzF9c0mHcYd2ATqEBBpHindXnNdhWqjhmU3zz8S+NBE=; b=I9
        Dvlx7ceknDos5zBjhbA4KZKO0OD/TLY1sJr12YKRw+h8Q8JQwVUPOIiABKYL4OVeCZizVPcrTzp2o
        i2qi48sJyt6E4n/zYv9Vi4Phz+s7W3TUtoJ4uJ4+1JspzOTpnHbpt/yAaBucmxIK75W2AYM1X/A1o
        RjhQGczTG7GZOd4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mrgCi-00EukQ-JD; Mon, 29 Nov 2021 13:56:20 +0100
Date:   Mon, 29 Nov 2021 13:56:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linus.walleij@linaro.org, f.fainelli@gmail.com, olteanv@gmail.com,
        vivien.didelot@gmail.com, hkallweit1@gmail.com,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: Re: [PATCH net v2 2/3] net: dsa: rtl8365mb: fix garbled comment
Message-ID: <YaTN9BZpXZMz1fJw@lunn.ch>
References: <20211129103019.1997018-1-alvin@pqrs.dk>
 <20211129103019.1997018-2-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211129103019.1997018-2-alvin@pqrs.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 29, 2021 at 11:30:18AM +0100, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> Fixes: 4af2950c50c8 ("net: dsa: realtek-smi: add rtl8365mb subdriver for RTL8365MB-VC")
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
