Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5063D2B461D
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 15:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730310AbgKPOpH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 16 Nov 2020 09:45:07 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:43663 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728041AbgKPOpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 09:45:07 -0500
Received: by mail-yb1-f196.google.com with SMTP id d1so3641197ybr.10;
        Mon, 16 Nov 2020 06:45:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eVAoV+Om+KSwWe/PCuQoaHgBa3Kx3i6nXlnbfHJU4x8=;
        b=JeEkqE9fRk5A3+vmoTAT71P2INpGYDhEVbkf/yndGyMO4kzrYAxZ4ePjwen4GgPjgE
         aibrkDGLwrmEzm+7u8qP8e7IAlE4uWdhKMp12+SG1Sj6AYTbkV0b6mdXEkSlnEKWqgIo
         WqGDuEAvNYpJ8X1tN7ZGhoWKbCVffhJO/wObocjStv7ug1hpZtKwWnLG+BV2YI0q3FKQ
         nP4VYuwphaCtz8QYx/JnEoAoFAm1TIbvbMTUNQnA+jLbmZ2Tmhkw4pGANTlNWc8kcLEi
         bsX7PqdwBCFuLn3bKr7amFWCpk+QAa0ihPimTeTt+3HsLp5xh66FbAH6Z40hsGnw+jyb
         M9oQ==
X-Gm-Message-State: AOAM533miaJj7fpGjiEXYroi5CCi6Oy9aPu2MU7kw+O+B2idZTVcuZYA
        2DPDLozE6NftRZt+DCuzuzlDbYKvVmD6a52js3z1mOFnCMuFD8Sv
X-Google-Smtp-Source: ABdhPJwy+JD4UB0T+4Cxy7ersmtursVy3Gb+RVdPhEamvSQsxOI+Edu8N1ZDENFFFBU8zPNhCOEQ0KQn7OmrCeP1y/I=
X-Received: by 2002:a25:b90e:: with SMTP id x14mr17217228ybj.307.1605537905871;
 Mon, 16 Nov 2020 06:45:05 -0800 (PST)
MIME-Version: 1.0
References: <20201114152325.523630-1-mailhol.vincent@wanadoo.fr> <11bada82-7406-d8e1-66e3-43db237ee265@pengutronix.de>
In-Reply-To: <11bada82-7406-d8e1-66e3-43db237ee265@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Mon, 16 Nov 2020 23:44:54 +0900
Message-ID: <CAMZ6RqKVi8GFxU7s2zkzcv9RLSr_GidayjKu1YyNFRDOijUvgg@mail.gmail.com>
Subject: Re: [PATCH v6] can: usb: etas_es58X: add support for ETAS ES58X CAN
 USB interfaces
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can <linux-can@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon. 16 Nov 2020 at 03:55, Marc Kleine-Budde wrote:
> On 11/14/20 4:22 PM, Vincent Mailhol wrote:
> > This driver supports the ES581.4, ES582.1 and ES584.1 interfaces from
> > ETAS GmbH (https://www.etas.com/en/products/es58x.php).
> >
> > Co-developed-by: Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>
> > Signed-off-by: Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>
> > Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
>
> The driver fails to compile with CONFIG_SYSFS switched off
>
>   CC [M]  drivers/net/can/usb/etas_es58x/es58x_core.o
> drivers/net/can/usb/etas_es58x/es58x_core.c: In function ‘es58x_init_netdev’:
> drivers/net/can/usb/etas_es58x/es58x_core.c:2380:32: error: ‘struct netdev_queue’ has no member named ‘dql’
>  2380 |  netdev_get_tx_queue(netdev, 0)->dql.min_limit =
>       |                                ^~

Thanks, nice catch!
CONFIG_SYSFS is an expert setting, I totally missed that one. Took me
actually a couple of minutes navigating in the menuconfig to find how
to remove the option.

The root cause is actually on CONFIG_BQL (which depends on
CONFIG_SYSFS).
Reference: https://elixir.bootlin.com/linux/latest/source/include/linux/netdevice.h#L636

Will send a v7 patch right after.

Out of curiosity, how did you find this? Did you find it during a code
review or did you just happen to have a .config with CONFIG_SYSFS


Yours sincerely,
Vincent Mailhol
