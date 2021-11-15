Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6523451DAE
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353191AbhKPAc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245510AbhKPAa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 19:30:26 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FB6C06FD8E
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 14:57:09 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id d11so38864309ljg.8
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 14:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RmphX0MvgxPcyZ1NxD5xM+drSKIWrzBdfK3vQGpFT0Y=;
        b=PTAG7zydJ+Czx1L/qKKrEFKvHQHR2PHUkLnV7dbMJ0n9YPER5y8gWhw+0A4fU6ji6l
         qe9M0vz8I2Nxj7j6lsb9kI9plzoSWN7+JLBMq4KpxUh8j0gnIaO11fHllhUFtKqmVOM3
         jX5Gg5k0vSUQZJbx+Sgc6lISP4h2zVzGzcl7sZ5b+45aqLYzrwGX9DGu4/yrwOZDy/xI
         I6PGAxCTOCUA3Iyf9CgUJoadM29jrjtnvrK5KCtQJA0wjA5lBqGHOx3ViTI6D5IIyZRy
         FGUKigyHPNq2VwV2ZcoSimpbSN7GB0on28jjQ7ZYWSUev9o3eZOeQr5KPdN3/1Nk985Q
         m2iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RmphX0MvgxPcyZ1NxD5xM+drSKIWrzBdfK3vQGpFT0Y=;
        b=6KgjdHaa+OeaqiILnEV4MRYK1tOr7JMqCke9EJFrvCG8tVhybQcjxrHOYvPgWEJFxg
         gtnYAYND2zGvmqmzJbKElwSLDENrS5qFwPPronYxPKdic9n5CTRPCj2VX/JwpVYb+Uhy
         YUhzgqrQbTV7IHXgvbv/ske9oj5IBhxrxL4o4v0BK8D37SXt8MNlnJsH8q9bT60cbpZT
         RkoUqsbXpVDpoCaSgBzbA3dFRl/4xz98wPqfxdp5WDsMSYVBFe23y5mjasgs/Ooa0/pq
         eLYLAdOH42tczLtpw5JGMs77Obj4IGA2+JaNF6wQE7jihc0KEHHIjp0B77t/rzL3MK8I
         6yKQ==
X-Gm-Message-State: AOAM532vkrM9B/0jbnoLESy5PmSA2pyEKP7GHrPUKBCL9fNlDxbszknU
        1IbfJ2vqDrw8+UIZNcyZ6AeIFC+LUzbhGCUjzQHCXQ==
X-Google-Smtp-Source: ABdhPJx7gdgAc+IXgszBD3wr3x5nZ4t8p3VJpeJTlxk1cFk85uFsL1LfgIM2zpoAdMMdZYsRUKVnSbLxhRvEXvqbe6U=
X-Received: by 2002:a2e:8906:: with SMTP id d6mr1464579lji.454.1637017027772;
 Mon, 15 Nov 2021 14:57:07 -0800 (PST)
MIME-Version: 1.0
References: <20211115153024.209083-1-mw@semihalf.com> <YZK2bPgHE0BFlDMd@lunn.ch>
In-Reply-To: <YZK2bPgHE0BFlDMd@lunn.ch>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Mon, 15 Nov 2021 23:56:54 +0100
Message-ID: <CAPv3WKcUO7fnbOJH5tQ0hKATV2WpOBTog2WpzgEYjQk-JQa5_g@mail.gmail.com>
Subject: Re: [net: PATCH] net: mvmdio: fix compilation warning
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, upstream@semihalf.com,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,


pon., 15 lis 2021 o 20:35 Andrew Lunn <andrew@lunn.ch> napisa=C5=82(a):
>
> On Mon, Nov 15, 2021 at 04:30:24PM +0100, Marcin Wojtas wrote:
> > The kernel test robot reported a following issue:
> >
> > >> drivers/net/ethernet/marvell/mvmdio.c:426:36: warning:
> > unused variable 'orion_mdio_acpi_match' [-Wunused-const-variable]
> >    static const struct acpi_device_id orion_mdio_acpi_match[] =3D {
>
> How come OF never gives these warning, just ACPI? If there something
> missing in ACPI which OF has?

It was enough to compile mvebu_v7_defconfig with W=3D1 to get it (so
CONFIG_ACPI disabled). There may be a similar case for config _OF, but
I couldn't deselect it easily and compile mvmdio at the same time.

>
> > Fixes: c54da4c1acb1 ("net: mvmdio: add ACPI support")
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: Marcin Wojtas <mw@semihalf.com>
>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>

Thanks,
Marcin
