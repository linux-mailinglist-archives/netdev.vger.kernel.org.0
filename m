Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C738F2336C5
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 18:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbgG3Q3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 12:29:54 -0400
Received: from mail1.protonmail.ch ([185.70.40.18]:63219 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgG3Q3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 12:29:52 -0400
Date:   Thu, 30 Jul 2020 16:29:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1596126588; bh=lhZL6Pg1VacjmIyZabRgO1ohmiqISKl8lk2khLgH1zY=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=fBfc+Z5WK4LT0RIPNlnzsUdqaHb7L4Rwn/1kWFPjFoSs4fggKqBlhfLaArRzDYHTp
         QxPAzbWFQVgo2VIlBJQZdqgTY6gS5urh/qD/eIAjfpqGMTJqRgKxwc/vWW4fm50i4P
         RWkN9MG1296BCrQL2zQjoldG9qg1B+w0c+JlBLWHOAaOnMmmsVyCwhNXYOcB4RnD2U
         V3PYC0QJVG0sv9aQQdZTQkDQilr+NwoFF0rN+t/wDKNG26ZYxySXFMEcktD6gcKGdm
         t5uD2uwVTn0y29XG4MdKPIHKkhlmxfmfhhLM2Y1AIC2usc9LXQu/tHVmBLFrEn7YKT
         5eWpl9+NRjJGA==
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v1] qede: Use %pM format specifier for MAC addresses
Message-ID: <pXdhhJtDMa8Tr3tB0ugk5KdQcS3D71r1PEgqtPcJ3kBa4P_Yc0xG6HSXW9O1bQB_1FyD4wvS0xiXLiqvUb3OVzDKR9e7lLijB7jf6ZoHfaw=@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Thu, 30 Jul 2020 19:00:57 +0300

> Convert to %pM instead of using custom code.
>=20
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/net/ethernet/qlogic/qede/qede_main.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Thanks!

Acked-by: Alexander Lobakin <alobakin@pm.me>

> diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/e=
thernet/qlogic/qede/qede_main.c
> index 1aaae3203f5a..4250c17940c0 100644
> --- a/drivers/net/ethernet/qlogic/qede/qede_main.c
> +++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
> @@ -144,9 +144,7 @@ static int qede_set_vf_mac(struct net_device *ndev, i=
nt vfidx, u8 *mac)
>  {
>  =09struct qede_dev *edev =3D netdev_priv(ndev);
> =20
> -=09DP_VERBOSE(edev, QED_MSG_IOV,
> -=09=09   "Setting MAC %02x:%02x:%02x:%02x:%02x:%02x to VF [%d]\n",
> -=09=09   mac[0], mac[1], mac[2], mac[3], mac[4], mac[5], vfidx);
> +=09DP_VERBOSE(edev, QED_MSG_IOV, "Setting MAC %pM to VF [%d]\n", mac, vf=
idx);
> =20
>  =09if (!is_valid_ether_addr(mac)) {
>  =09=09DP_VERBOSE(edev, QED_MSG_IOV, "MAC address isn't valid\n");
> --=20
> 2.27.0

Al

