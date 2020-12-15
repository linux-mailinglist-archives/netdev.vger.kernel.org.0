Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD392DA6E2
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 04:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbgLODEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 22:04:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbgLODEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 22:04:36 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DCBC061793;
        Mon, 14 Dec 2020 19:03:55 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id w13so35557268lfd.5;
        Mon, 14 Dec 2020 19:03:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eG4n9xlHK+SC1LnsZtRhg9CmgC53883GCBz3X7IjH2k=;
        b=NfCR/RzNIhL9/8rUWxOMM1RKNx6qavE3Bpc1JyLwBn5wkEgkl4Y+FnLJiDqSs3f9j/
         tXexs/0wiINS7DTDeiTxy/CXROmShi8Jto6O5yVfAciOvEgvSLbseFxyq7RkVNEMgYyt
         FBJheKRgljUESdaGYCkiNGjYx1Rqwpcc8wSh1H/5ALTA6YqiLsmWkv3jvYagpXFBs6UG
         /zBIyp17ssnsAqKhnOJFTwNlWVWpoOrJFf83FoygJN8La9qe+JAEGRkxVrqeoAFALFoo
         TqgiRPSMpPjYkprH7DgFt2r7knsKyvj5g9oN0LYOEiOsOnteS0TG7And7C3BJQP8KlqR
         +sbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eG4n9xlHK+SC1LnsZtRhg9CmgC53883GCBz3X7IjH2k=;
        b=Zw5Dfb9wbMlfToG4IIGzIOjcT7wg0XfXhDMi8HxCiBtlOiQaAyxTncved2IsGv61kE
         NsczPGzdS0SB7npKPVMmBI3s+n5BOhiAxFiGaHU6gHbRLDnq1x29eG9YpUaDCH3BOPw2
         61BALBN0Lu/vBYs7N91Crq8jwT/vwvbHjE4kaqNaWFPFr1VSWv9qKepzgE/YtRQkxj84
         2k8OaLhgHOibjPLRNQzLMjXkJVRKjq569BzUkvwnoAXM6HSWo2pCLPBVzDuqGI34Vb1u
         DE/vdznJ0Qr6uZn/b+sjKHw+Oj9axB9BnWE67A6yYIGOrjkVa9yC7nlt/5Q/WGl7qTnh
         vR4w==
X-Gm-Message-State: AOAM532dYkveFwALnRVYoO0V3871xSyBKajGEdPVoHzM2lVoiBeuUJiT
        oIEMgfku3Kouv/th2kzqpL7DU87EKn0z0hjjS/0=
X-Google-Smtp-Source: ABdhPJwZ8B6BkRbU5hZNjNnCS2mYUbc9BKbp2oGlfkxy7IPbHqsJlcKUmNFOjAT2zleyHz+y0Dm9FS5ZdzSBwCY03k0=
X-Received: by 2002:a2e:90d6:: with SMTP id o22mr11848460ljg.56.1608001434542;
 Mon, 14 Dec 2020 19:03:54 -0800 (PST)
MIME-Version: 1.0
References: <20201214114658.27771-1-bongsu.jeon@samsung.com> <20201214160202.GD2493@kozik-lap>
In-Reply-To: <20201214160202.GD2493@kozik-lap>
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
Date:   Tue, 15 Dec 2020 12:03:43 +0900
Message-ID: <CACwDmQCi83rNDEOMaGsDRx553DPUeCOmKiLZtzx5HHj2QdbL+w@mail.gmail.com>
Subject: Re: [PATCH net-next] nfc: s3fwrn5: Remove unused nci prop commands
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 1:02 AM Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On Mon, Dec 14, 2020 at 08:46:58PM +0900, Bongsu Jeon wrote:
> > From: Bongsu Jeon <bongsu.jeon@samsung.com>
> >
> > remove the unused nci prop commands that samsung driver doesn't use.
>
> Don't send patches one-by-one, but group them in a patchset.
>
> Previous comments apply here as well - NCI is acronym, start with
> capital letter.
>
> Best regards,
> Krzysztof
>
I will update the comments and send the patches in a series.
