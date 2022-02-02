Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8AB4A6CB3
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 09:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243310AbiBBIJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 03:09:35 -0500
Received: from molly.corsac.net ([82.66.73.9]:42054 "EHLO mail.corsac.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243222AbiBBIJf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Feb 2022 03:09:35 -0500
Received: from scapa.corsac.net (unknown [IPv6:2a01:e0a:2ff:c170:6af7:28ff:fe8d:2119])
        by mail.corsac.net (Postfix) with ESMTPS id C611E9A
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 09:09:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corsac.net; s=2021;
        t=1643789371; bh=cwIF7F/SraYRZ1XqJOwvVwfaQlEYV0phYUPLhFULyt4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dNCsRHjRZcCnbCMENn3tYnv3dB5mf26YBqEkJF4Ngcy4Mh8Y1KQNW7Hzjf8P9AGUC
         /SsRYjclabhS113SgGH19GEZUXsjgVSTXILsARw3ovSxPWGHR05ERbfdzh2DNqIo+9
         OcZK4KvqPbclrug3tiwjvX6QMKwE/VM28OVa99PM71YxbvjuU643yp50v7fP0atFM+
         5/vLUVDaCfeyit1SpdZISO7W9TsxHj78ejCuq7Qm5WzZN7PwTCFsaILdZC/TknLeA7
         dCVUyS2v2ndsNzRTt6BJbDqGFXogb79rX5k9R6956ywWXsAzA2Ls5J6xvfIt54Rss7
         ZdDhZQT1aERrA==
Received: from corsac (uid 1000)
        (envelope-from corsac@corsac.net)
        id a0060
        by scapa.corsac.net (DragonFly Mail Agent v0.13);
        Wed, 02 Feb 2022 09:09:30 +0100
Message-ID: <0414e435e29d4ddf53d189d86fae2c55ed0f81ac.camel@corsac.net>
Subject: Re: [PATCH v2 0/1] ipheth URB overflow fix
From:   Yves-Alexis Perez <corsac@corsac.net>
To:     Jan Kiszka <jan.kiszka@siemens.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Georgi Valkov <gvalkov@abv.bg>
Cc:     linux-usb <linux-usb@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "stable @ vger . kernel . org" <stable@vger.kernel.org>
Date:   Wed, 02 Feb 2022 09:09:30 +0100
In-Reply-To: <cover.1643699778.git.jan.kiszka@siemens.com>
References: <cover.1643699778.git.jan.kiszka@siemens.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.42.3-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-02-01 at 08:16 +0100, Jan Kiszka wrote:
> Georgi Valkov (1):
> =C2=A0 ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback
>=20
> =C2=A0drivers/net/usb/ipheth.c | 6 +++---
> =C2=A01 file changed, 3 insertions(+), 3 deletions(-)

Hi,

sorry for the extra-long delay. I finally tested the patch, and it seems to
work fine. I've tried it on my laptop for few hours without issue, but to b=
e
fair it was working just fine before, I never experienced the EOVERFLOW
myself.

Regards,
--=20
Yves-Alexis
