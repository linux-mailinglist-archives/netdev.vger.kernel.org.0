Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E5642F5F6
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 16:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240695AbhJOOqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 10:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240672AbhJOOqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 10:46:44 -0400
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22214C061762
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 07:44:38 -0700 (PDT)
Received: by mail-ua1-x92b.google.com with SMTP id e2so18461544uax.7
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 07:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6NXO5j/QvPweGncoBAgiXUgJMHU7982ggUW1I99+ELI=;
        b=qQDqhHXvOOt2EigmIUXiWCQKCuVRCjrBtPuU7e6JSBKdRAIr9FunCz0YnNxNZIMeA7
         aMLe6kS7dqzw1URKahIvNJhM9AuQbeemsIQUSKAiYehsmFtISL3AkdrwAoNS6zIkob/9
         /KtDkv9XsyMmnftzcffE0mXjzBQe+ld4pQYYOOZVVvjF2ZZo8Y5Phz/EoW+3DSF8Lc1Z
         JF2KAgPbCApxB3orWhy+gLzKD5rHVWPDu94uqNUBXAE5iIe9QzBVAkZmVHNdfcUo5hFz
         fpRNNdZgJiSwSuMUwRXdtLMzcZ+zwMygcGsY6DB8uWwxVjt5NwC+kvdtIHvLEYDRDfRS
         wB5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6NXO5j/QvPweGncoBAgiXUgJMHU7982ggUW1I99+ELI=;
        b=0/6PJxEBJVuweENZOc+fTDWMb6b9HyaoZ5rMwjfGTF88jGvvsI9XOTHwF3D3KUOwW1
         /K80QLXJ1j/fXS+hd01NHwy78TJLIGIXz9SwWMRslgwf9jVlXc11ibjRwAIUU14XqjgL
         rF1nuADZGakWTQ0OH7JCTZ1tpOVMSjPkP8RXSzMqUnydzpazJESjK0C+lBFhy5iwKUkJ
         AGjQ4jvMx5fGKk70/9PxVJj4QHa+WzjeWuIUpcbOiMi9Sh2hzuQ2mJYqEGddH+e6OIR1
         Z6uTSWGOgCyPadNuR19XTi79/4qm9K2OzT6W+mKTNoURWgDlyNqY4p1/Msrr5/V47C7E
         pdUg==
X-Gm-Message-State: AOAM532Uthe4Y1Y2osJexbaEUlK5L6loJo+hSILvdLEPJ1czuFucGSLU
        8/pFyNKQJb+TC0R/Jhe13KgqNVaf299Vz/732vY4SobV
X-Google-Smtp-Source: ABdhPJwTx5WOz/B4JFQIN2LXVYOE6NknltOp91EUdzVCPhuF8CBbkZUp65CtShUv6SVmutruddi0ECLxgD3e4Aj+Ssk=
X-Received: by 2002:a67:d78c:: with SMTP id q12mr14260184vsj.28.1634309077262;
 Fri, 15 Oct 2021 07:44:37 -0700 (PDT)
MIME-Version: 1.0
References: <CALW65jbKsDGTXghqQFQe2CxYbWPakkaeFrr+3vAA4gAPjeeL2w@mail.gmail.com>
In-Reply-To: <CALW65jbKsDGTXghqQFQe2CxYbWPakkaeFrr+3vAA4gAPjeeL2w@mail.gmail.com>
From:   Sergio Paracuellos <sergio.paracuellos@gmail.com>
Date:   Fri, 15 Oct 2021 16:44:26 +0200
Message-ID: <CAMhs-H8-hfR4m4ArUvPO9wCZoE=shV9vbv89yT43mmhMp-LTcA@mail.gmail.com>
Subject: Re: MT7621 ethernet does not get probed on net-next branch after 5.15 merge
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Siddhant Gupta <siddhantgupta416@gmail.com>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        OpenWrt Development List <openwrt-devel@lists.openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Qingfang,

On Fri, Oct 15, 2021 at 4:23 PM DENG Qingfang <dqfext@gmail.com> wrote:
>
> Hi,
>
> After the merge of 5.15.y into net-next, MT7621 ethernet
> (mtk_eth_soc.c) does not get probed at all.
>
> Kernel log before 5.15 merge:
> ...
> libphy: Fixed MDIO Bus: probed
> libphy: mdio: probed
> mt7530 mdio-bus:1f: MT7530 adapts as multi-chip module
> mtk_soc_eth 1e100000.ethernet eth0: mediatek frame engine at 0xbe100000, irq 20
> mt7621-pci 1e140000.pcie: host bridge /pcie@1e140000 ranges:
> ...
>
> Kernel log after 5.15 merge:
> ...
> libphy: Fixed MDIO Bus: probed
> mt7621-pci 1e140000.pcie: host bridge /pcie@1e140000 ranges:
> ...
>
>
> I tried adding debug prints into the .mtk_probe function, but it did
> not execute.
> There are no dts changes for MT7621 between 5.14 and 5.15, so I
> believe it should be something else.
>
> Any ideas?

Maybe you have a chance to try git bisect to see what is the commit
that introduces that regression and report here?

Best regards,
    Sergio Paracuellos
