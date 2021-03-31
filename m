Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4252A34FF73
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 13:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235170AbhCaL01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 07:26:27 -0400
Received: from mail-lf1-f50.google.com ([209.85.167.50]:45811 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbhCaL0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 07:26:14 -0400
Received: by mail-lf1-f50.google.com with SMTP id g8so28610702lfv.12;
        Wed, 31 Mar 2021 04:26:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=P7YRkvHMUch5SWVA/Zijsi+qvMktzIEo0xzyRVCK4eY=;
        b=GaC/fmiZqjm0AwrdKuZ0rjUrWi83mA1sldXl4SxfLd1EzL+qv0iohABsEKLNEs2rZd
         o3MAKAnTPiGOHTzb6BokvyWzdzwT0lgG6wQbMTHEhWbD03EETfXGkbwp1kzbg6v+QwsN
         QEOuen9VxILQHqotfdG+PwbZR3MkbG3ayttHMNb0E/lkNB4jAFzCwSiKeMeHOK1ydHZi
         Z6gMTVVeN/rwCGHFBzJx/tc6MFJ07GN8qUzajBCbz+mE1R+Y/++QqaQs8r/+Xbi4gjM6
         p70wik4k579+KBIuGChGqu0tkpFfKUNOUusxHWXCa6JYKcjxaQXWYxkxGijGxlS3UfLO
         wpTQ==
X-Gm-Message-State: AOAM532KCRyahIHu6BZdDBQirVpf9FwNcRiE8sZ8KZUTOIMU6GB+Tqs0
        ZoMt6cm9dmRlXI2Dh5DR/kI=
X-Google-Smtp-Source: ABdhPJydKenIBDUjWhvNZYs0IEwbr/2XYCC10D7kE7nLGof+tVtmbemEPfszmwgVSuRb87Ck+ym5jQ==
X-Received: by 2002:ac2:5e26:: with SMTP id o6mr1973549lfg.355.1617189973420;
        Wed, 31 Mar 2021 04:26:13 -0700 (PDT)
Received: from rocinante ([95.155.85.46])
        by smtp.gmail.com with ESMTPSA id h4sm209294lfv.22.2021.03.31.04.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 04:26:12 -0700 (PDT)
Date:   Wed, 31 Mar 2021 13:26:11 +0200
From:   Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, nic_swsd@realtek.com,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v4 0/3] PCI: Disable parity checking
Message-ID: <YGRcU8esaSxq45aT@rocinante>
References: <20210330174318.1289680-1-helgaas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210330174318.1289680-1-helgaas@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bjorn,

> I think this is essentially the same as Heiner's v3 posting, with these
> changes:
> 
>   - Added a pci_disable_parity() interface in pci.c instead of making a
>     public pci_quirk_broken_parity() because quirks.c is only compiled when
>     CONFIG_PCI_QUIRKS=y.

Very nice idea to add pci_disable_parity(), looks very clean.

>   - Removed the setting of dev->broken_parity_status because it's really
>     only used by EDAC error reporting, and if we disable parity error
>     reporting, we shouldn't get there.  This change will be visible in the
>     sysfs "broken_parity_status" file, but I doubt that's important.
> 
> I dropped Leon's reviewed-by because I fiddled with the code.  Similarly I
> haven't added your signed-off-by, Heiner, because I don't want you blamed
> for my errors.  But if this looks OK to you I'll add it.
[...]


Thank you Bjorn and Heiner!

Reviewed-by: Krzysztof Wilczyński <kw@linux.com>

Krzysztof
