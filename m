Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31189479836
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 03:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbhLRCmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 21:42:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbhLRCmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 21:42:02 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3557FC061574
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 18:42:02 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id t19so6417609oij.1
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 18:42:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=O4bkZtAogb1N7n7U8/nfqUv5uVHGYTOshcCRiPCxQSk=;
        b=AUf04BLca73HwFCsl4G4rGsQY8QXKqttuSrrXkLZ5p7NHAwrQj/cW2WRzGik9qBsL4
         i4WYeg7FDWWqBXApcDUbZHDGT0iiPhrA3IrhswdQpispiNik+zVmhLEPgaTMiDaaALhN
         oT9yo9x/IdEWw1O7ZUHRXzKtFGJ1OOOzBOpCRAQotkVdKgq/sBko77qKfmwH3hVaDfJS
         dRZGqUeQkC68tjClQpWYymOc2bR6zAWFGs+ocYfvpANr6ttdtfFL0PRu9SKj6Lvw6hKb
         APg/7OxZp7OXQK+EmzDUXqaUcfORSxIHXf+Lr7wTLPHSEscis/8kP0jAickIRmjJHyR8
         5D1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=O4bkZtAogb1N7n7U8/nfqUv5uVHGYTOshcCRiPCxQSk=;
        b=Hf4tqaJHKTF28QGrPljRaN2ObdpO8Lkhi7XXU1QTCVVppGyr4TSfWbkj2WRWVnbj9S
         ZKWiP+hCnZ1rG6pJ7xfRygQhtuKkoaIR8Em2VYSMZ6spf9tgM8zsITpJ4L0/oUYkeU2z
         PTUfNiTi6fOLuoV9G8HIb0N+kX6pu7sfC0Ub2d143dABhNzUC8QClCaSRNOOruz4fdXn
         fBSUlvPJ092U3/nXrdx04nTlfSRthmh7MDqEYrPvgvAcqeuMJcV2ZTFdvJawjA1D2kJE
         394bjGUdn1vnWeFJtVti6E7n/v4t9c/XNhoQ5PwLxAmeuWiqQFyA4ghIRXvy0dy7i+Uv
         2OxQ==
X-Gm-Message-State: AOAM531MnCyjCcg7Nwcjv4qpUz4Cdx0/KPMSYJ7OxfBbuQ173DKF7Hly
        J3VLf/MGz4fevJTf9ltrQL7mNtJi2uP/QbE+3DShkA==
X-Google-Smtp-Source: ABdhPJzxU+9N+AuxebOaZ5H+RckYUodnXVl5sE/nEM2qHvx45Q3DXEqMTVgspwCgYieCPo9pJB4Xjp9NyQUBOovwdNE=
X-Received: by 2002:a54:4791:: with SMTP id o17mr4535177oic.114.1639795321596;
 Fri, 17 Dec 2021 18:42:01 -0800 (PST)
MIME-Version: 1.0
References: <20211216201342.25587-1-luizluca@gmail.com> <20211216201342.25587-3-luizluca@gmail.com>
In-Reply-To: <20211216201342.25587-3-luizluca@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sat, 18 Dec 2021 03:41:50 +0100
Message-ID: <CACRpkdbyh9pgLzVLsBz1Q-pfPkvd7xK_WbuippCMBHaFviv_-g@mail.gmail.com>
Subject: Re: [PATCH net-next 02/13] net: dsa: realtek-smi: move to subdirectory
To:     luizluca@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, ALSI@bang-olufsen.dk,
        arinc.unal@arinc9.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 9:14 PM <luizluca@gmail.com> wrote:

> From: Luiz Angelo Daros de Luca <luizluca@gmail.com>
>
> Tested-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
