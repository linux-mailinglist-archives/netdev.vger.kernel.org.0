Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22263461598
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 13:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236565AbhK2NBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 08:01:04 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56636 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237346AbhK2M7E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 07:59:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=XOVkih41RX66KTs9+23MxYWn1mXjCMCqzfFsQMEVdfg=; b=Cj
        HotBN6DRaFjXE5tww9lchur3dznlAA7gyo9A/bsn5AP7H5U2dgKRyZLvOirBMJLrOPxNfqjKXSHPi
        Xg4Bph3aWGDwVWgV7IOPIu+cA5O2yvw7WFyTFJUseww7AB5FicZTB8enWZW6Ufvmte4Jb5q43PN3+
        OyCgzJVjGFcAAAk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mrgC6-00Eujx-S3; Mon, 29 Nov 2021 13:55:42 +0100
Date:   Mon, 29 Nov 2021 13:55:42 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linus.walleij@linaro.org, f.fainelli@gmail.com, olteanv@gmail.com,
        vivien.didelot@gmail.com, hkallweit1@gmail.com,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: Re: [PATCH net v2 1/3] net: dsa: realtek-smi: don't log an error on
 EPROBE_DEFER
Message-ID: <YaTNzlFfGZXyXDuR@lunn.ch>
References: <20211129103019.1997018-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211129103019.1997018-1-alvin@pqrs.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 29, 2021 at 11:30:17AM +0100, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> Probe deferral is not an error, so don't log this as an error:
> 
> [0.590156] realtek-smi ethernet-switch: unable to register switch ret = -517
> 
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
