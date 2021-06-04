Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5BC39C262
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 23:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhFDV36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 17:29:58 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:42813 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbhFDV34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 17:29:56 -0400
Received: by mail-pj1-f50.google.com with SMTP id l23-20020a17090a0717b029016ae774f973so5965287pjl.1;
        Fri, 04 Jun 2021 14:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4UyrG9Z9DorUurxry+5VL+nEcP5Ybc7uiEG9qyPmX1Y=;
        b=fWNPBRRDnEYp18yVR/nkNS+p/+5DWMyQHXNN7sp3So+WCCvaPgC1xAqotIrfTP5N8V
         ZHu14j6sRYezqdTGaI2WYCj14wS3dKzwk3zMOJZTjZzgkfueePHpTIoLSt8aDSGQ5UjE
         c1/XbGU0lHwGbymsMF1UAggKTNy1j2mwlJHmPoYPvzZFOL7aOO/NyRe2+PBW9FtYidIP
         qN0IaamR2M+TJyMdPhonjPhar6AilQ487eHD9d19+0uVroaibZ4EOoLQxz49CFwMLJFi
         ImHOLLPWdaHtiCJZIN+7G0RmcIjUOe+lRnxLtxSF/R5fv4wYE4ko0CxxbbGNeHVBi1D8
         Z4eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4UyrG9Z9DorUurxry+5VL+nEcP5Ybc7uiEG9qyPmX1Y=;
        b=Bf04aU1qyWhM7QSe60KEztBHc8tNabMLfTxi58FaoeH/TERJeJXyDoSEDKi8FQpt1/
         RjA9kw1Q0u8DIjtfvuhtpsu250FeOk2TxlaXypxCYRDBQScGvm6v8Zk1OYShQnJbgs7P
         uMq62H1yzuX4+kqHWNgRInFUfTYBWqoeDXo1jbKwSeMttaH0QPsOb5OpTgv9kIGH6OPa
         3+ucyjZkiRue2lP7r1X2sVVEw8woQNy6oZzueGSTC56Bj/EqNSHxoUtonItlD+Q1iQFk
         mDVQbYD5/2e3rCbmYaDoLwcCieT9sSDwylNmD6U9CVhU2lxcg6JG7F63vBckc2KPNARi
         QWcQ==
X-Gm-Message-State: AOAM533eeWnSLU50apomofrnP9IZp5xoNtYE14wz0tp7lfW8RgntdEvQ
        ifXaZz0Pq/XatIRHff7dKszBgcjDGuYa3CEm7CkcXMrJXhFDEg==
X-Google-Smtp-Source: ABdhPJygnp3hyB0sgLAeBeO8JnZmo+qjyOhjPPh4uxERbVKPOlgrdsPtC+Z0QkefLm5SPhoDEJhfIud6iFD0TEVe2yg=
X-Received: by 2002:a17:90a:17ad:: with SMTP id q42mr19181275pja.181.1622842029398;
 Fri, 04 Jun 2021 14:27:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210522131827.67551-4-verdre@v0yd.nl> <20210604211447.GA2240001@bjorn-Precision-5520>
In-Reply-To: <20210604211447.GA2240001@bjorn-Precision-5520>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Sat, 5 Jun 2021 00:26:52 +0300
Message-ID: <CAHp75Vcab8COGmQdY7M0ag5qS0mTXpOmvbyP426aLJ=wNfM+0A@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] mwifiex: pcie: add reset_wsid quirk for Surface 3
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     =?UTF-8?Q?Jonas_Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 5, 2021 at 12:15 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
> On Sat, May 22, 2021 at 03:18:27PM +0200, Jonas Dre=C3=9Fler wrote:
> > From: Tsuchiya Yuto <kitakar@gmail.com>
> >
> > This commit adds reset_wsid quirk and uses this quirk for Surface 3 on
> > card reset.
> >
> > To reset mwifiex on Surface 3, it seems that calling the _DSM method
> > exists in \_SB.WSID [1] device is required.
> >
> > On Surface 3, calling the _DSM method removes/re-probes the card by
> > itself. So, need to place the reset function before performing FLR and
> > skip performing any other reset-related works.
>
> Maybe this is a nit-pick, but I understand "probing" to be something
> the OS does, namely what we normally call "enumeration," i.e.,
> discovering a device.
>
> So it sounds like the _DSM causes a logical hot-removal of the card,
> which the PCI hotplug driver should notice and it should remove the
> driver and remove the pci_dev.
>
> And the _DSM also causes a hot-add (reading the code below, it looks
> like this is actually a second _DSM),

_DSM can be only one (single) per device node in ACPI.
But _DSM may have "functions", that's what we see here.

> which the PCI hotplug driver
> should also notice and enumerate the bus (i.e., it reads config space
> looking for a device).  This all would cause a new pci_dev to be
> allocated, resources assigned for its BARs, and the driver .probe()
> method to be called again?
>
> That seems like a lot, so maybe I didn't understand what's actually
> happening.


--=20
With Best Regards,
Andy Shevchenko
