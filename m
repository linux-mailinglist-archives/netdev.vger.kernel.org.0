Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26CED3248FC
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 03:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236863AbhBYCtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 21:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234143AbhBYCtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 21:49:24 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F0CC061574;
        Wed, 24 Feb 2021 18:48:43 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id r23so4830744ljh.1;
        Wed, 24 Feb 2021 18:48:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q4pNbsL3f3M5e+tpQcGLyhHs/pFg5rDTg3Nd6Jf64es=;
        b=evrw97IH7xRofQ7LtVoGUGx3oc9qKGDAZvh0OnfKtgeV4fXhbOzeUwhudAuYd6Wn9e
         jvnaV7YjqLR2C5d5EkJP1lo9Ybq0pFyUgBBB2a/hGIWAeboRxiagkKMxgmKyA2rhlOR2
         KPqHDrPuca2toqP3fhe7ImdtjWbThbFzoNoO90efjrrX51nkd5erbMdDD09vFYtB4fpH
         3Mmp4dYEC+DoOJGuqRwFaaOLcTr+2YVKBO+cIDtqf8cAuK37PdvV+TtzEl3s2Dz3l84G
         Q4+f6+e7OI3L9Ng/z4aAyOh0BxEo/7qp7Up6DiD5+rdDV5IaHb/usp+v2gu/BIlwFfHH
         Tkvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q4pNbsL3f3M5e+tpQcGLyhHs/pFg5rDTg3Nd6Jf64es=;
        b=GueTeGXMsofpW4FqoiDT15hyBBi3kaa8x3wbisECKWxfNQDbTtMyVrNYSghswxE76V
         01ADYYdLaBYs+uanYrhZXref+h1HdqQZJy5FXdwAAe/q9aXuPhXD4SXBYwA25BwE6YHK
         1RcZf4IM3zn++bl/QcfjjoIiMn8gfK4TgJlOQEnP1zXF7HEfXLBhftKEZ0plJLLr0/V9
         wShbeE4LTg23+m3eG124pBBhU8x3U/dMKuSGtoydiJqocPSxLNww2Ddal1wIzUXDRXOW
         4NvwLUNwuIesHRjPi/SgkUneomLYhyDkxkcFtK1uiq6WQSjXkHkdH3Q6YP4sbraFcuYP
         Aa2w==
X-Gm-Message-State: AOAM533vUKBHoGVAA+Qq+meqpDEAHtI4Q+c7X/nryK4chFJlwT9CW1A7
        qJ8pcsmLF0a8LyYmODGG0cjgNlPxGRAD2FPWzfxn3wLX5Qs=
X-Google-Smtp-Source: ABdhPJxCVO5mB5/Rdjt53vaxTsyeSUgYidJU1yjvzMkTvS932v+Va9dSnxSWzTxiL8xH7IDvSOBVN7zzCSPScFuEj6A=
X-Received: by 2002:a2e:8357:: with SMTP id l23mr428915ljh.116.1614221322316;
 Wed, 24 Feb 2021 18:48:42 -0800 (PST)
MIME-Version: 1.0
References: <20210224125026.481804-1-sashal@kernel.org> <20210224125026.481804-5-sashal@kernel.org>
In-Reply-To: <20210224125026.481804-5-sashal@kernel.org>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Wed, 24 Feb 2021 23:48:31 -0300
Message-ID: <CAOMZO5Axfa0yLtfk-KAaxr40XkuMxMS8Qzf2-JyP9R5PN8PMvQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.11 05/67] can: flexcan: add CAN wakeup function
 for i.MX8QM
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sasha,

On Wed, Feb 24, 2021 at 10:35 PM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Joakim Zhang <qiangqing.zhang@nxp.com>
>
> [ Upstream commit 812f0116c66a3ebaf0b6062226aa85574dd79f67 ]
>
> The System Controller Firmware (SCFW) is a low-level system function
> which runs on a dedicated Cortex-M core to provide power, clock, and
> resource management. It exists on some i.MX8 processors. e.g. i.MX8QM
> (QM, QP), and i.MX8QX (QXP, DX). SCU driver manages the IPC interface
> between host CPU and the SCU firmware running on M4.
>
> For i.MX8QM, stop mode request is controlled by System Controller Unit(SCU)
> firmware, this patch introduces FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW quirk
> for this function.
>
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> Link: https://lore.kernel.org/r/20201106105627.31061-6-qiangqing.zhang@nxp.com
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This is adding a new feature and not fixing a bug.

Why does it qualify for stable inclusion?
