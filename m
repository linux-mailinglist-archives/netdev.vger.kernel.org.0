Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 314981962F8
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 02:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgC1Bx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 21:53:57 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:40235 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbgC1Bx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 21:53:57 -0400
Received: by mail-ed1-f66.google.com with SMTP id w26so13678484edu.7;
        Fri, 27 Mar 2020 18:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pi7H1Ajr6bMiyo1A76OQeaQ+kStGGuPp2rRUkY34J+0=;
        b=dKsVu3U9Skfh/V4Y98tY+UkG1iu89G7w6W9xFiKgbBH3J2WA0eww4U645YJSvJwPjc
         ijE+oCEEyaDqLAUTNvpl+CO1dW4pFL1bYPy3A5qOdn4UNK9IApTJ5s9fR/IUROkb0y1C
         vpNG3Up050LqakRSWF5PSrR89lwpt1o2QSRr1x7tqY2o/kK6WkdhDW249USC2hj15dAB
         ebft4/PvcrtmvNJImcuq1mOnLT25mo6D2VOaHf3Yrli2brGv8kX4733/eXFEh4Jjdg8m
         zNq2hVAAYdSUOw05O5ZeAtVcPPWK7Xio5WdMHXTwmjEKmf2AUvtcjjcyPk19lFMEHuVp
         WgKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pi7H1Ajr6bMiyo1A76OQeaQ+kStGGuPp2rRUkY34J+0=;
        b=mkXqqUyjgtudRmnQVzxK67aHBCPAgeoOlTBh/Gvo63YiOfGRmrBDmBzC8ImwOXsZ8j
         Rbb1iWg3+J089ZhznAbVAD+9QbpBFbgIWm+YoREYKufxy+jIrE8v7VTLJEgi2CE85g0/
         fBMFrhZcQO7/DxkbXc95oS05HBRfQh39rDbTzw7kd+THCQvj8yeW2EzOiMuvj9dtC+kY
         EiDYMbdSBmlQrS/BjjIhtWQgI3nojNGgmVATn+kcdk44YBjvE8KyAVARsrRPGk+Ru5xo
         bji+xd0qg1kOXBJu55CzTLuKdtRX1pW0yZw3x9VuDj66hu7i6jJ1QivCsb/GzblJhpvb
         3ZpA==
X-Gm-Message-State: ANhLgQ02NdCutydKi6RXoxMQvW2aNF17rf+14L2hv/FnlabpQW8siGNt
        J/VQxnJ+2yJLXcOutVzafN2ucvBUOlcm1kLDdRo=
X-Google-Smtp-Source: ADFU+vsvILa3PT8XxzuSZHQ/kr7rcKC6H72nvPxy3U9RYV/qYBFlLjgvVfwmeqbbemT53KphYXqjasieKh843Fbf4d0=
X-Received: by 2002:aa7:dcc9:: with SMTP id w9mr1925720edu.145.1585360434676;
 Fri, 27 Mar 2020 18:53:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200323225254.12759-1-grygorii.strashko@ti.com> <20200326.200136.1601946994817303021.davem@davemloft.net>
In-Reply-To: <20200326.200136.1601946994817303021.davem@davemloft.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 28 Mar 2020 03:53:43 +0200
Message-ID: <CA+h21hr8G24ddEgAbU_TfoNAe0fqUJ0_Uyp54Gxn5cvPrM6u9g@mail.gmail.com>
Subject: Re: [PATCH net-next v6 00/11] net: ethernet: ti: add networking
 support for k3 am65x/j721e soc
To:     David Miller <davem@davemloft.net>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        peter.ujfalusi@ti.com, Rob Herring <robh@kernel.org>,
        t-kristo@ti.com, netdev <netdev@vger.kernel.org>, rogerq@ti.com,
        devicetree@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>, nsekhar@ti.com,
        kishon@ti.com, lkml <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Fri, 27 Mar 2020 at 05:02, David Miller <davem@davemloft.net> wrote:
>
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> Date: Tue, 24 Mar 2020 00:52:43 +0200
>
> > This v6 series adds basic networking support support TI K3 AM654x/J721E SoC which
> > have integrated Gigabit Ethernet MAC (Media Access Controller) into device MCU
> > domain and named MCU_CPSW0 (CPSW2G NUSS).
>  ...
>
> Series applied, thank you.

The build is now broken on net-next:

arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi:303.23-309.6: ERROR
(phandle_references):
/interconnect@100000/interconnect@28380000/ethernet@46000000/ethernet-ports/port@1:
Reference to non-existent node
or label "mcu_conf"

  also defined at
arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts:471.13-474.3
arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi:303.23-309.6: ERROR
(phandle_references):
/interconnect@100000/interconnect@28380000/ethernet@46000000/ethernet-ports/port@1:
Reference to non-existent node
or label "phy_gmii_sel"

  also defined at
arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts:471.13-474.3

As Grygorii said:

Patches 1-6 are intended for netdev, Patches 7-11 are intended for K3 Platform
tree and provided here for testing purposes.

Regards,
-Vladimir
