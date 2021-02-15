Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA5D131C119
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 19:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbhBOSD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 13:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbhBOSDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 13:03:52 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19353C061574;
        Mon, 15 Feb 2021 10:03:12 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id g5so9166182ejt.2;
        Mon, 15 Feb 2021 10:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fJL/RsfeG/zLHNer8l8750jqxkvIthMoJ4fLpHP+s+Q=;
        b=V4roTA+i2D75balDfj3Nzy8DbVKcCc6m0C7rOJ+JrqacB/s+zQe75i2WBIm1VdqiuG
         uyNbM/uC55SxMcA7Lmi2HCyTZtu8o2MYDawOkUheTgGo31MmVB1MQ5VLWXW7tkzitlQj
         58bBFyP+TAj4y7uoiZzqKSmB/4cGV1LywzWo8joMjzDW5YgC1uARRx3hNY1AX53zRmFB
         VDTmvOi/KPiyMeLbzIJkHMLhs3jIJADKEGpd4612Uom7/QbR23KiceJqfOHWdZKJyKBF
         YW2pxiH2B4+z3o3Ij8LgPWwin7x4AX3kfkYiO51AyfyHyWPzWCOTx7CKQAE5/3ebwY6M
         MSJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fJL/RsfeG/zLHNer8l8750jqxkvIthMoJ4fLpHP+s+Q=;
        b=OuCyI8FS5AQXRD1kNMe6jxCfFUqwwT9xfwPL+Q3EKLgt5xdGGnHvy5F9sQtakRerOH
         nA0dL71mPT6KWBo7AiGtP/y6sFLG8wWd4tmYKtEykYitIDHsiOZ1R1O+8K5UAWLdPhjl
         lLRGX9TZyEYUwzHp2Kvd+LcUyX9FKn47kWdYpfjri/mWW03Md2GL2UirbP9QXlN1xj/E
         ZCeOAGZqWotMtnEm/dJJzbdDu7m3q5HUkmqudDsG8O8pThR1uBWzoo8oO+ihIjrL/mTG
         MrXiOEA21ESRrdSpbg+0lTtUq1DTQ82RmDullqAb8De/bIVpfFfV/R16mYX7By5obptA
         zStQ==
X-Gm-Message-State: AOAM530CHTOZHJlHsGADR1K7l1Oce2aWCBrQor4F77aHx1l8BdrCWHzM
        Zv1yfrjKG1/EVNUybDONfAudEvVnn+/WrjZ2LW/KRqPTiKs=
X-Google-Smtp-Source: ABdhPJzoPEdf1j7n0BEtWFLtOViDHlf8SYNmkF8TguNuZRPNx6QFhL88w4kAje9ojgLGGUOOAnEfltepBpYX8aMwDYg=
X-Received: by 2002:a17:907:2957:: with SMTP id et23mr1156885ejc.543.1613412190756;
 Mon, 15 Feb 2021 10:03:10 -0800 (PST)
MIME-Version: 1.0
References: <CAHp75VecgvsDqRwmyJZb8z0n4XAUjEStrVmXDZ9-knud7_eO3A@mail.gmail.com>
In-Reply-To: <CAHp75VecgvsDqRwmyJZb8z0n4XAUjEStrVmXDZ9-knud7_eO3A@mail.gmail.com>
From:   Peter Robinson <pbrobinson@gmail.com>
Date:   Mon, 15 Feb 2021 18:02:59 +0000
Message-ID: <CALeDE9PkZnrZ=cXKB16+oZ0=O=3XSYqsgXi9TKeuWT7KqXrdNQ@mail.gmail.com>
Subject: Re: commit 0f0aefd733f7 to linux-firmware effectively broke all of
 the setups with old kernels
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Josh Boyer <jwboyer@kernel.org>, Ferry Toth <fntoth@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Seems the commit 0f0aefd733f7 to linux-firmware effectively broke all
> of the setups with the old kernels. Firmware name is an ABI (!) and
> replacing it like this will definitely break systems with older
> kernels. Linux firmware package likely, but unfortunately, should
> carry on both versions as long as it's needed. Alternative solution is
> to provide the links during installation.

It does provide the links using the copy-firmware.sh and the details in WHENCE.

The alternative is to leave firmwares in place with CVEs.
