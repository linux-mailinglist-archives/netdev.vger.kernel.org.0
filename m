Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7231EBF2E
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 17:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgFBPj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 11:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgFBPjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 11:39:25 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E10C08C5C0;
        Tue,  2 Jun 2020 08:39:24 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id nu7so1558304pjb.0;
        Tue, 02 Jun 2020 08:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fCLWRAj6WHhP+ObXwD/pQyps8oF17BSxdX9gcDmUZ5M=;
        b=pYX+IbGFVr/4qqRHb5kRjVgsVNJywwsLdY5LnuVhvmvbiGoFVS9JFPZZmAZcUUjdUx
         17jyd9swcx/riFEjI2EPmREzbCpX4L+KbQjnq8uId4tpci0z1KkY1ydsoDh9mjkt/lsQ
         KvqahWYTihDV7jJkHss2j23dHFLnPIwHH4muKUXhbIuFAbxlc1ib0sqeqPeAXRbsf2gn
         wMlfw5iE5+82xDhtiUcH9lZ2LjiFO0Q18LzILiH/AjH2dWOVpIHroxi3cye70Vttht45
         p4NgKs1ziO5yv5/YpdJ5Xn+KBOIdJ3LyMXSahsiA9kTaNEnK4E9Zaa8Veb9eIt19hBou
         xm4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fCLWRAj6WHhP+ObXwD/pQyps8oF17BSxdX9gcDmUZ5M=;
        b=Tb8WyjcPG4/P2a7ZE4oRFd3lVwFeSJr//U3qEjRaB9lLUdM1x0yknnsiA/WnQCAgCn
         Zee05wNwkG6fK6+PDsi3mvZ27Ksf07pMWezo25lrX/gxaKjFj6aTelsvg4Qz898BDDf/
         M4fuMDgZ51g7ZqSgmpfpCLF2Y6eJl3HeOiCFCYfGeY6E9C6sgCCgVILlkfgCif+kgecG
         O9cl6P3gy/am1IUvhvNaFPvtoD3bNY0rJYFsc5wSSgwaiW2JKm3Uo2tD7m6X12k/vGq+
         DZDu5cg4vxOMLSl1IzsFNchYrVFS010TtRPfAkab5T+9AtB6aMKfp+UpIwcuihrw8xG1
         zLlg==
X-Gm-Message-State: AOAM531WnqREvvqM1I95Ts/eLZGnUJF+XFgVaS4grANRQy0OzdA0QV+h
        qRqdu4CnY2EFbziSBXAu3m7piRVeLktCEPrwRdKuniqGu98=
X-Google-Smtp-Source: ABdhPJw+pAar+vtUn4AwgUT0o2Iuxy0FG7fSieSNVJ9T1qGejv6fs7xmWgK3SbEGwklxDEF73pROvDThMsFErvvXCrE=
X-Received: by 2002:a17:90a:ac05:: with SMTP id o5mr6420217pjq.228.1591112364465;
 Tue, 02 Jun 2020 08:39:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200602092118.32283-1-piotr.stankiewicz@intel.com>
In-Reply-To: <20200602092118.32283-1-piotr.stankiewicz@intel.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 2 Jun 2020 18:39:12 +0300
Message-ID: <CAHp75VfEcm-Mmo7=i40sJ0RqpOgFRpJHxQ9ePWvvqsyRp+=9GA@mail.gmail.com>
Subject: Re: [PATCH 14/15] net: hns3: use PCI_IRQ_MSI_TYPES where appropriate
To:     Piotr Stankiewicz <piotr.stankiewicz@intel.com>
Cc:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 2, 2020 at 12:26 PM Piotr Stankiewicz
<piotr.stankiewicz@intel.com> wrote:
>
> Seeing as there is shorthand available to use when asking for any type
> of interrupt, or any type of message signalled interrupt, leverage it.

...

>         vectors = pci_alloc_irq_vectors(pdev, HNAE3_MIN_VECTOR_NUM,
> -                                       hdev->num_msi,
> -                                       PCI_IRQ_MSI | PCI_IRQ_MSIX);
> +                                       hdev->num_msi, PCI_IRQ_MSI_TYPES);

...

>                 vectors = pci_alloc_irq_vectors(pdev, HNAE3_MIN_VECTOR_NUM,

>                                                 hdev->num_msi,
> -                                               PCI_IRQ_MSI | PCI_IRQ_MSIX);
> +                                               PCI_IRQ_MSI_TYPES);

One line as above?

-- 
With Best Regards,
Andy Shevchenko
