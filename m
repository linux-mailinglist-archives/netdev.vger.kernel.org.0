Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A1639A46D
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 17:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbhFCPXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 11:23:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232040AbhFCPXE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 11:23:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5732160FF0;
        Thu,  3 Jun 2021 15:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622733679;
        bh=Zybm2eWmCHPdqFZXgMZGN9YrZynKWIcs4sdZ59Nq7ug=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GP1dXeQvECXRdQTfLY30MPcI9V86xRHbeRDNqeDsl7Rhsld/QysP9W+3rQjuwv11s
         wZD8wttqsx49LNx+N9Gxul32mFIfqiNb7Xdo44JWYQBlNW0Xa9eYv1Vv3lE0VwLMPM
         v0i4QpoMlowRB31PFuTxSLVzBaW/lKGhoj1FdEQCdjEF+BnzvB8a5t+Xi1xUiyYfkg
         +aCBRuLI3zguBVZ9jcNWlf7jiOtgIimPglpmy8IPcUbNLU+d0SejWHJOyylnXHXouj
         Er3rm4boDH+xSQKDVWyMqXces3+6/LwLyO7nnB1MlqYcOciUJHk2WZflpXOHQkvs1V
         nTIrRpX4+j5ig==
Date:   Thu, 3 Jun 2021 17:21:15 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: phy: marvell: use phy_modify_changed()
 for marvell_set_polarity()
Message-ID: <20210603172115.6c73751b@dellmb>
In-Reply-To: <E1lomyE-0003mc-RP@rmk-PC.armlinux.org.uk>
References: <E1lomyE-0003mc-RP@rmk-PC.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 03 Jun 2021 14:01:10 +0100
Russell King <rmk+kernel@armlinux.org.uk> wrote:

> Rather than open-coding the phy_modify_changed() sequence, use this
> helper in marvell_set_polarity().
>=20
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Marek Beh=C3=BAn <kabel@kernel.org>

