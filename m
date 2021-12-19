Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2125747A1F4
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 20:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236476AbhLSTqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 14:46:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232253AbhLSTqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 14:46:22 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB04C061574
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 11:46:22 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id be32so12646540oib.11
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 11:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IYQeE4jabs1r8ninevJCam3jflXnaB80AfMKvSe7cSw=;
        b=kaa6JMI8D7p74Rzn2e/E7o01mPGOPhk+FTvwdPNPn7Pr6C7C1aOSV90vxls3uDYanv
         SyDj/puxgAnfIXQr9C8e4Z+pvaHJfa4Op6Ex0DfFHQyX4Pu6B6vSe73Uy6VH4AndzquK
         mz4pWx9Z4ShCua5JQvBz3Uxu9c06lotyIcqBKxBBjeBHgeMkq/F7godPKFc2qF9sIpfI
         m7u7+ZGwQHKO4fTkvNCDgw3vYBzVz8TIqxUz9UwRzeMXJcTFXGHrI6772tAIS/RayRNN
         +EUe7JDqn1MxORul2Xirtf1pdyEnudRv1qk7NMZG30zaW8UVD2SRzmqm8+y2eQ/48pvY
         Eu/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IYQeE4jabs1r8ninevJCam3jflXnaB80AfMKvSe7cSw=;
        b=Z7veeKHk4+n8UqxJrSQTquFbm06iWRNhlPC/YeaJBxCkpuDjYb5zJ8fCBjjPPPtRih
         HQgh28Ucz38CmcOFIJpgbrP9eNfnilk3jNkp90un2O/Cvc1Lmdm7t6yRPowWMfnnhIX/
         H0rislunf+jmwpyDpCF/9MRihiwIEObFF9ih6QFhkSMdBFcNUadI0X2z496WQHXNZOCK
         MR+uPmQNPp+zw05pu5ANlbY2GEq+mDdN13wBj22GKRiGib08b+J+TbfczkckwHpq/zr0
         gp1LbNm4v6iKmX6d0oKYXFa0vCVNNlEPUkktMGgJ6I8Lx84MURQe1abjPPUetO28as7L
         RcWA==
X-Gm-Message-State: AOAM532LfEtB3qfovtriOjB011twHsNtWyQ6piq07h8Gct26/om8MIo6
        MxzBoMhBOoZSBMmf/fRxrLDQ4Qr9g/KBD2ZCaZUswOsbpUE=
X-Google-Smtp-Source: ABdhPJzkQ9ksy80MnHmFMUgZeUAQ/uMzXx9mph0+7A0zKR6ajNBzasEPyLlcrGMB0vL+Nw+AS1uu4ZvpY+qwvu5F0+k=
X-Received: by 2002:aca:120f:: with SMTP id 15mr9514015ois.132.1639943181680;
 Sun, 19 Dec 2021 11:46:21 -0800 (PST)
MIME-Version: 1.0
References: <20211216201342.25587-1-luizluca@gmail.com> <20211218081425.18722-1-luizluca@gmail.com>
 <20211218081425.18722-2-luizluca@gmail.com>
In-Reply-To: <20211218081425.18722-2-luizluca@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 19 Dec 2021 20:46:10 +0100
Message-ID: <CACRpkdbobMAX9eSZcNYTDbQu3K8i7MZ7oWVcevML=KPDPPJCvg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 01/13] dt-bindings: net: dsa: realtek-smi:
 mark unsupported switches
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, ALSI@bang-olufsen.dk,
        arinc.unal@arinc9.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 18, 2021 at 9:14 AM Luiz Angelo Daros de Luca
<luizluca@gmail.com> wrote:

> Some listed switches are not really supported yet.
>
> Reviewed-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
(...)
> -      "realtek,rtl8366"
> +      "realtek,rtl8366"               (not supported yet)

This is still Linuxisms, (not supported yet) does not belong
in the DT bindings. When the NetBSD developers (who use
device tree) read this what are they supposed to think?
That it is not supported yet on NetBSD? Or U-Boot? Windows?

Please just drop these.

Yours,
Linus Walleij
