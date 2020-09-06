Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D09A25EF61
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 19:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729069AbgIFRvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 13:51:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728969AbgIFRvM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 13:51:12 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38B9A20738;
        Sun,  6 Sep 2020 17:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599414672;
        bh=0uS/Xb04sMGqz8a/7dLJSu+HroUxuuEG/P2YcBvUYxk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2qOeEkOq0MDtnQMsYBz/lFVHmXKdAbW980cX/J7GZVrnhz3v41HvrkeGBNUFYnC/0
         ciktMRHyh+NgPgC6OmAPkRzH84Fb02O7G/2GZNxrezlWlc+0v5WEkfKMMt3271iiwT
         sRXgRU6cnpfeX0b9ZjnQI5C1yAf+gVYLV6KtEXE0=
Date:   Sun, 6 Sep 2020 10:51:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [net-next PATCH] net: dsa: rtl8366rb: Switch to phylink
Message-ID: <20200906105110.7e7fbfd4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200905224828.90980-1-linus.walleij@linaro.org>
References: <20200905224828.90980-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  6 Sep 2020 00:48:28 +0200 Linus Walleij wrote:
> -static void rtl8366rb_adjust_link(struct dsa_switch *ds, int port,
> -				  struct phy_device *phydev)
> +void rtl8366rb_mac_link_up(struct dsa_switch *ds, int port, unsigned int=
 mode,
> +			   phy_interface_t interface, struct phy_device *phydev,
> +			   int speed, int duplex, bool tx_pause, bool rx_pause)
>  {

> +void rtl8366rb_mac_link_down(struct dsa_switch *ds, int port, unsigned i=
nt mode,
> +			     phy_interface_t interface)
> +{	.get_sset_count =3D rtl8366_get_sset_count,


drivers/net/dsa/rtl8366rb.c:972:6: warning: no previous prototype for =E2=
=80=98rtl8366rb_mac_link_up=E2=80=99 [-Wmissing-prototypes]
  972 | void rtl8366rb_mac_link_up(struct dsa_switch *ds, int port, unsigne=
d int mode,
      |      ^~~~~~~~~~~~~~~~~~~~~
drivers/net/dsa/rtl8366rb.c:1009:6: warning: no previous prototype for =E2=
=80=98rtl8366rb_mac_link_down=E2=80=99 [-Wmissing-prototypes]
 1009 | void rtl8366rb_mac_link_down(struct dsa_switch *ds, int port, unsig=
ned int mode,
      |      ^~~~~~~~~~~~~~~~~~~~~~~
drivers/net/dsa/rtl8366rb.c:972:6: warning: symbol 'rtl8366rb_mac_link_up' =
was not declared. Should it be static?
drivers/net/dsa/rtl8366rb.c:1009:6: warning: symbol 'rtl8366rb_mac_link_dow=
n' was not declared. Should it be static?
