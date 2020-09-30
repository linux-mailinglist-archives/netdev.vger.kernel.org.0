Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775F227E442
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 10:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725776AbgI3Izy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 04:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728149AbgI3Izy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 04:55:54 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E96CC0613D0
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 01:55:54 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id m13so1065631otl.9
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 01:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessos-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SU/KZorwRWRL3VQ/bnlD6zatox7adu+Yzz6+KkwnCJ4=;
        b=mIcjvw4QfPXdUpHHnDQd2EAF6em28m/w0TxKUY/pOQ531f69qetZxMfu85C+jGWUx+
         RsGzSYepT7f8uhBpkZZ1SCTrxtFwTbWIfA9rHPEXull4DiUBLfmy+hWoXW26PKZ9F6PA
         swu2asF31NZ0HYAUD117T6orWgKSEb3f0NPq4PK/zFCfb4sndcQ4sEsDuEa5Yurqo3ri
         9z4DCbmtoE4xwFXV+suegEt2nsLs9sSKS3gzKOZElpOPtpuMPseWeATEtL6kaHWdRBy+
         PVa+1PXyoImzTYl9jYGoUb5qciN9iYEVmYWL3TwBNIb5H8c8vhm6bLBl/Hrm/N3PLdNe
         L7eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SU/KZorwRWRL3VQ/bnlD6zatox7adu+Yzz6+KkwnCJ4=;
        b=KoFc47xfqmRjfH3e3aKqLkDkt+gqncgb8aiFfev7J3UluS6jQb6FyTX2gyNLI9Q1OY
         AFpgSxzi4mqxs7b47llgtSvaDifrbr4psI+ctuzjxYSNipXyoeiFKiWQkCnHpQRdixOf
         /KRVHMFwoHaaD3c5t8C62SOwqPaxxsrr0x1gfRYd7hCjJzWzJo1DFCgbfcA67/Z/rR72
         XELXN6IYC87bdnTJikYoAqUn74zFeD2jvnr+QOMo7FPA1q004w70EPqprYLxkHqdzaLI
         39k2FjiDroTaGsfSfNq2RkNUoieRmg40qhXVJUUaXLQiuT2nwJ2m7Oh1Qgyhin0ii8ib
         zhew==
X-Gm-Message-State: AOAM532lcp1KGhTZh30Dyu2jErh0Q3JDzRVvu4kTVRTTHDDeilcuE11e
        jfNtxSF67u7/unMnIfRAjihdNADAeWT9igjZJ4Q6Uw==
X-Google-Smtp-Source: ABdhPJyDoZDpk7jo3S5AcUdSP5wfMgSpjwWhzEylMHlaBm+m7Q5JKHnzC4yoydYe5dk8pehl1CiDx7Ygo2Kgzjpi6VM=
X-Received: by 2002:a9d:1:: with SMTP id 1mr898289ota.81.1601456153412; Wed,
 30 Sep 2020 01:55:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAPpJ_ecS3LOYUMdrodMoxMRQ_4q4M06uyGzBBf+W8MrjP08-EA@mail.gmail.com>
In-Reply-To: <CAPpJ_ecS3LOYUMdrodMoxMRQ_4q4M06uyGzBBf+W8MrjP08-EA@mail.gmail.com>
From:   Jian-Hong Pan <jhp@endlessos.org>
Date:   Wed, 30 Sep 2020 16:54:16 +0800
Message-ID: <CAPpJ_ec_Xwf8qwdb1XVDkhwFOQr=oNGOoCevAic5yJVZLKEGjQ@mail.gmail.com>
Subject: Re: [QUESTION] Enable the wireless module on Pinebook Pro
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dan Johansen <strit@manjaro.org>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I forgot to mail to Dan Johansen as well.

Jian-Hong Pan <jhp@endlessos.org> =E6=96=BC 2020=E5=B9=B49=E6=9C=8830=E6=97=
=A5 =E9=80=B1=E4=B8=89 =E4=B8=8B=E5=8D=884:15=E5=AF=AB=E9=81=93=EF=BC=9A
>
> Hi,
>
> According to the preloaded system Manjaro ARM on Pinebook Pro [1], I
> found the firmware files in ap6256-firmware package [2] enable the
> wireless module, including WiFi and Bluetooth.
> If we want to redistribute the firmware files to linux-firmware
> repository or other distros, which kind of license should follow?
>
> [1] https://www.pine64.org/pinebook-pro/
> [2] https://gitlab.manjaro.org/manjaro-arm/packages/community/ap6256-firm=
ware
>
> Jian-Hong Pan
