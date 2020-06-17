Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 282CC1FD35E
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 19:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgFQRZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 13:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgFQRZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 13:25:02 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD70EC06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 10:25:01 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id k1so1251404pls.2
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 10:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NWrKjq8dc4uzleKZUh1UYi4bIv5tUZx3nNEonWLCXqk=;
        b=pxppPwhAvp4p5ckuHpisFXwfxEU7EsAq3w8JBZCL9PUMlzvaTn+6SfnGbsy/jh1nsJ
         AS5ZwO4ivuwwfNGEkTgFeoraPBev2v4JjZJ7mvdUk3B15+8bAZGoe1ZjNZG4vFGzS9oE
         ucYD2AejtcWQhg5VQCFBiDSQ5SKCenTosiD9/qR2kWtzpJEOIGiE6o6C3Rv+AOA8F3N9
         xt5BuPWLSXrtX4yVFHRkovLTbmAoNZKOF2f59nggKxc1lbCWt7bgHk3jzlgIlsUyiyvC
         zWAPxMdQ7H7t6qV4VfdVvIrSoJIGOJC7WA3WPQvxlS5hVoBBJC5PzDJJNHF2WEgd+8Kd
         P/ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NWrKjq8dc4uzleKZUh1UYi4bIv5tUZx3nNEonWLCXqk=;
        b=HNuuIhrbc2Jw4Xq0mzmkyDskK4zxvwR88Ggzcfn+nA3je03NK1mvNnChkZwsV6Gk1t
         RWVUWlHIxCr4TYzWzAFFv/L2WE46P2RhP1ZOM9N5XRI4BBlUvP65Z907SeNw/pRVJ+Gj
         Fun+7oOuKO8xNrBgpWCx8vuMV7rlWAb4HdF/vRBDXHFp3cB9icaP2Axssq7y7HZE2VxS
         iELBjKPvrJIlHLV1/X4UNNgY01YKPSGMzZdNIcrr1nepHPFw3q2d7xeDHrcRNCOcI+lu
         B0CWfYerfpJIEiJHZGzjvnbJhZBaoA4CmQEQ/ZEri+cZVL3Y3Ssc6oda/Zlty2lUJWeV
         RhWw==
X-Gm-Message-State: AOAM533mxGjooKwLtD0+XPAnoZXJ8buM/0PDPPmGFBtu5uYVCrvrLX0w
        FA01QCFCERCMlZq3XCulil7d0jWqSpV14I/ZhN9hI1A9PyE=
X-Google-Smtp-Source: ABdhPJxBOokLLKOTfNGCtWa77nvXhlW2xh2DY2gRg7Pf+5PzraXzAUemyAdHzkfaly0WpN5a6036aFER6AzpNijmfvY=
X-Received: by 2002:a17:902:b206:: with SMTP id t6mr117409plr.262.1592414700091;
 Wed, 17 Jun 2020 10:25:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200617171536.12014-1-calvin.johnson@oss.nxp.com> <20200617171536.12014-3-calvin.johnson@oss.nxp.com>
In-Reply-To: <20200617171536.12014-3-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 17 Jun 2020 20:24:47 +0300
Message-ID: <CAHp75VcRg+gEKufBSbcJdbzAkzrQHLkj17wiL7tH9+2RyD5z+Q@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] net/fsl: acpize xgmac_mdio
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>, linux.cj@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 8:16 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> From: Jeremy Linton <jeremy.linton@arm.com>
>
> Add ACPI support for xgmac MDIO bus registration while maintaining
> the existing DT support.
>
> The function mdiobus_register() inside of_mdiobus_register(), brings
> up all the PHYs on the mdio bus and attach them to the bus.

...

> -       snprintf(bus->id, MII_BUS_ID_SIZE, "%llx", (unsigned long long)res.start);
> +       snprintf(bus->id, MII_BUS_ID_SIZE, "%llx", (unsigned long long)res->start);

Since you are here, better to change the specifier to the dedicated
one, i.e. "%pa".
But I don't remember if it adds 0x to it...

...

> +static const struct acpi_device_id xgmac_acpi_match[] = {
> +       { "NXP0006", (kernel_ulong_t)NULL },

       { "NXP0006" },

is enough. And I suppose this is the official ID.

> +       { },

No need to have comma in terminator line.

> +};

-- 
With Best Regards,
Andy Shevchenko
