Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1D194AC7FC
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239685AbiBGRwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:52:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239239AbiBGRne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:43:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931F1C0401DC;
        Mon,  7 Feb 2022 09:43:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 043CE61278;
        Mon,  7 Feb 2022 17:43:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC45EC004E1;
        Mon,  7 Feb 2022 17:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644255812;
        bh=RLEMhWrnDa584icLIkvgra88zyqBR3qBpqKw0vbjPjY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IjTrCxiR6ZOTEoAb/VsqpmXtMkjmWPv4A+/A0EkZxb0VMh+LmIQualOOfx5AhZZX6
         vv9mxp/wQ4mzAupVACW1cO+Q0NI+YyWYFn8wzl3py6e/UAfJ2fmaK+4lhqddDBcAMO
         UCzqTJ1PK52TteOpCgkGZn0LA3NLj+H+J/UDwGRsRKpNfblDGuaJfYBVXhWgttjv41
         uPnOTZ76IMTcHbkjhTGirl2VmqBROCfSH5ZDb9nPwK/1gIyMFNq8uT1uTdzDv3n/ir
         XjyJ8yckeQy1rnrIswt7KdSTUNgbYZzfjh/JoH2n9LK9gwnyZCnziq32I/+hHwpyCq
         +fvCoCRbY5Xeg==
Date:   Mon, 7 Feb 2022 09:43:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joseph CHAMG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, joseph_chang@davicom.com.tw,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        andrew@lunn.ch, leon@kernel.org
Subject: Re: [PATCH v18, 2/2] net: Add dm9051 driver
Message-ID: <20220207094331.6c02c521@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220207090906.11156-3-josright123@gmail.com>
References: <20220207090906.11156-1-josright123@gmail.com>
        <20220207090906.11156-3-josright123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  7 Feb 2022 17:09:06 +0800 Joseph CHAMG wrote:
> Add davicom dm9051 spi ethernet driver, The driver work for the
> device platform which has the spi master
>=20
> Signed-off-by: Joseph CHAMG <josright123@gmail.com>

In file included from include/linux/etherdevice.h:21,
                 from drivers/net/ethernet/davicom/dm9051.c:7:
drivers/net/ethernet/davicom/dm9051.c: In function =E2=80=98dm9051_rxctl_de=
lay=E2=80=99:
drivers/net/ethernet/davicom/dm9051.c:930:42: warning: format =E2=80=98%d=
=E2=80=99 expects argument of type =E2=80=98int=E2=80=99, but argument 6 ha=
s type =E2=80=98long unsigned int=E2=80=99 [-Wformat=3D]
  930 |                 netif_err(db, drv, ndev, "%s: error %d bulk writing=
 reg %02x, len %d\n",
      |                                          ^~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~~~~~~~~~~
  931 |                           __func__, result, DM9051_PAR, sizeof(ndev=
->dev_addr));
      |                                                         ~~~~~~~~~~~=
~~~~~~~~~~~
      |                                                         |
      |                                                         long unsign=
ed int
include/linux/netdevice.h:5107:37: note: in definition of macro =E2=80=98ne=
tif_level=E2=80=99
 5107 |                 netdev_##level(dev, fmt, ##args);               \
      |                                     ^~~
drivers/net/ethernet/davicom/dm9051.c:930:17: note: in expansion of macro =
=E2=80=98netif_err=E2=80=99
  930 |                 netif_err(db, drv, ndev, "%s: error %d bulk writing=
 reg %02x, len %d\n",
      |                 ^~~~~~~~~
drivers/net/ethernet/davicom/dm9051.c:930:84: note: format string is define=
d here
  930 |                 netif_err(db, drv, ndev, "%s: error %d bulk writing=
 reg %02x, len %d\n",
      |                                                                    =
               ~^
      |                                                                    =
                |
      |                                                                    =
                int
      |                                                                    =
               %ld
