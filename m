Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7CA3317DB
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 20:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbhCHT5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 14:57:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:53866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229650AbhCHT5H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 14:57:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7741664F11;
        Mon,  8 Mar 2021 19:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615233426;
        bh=pZm1KKz7YDd0tc8FeKCWWn2VHcYWsn8ksMwoL4sWiWc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=doJBFmNegS2G5u5fF9/vb74TzlMwHpwOO8FgQ6fY6yaRPflykk3mq20Q+L1dlP+iP
         zdy+cFd5JHMWizP+gUOf6Gw4OinGH2/EoETj0/P82r1gcqVg1WIqMtNMrDSkhvxGng
         xtgiwZOwm0Hf+rvPcrR11Q/FWQREOGM8y7EEwCK02xUszP+B4Ox3e3N1ufuy/+OD27
         3XrHsXiP2WberRgtlDAWAnKxIg9rWhYcrp/09ezsBHCx3y3ZQbSUH7ibBGsDRdLegv
         C6F1SQcHXgJTwQoTvvO5ggrcZAVdhDHUoeMXy7EYmtg51PTNDKnsqVPdWS5yBjN6Gf
         P9W1iza5zBGZA==
Date:   Mon, 8 Mar 2021 11:57:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6?= Rojas <noltari@gmail.com>
Cc:     jonas.gorski@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: mdio: Add BCM6368 MDIO mux bus controller
Message-ID: <20210308115705.18c0acd5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210308184102.3921-3-noltari@gmail.com>
References: <20210308184102.3921-1-noltari@gmail.com>
        <20210308184102.3921-3-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  8 Mar 2021 19:41:02 +0100 =C3=81lvaro Fern=C3=A1ndez Rojas wrote:
> This controller is present on BCM6318, BCM6328, BCM6362, BCM6368 and BCM6=
3268
> SoCs.
>=20
> Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>

make[2]: *** Deleting file 'Module.symvers'
ERROR: modpost: missing MODULE_LICENSE() in drivers/net/mdio/mdio-mux-bcm63=
68.o
make[2]: *** [Module.symvers] Error 1
make[1]: *** [modules] Error 2
make: *** [__sub-make] Error 2
make[2]: *** Deleting file 'Module.symvers'
