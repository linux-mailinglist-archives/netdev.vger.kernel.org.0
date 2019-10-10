Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E95AD3428
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 01:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbfJJXI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 19:08:28 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:40904 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbfJJXI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 19:08:28 -0400
Received: by mail-qk1-f196.google.com with SMTP id y144so7201157qkb.7
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 16:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=dYnCAzmD3179JkW0E6N8o5l09Fg+PCFocJZQOrrariI=;
        b=XPQ801EzPkG17GtmU1S/+KK8zhmpjyB/xBW0Sd4RJf7vwIJ0liylR5xxzgUrkN/0h2
         uJW87DASagG5yucss5IrAV9YQQtALoM4cIMNoEZRZ7w2KBG9h7Hs9saBiMarbioO0QRq
         Vq3mb1n0ru5sD65vh5SpkmMJnpgylTemb7Agl3N9cG+hxckq7RNt9B92uNS6QHP4Kh5N
         rpQPLfnAfc2o8c2TXqIfdD3yYaO43G9A4A3Ip2Nz5QU4keuiWDiUcrn7Ko/IavpjzswR
         nB1YnXUEmcjwdELpAVxgPoqqz+xSu90qzzFOksFXZ1xzbPjljVxuY3xbEeKKrCLHJCbF
         OQ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=dYnCAzmD3179JkW0E6N8o5l09Fg+PCFocJZQOrrariI=;
        b=AVI52XfiKFUqFl08QgmtDkk/ir5DB4XmGd74kqcWsGkhq11j84EvS2/7XqoK8hr5BF
         cPi+7GTp/8f6rt+bCSZ1x1Zlb1b2GpkejW5X2n3Lulz3oMTl64ws5WJpP+mCDqworxKD
         e7k450VufI2YwL/PvxpoIwAD/Lajnbuy8YP8iqeRVW28V9P3rj/36cJdS41aPIxtL0wu
         PWm26hism2jWfKL4TaBtoid07tVjRRseQYPcCkMkyVNLw9Pj07P7BpWE171iofk6/zu3
         7rmJRRN0K+8ZVDyDyc9tg1TWk+k9FIWUORg9tdc0fIhHf8ZXlOdAW1FXzyUyBOe1UQkC
         Xuaw==
X-Gm-Message-State: APjAAAVxN0578Pw7j/vdiMQjzpskW/81Tecuyxi0R6aMm39XMDFRPDtX
        fTeR9O3FmH1ySuIVCtHmNgJBxQ==
X-Google-Smtp-Source: APXvYqztP1NwgbTUNMTAexqMx7k7mNZOl8NRi9r+CxEBp0bOefbFFYfYnsoJG+J8zntnZLr9pg5fhA==
X-Received: by 2002:a37:bd03:: with SMTP id n3mr12653858qkf.47.1570748907378;
        Thu, 10 Oct 2019 16:08:27 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x76sm3228371qkb.29.2019.10.10.16.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 16:08:27 -0700 (PDT)
Date:   Thu, 10 Oct 2019 16:08:11 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Anson Huang <Anson.Huang@nxp.com>
Cc:     fugang.duan@nxp.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, andy.shevchenko@gmail.com,
        rafael.j.wysocki@intel.com, swboyd@chromium.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linux-imx@nxp.com
Subject: Re: [PATCH 1/2] net: fec_main: Use
 platform_get_irq_byname_optional() to avoid error message
Message-ID: <20191010160811.7775c819@cakuba.netronome.com>
In-Reply-To: <1570616148-11571-1-git-send-email-Anson.Huang@nxp.com>
References: <1570616148-11571-1-git-send-email-Anson.Huang@nxp.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Oct 2019 18:15:47 +0800, Anson Huang wrote:
> Failed to get irq using name is NOT fatal as driver will use index
> to get irq instead, use platform_get_irq_byname_optional() instead
> of platform_get_irq_byname() to avoid below error message during
> probe:
>=20
> [    0.819312] fec 30be0000.ethernet: IRQ int0 not found
> [    0.824433] fec 30be0000.ethernet: IRQ int1 not found
> [    0.829539] fec 30be0000.ethernet: IRQ int2 not found
>=20
> Fixes: 7723f4c5ecdb ("driver core: platform: Add an error message to plat=
form_get_irq*()")
> Signed-off-by: Anson Huang <Anson.Huang@nxp.com>

Hi Anson,

looks like there may be some dependency which haven't landed in the
networking tree yet?  Because this doesn't build:

drivers/net/ethernet/freescale/fec_main.c: In function =E2=80=98fec_probe=
=E2=80=99:
drivers/net/ethernet/freescale/fec_main.c:3561:9: error: implicit declarati=
on of function =E2=80=98platform_get_irq_byname_optional=E2=80=99; did you =
mean =E2=80=98platform_get_irq_optional=E2=80=99? [-Werror=3Dimplicit-funct=
ion-declaration]
 3561 |   irq =3D platform_get_irq_byname_optional(pdev, irq_name);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      |         platform_get_irq_optional
cc1: some warnings being treated as errors

Could you please repost once that's resolved?  Please add Andy's and
Stephen's acks when reposting.

Thank you!
