Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D0142FD58
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 23:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238583AbhJOVV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 17:21:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229445AbhJOVV7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 17:21:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 134EC60F8F;
        Fri, 15 Oct 2021 21:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634332792;
        bh=8EpwbXfqCihyp1kWvX2Lskh5HYwA27kvk5tv5n7Tu6w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KB3OEs21r1y4VABkoEXUch7UTAqN/deNDDa5K4UCOV7M7BtIKkiG1AyEBv7KYxQX6
         tvof7V/CwGNan4m6xF6/UKhc93rZAm+O3E8Iy6bW7E41zBLEOw9kHP4/DNR6Tzm7OQ
         Tthr/I7FWgaw+1aZQvbeNrpX/qx/0EatZJqcGtZCcDkCUr75g7BJZSEv5JGUKPXHSf
         GLXw/yF2msORIC4hL4GhTRRa5TW0LXIWtPXdMFvfgOo08VVPrTM8za7+MSy7Qo2XVd
         2dMQmrqn2yKTbz4NpW/bSI0kIYTsF9gUaLRqyYnjjb9jOgIvMyi50ZfyEY0gRfAiw4
         JpENM5+u/NUEQ==
Date:   Fri, 15 Oct 2021 14:19:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Cc:     netdev@vger.kernel.org, Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Andrew Lunn <andrew@lunn.ch>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: marvell: prestera: add firmware v4.0
 support
Message-ID: <20211015141951.07852e95@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1634309793-23816-1-git-send-email-volodymyr.mytnyk@plvision.eu>
References: <1634309793-23816-1-git-send-email-volodymyr.mytnyk@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Oct 2021 17:56:32 +0300 Volodymyr Mytnyk wrote:
> From: Volodymyr Mytnyk <vmytnyk@marvell.com>
>=20
> Add firmware (FW) version 4.0 support for Marvell Prestera
> driver. This FW ABI will be compatible with future Prestera
> driver versions and features.
>=20
> The previous FW support is dropped due to significant changes
> in FW ABI, thus this version of Prestera driver will not be
> compatible with previous FW versions.

drivers/net/ethernet/marvell/prestera/prestera_hw.c:786:5: warning: no prev=
ious prototype for =E2=80=98prestera_hw_port_state_set=E2=80=99 [-Wmissing-=
prototypes]
  786 | int prestera_hw_port_state_set(const struct prestera_port *port,
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~
