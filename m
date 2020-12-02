Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299742CC974
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 23:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgLBWST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 17:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgLBWST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 17:18:19 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C119C0613D6;
        Wed,  2 Dec 2020 14:17:17 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id d20so7164469lfe.11;
        Wed, 02 Dec 2020 14:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+8RFjtKUiIjNnb5VO+rcGuBrmv97T7eSoiGm8pbdxuA=;
        b=kPH0A5Lwx1OV8ztUGsOh6sE0boMbEMNwgz+Z54Ddw27NRYo7je4wvbFtPgDXgMMuW9
         eoUpmYf6rCiWkn/RfpGWeroVmoTagqbxoYw9Od0ombcCsthN41c9Q1F6Ap8LG0m9fpZg
         00gmtsAua5pz9UVZvbomNnW8zOJVCh11vH3/lMWz7Vbl8SQEIu2gvTMovNL/OnJB5zWo
         LBHS4fHI3tTug8HuTMglpIaQb4VFC3mxUuGhVht+B8QU+WqiJ5Hqz98HhWN45qOCz9Nk
         mX8FHgBvH/ny9ulomdvwDKQEAmpQcrrwWVq0jmuEFbuC9g4vLwB4uPx7eFUwztDy127n
         rU4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+8RFjtKUiIjNnb5VO+rcGuBrmv97T7eSoiGm8pbdxuA=;
        b=OGz9BiAXKr9+cVYrW2Rvg+OnL5IuJE0M4nOqE7tmqwsO8wYsYl0ZSyXMLarbYCVFLM
         2nAoynLpYlVm/PVUerDaZ4Ki2y+lbn2M0mEvdgbMC8H4gOFpBFWpqldxPVPsqCB1uhLe
         zpzpxA4ddG4Lpk29lWuO32yl7Fo9EC5dNycEoycMF9mUt0y6sMWKyw2Vtf46Tzn5xDyZ
         sRa9diC2lyg0v+GsYHzwwl6GLY1zUFv9H+5ubIVOZsXKX5RuRL0FJDV+Zun/y7x2PAQo
         e1i/RzFUvOl+VK20pCymsfQ9bhIP4pafXF48BQDlydWUUuotwghwMib+owJePy20dW2G
         mtDg==
X-Gm-Message-State: AOAM532BBD+pDlmFzxUxp5C+VK6W/jlBvdicte0ANXkl9AZ4jy0gVm3z
        y0k6vpnAdsj/31SS7UIVe7DnQwqdofRfnZP2jM+FNsautls=
X-Google-Smtp-Source: ABdhPJzXPlem96N8CGl+5TGHZdaobIpGTmbeYXJ8t4Vz46E3a44IVnJ1GfUmsaQtj0yryhT0CNzM53/t86XIaLdhfqk=
X-Received: by 2002:ac2:5e91:: with SMTP id b17mr82021lfq.442.1606947410190;
 Wed, 02 Dec 2020 14:16:50 -0800 (PST)
MIME-Version: 1.0
References: <1606909661-3814-1-git-send-email-bongsu.jeon@samsung.com>
 <1606909661-3814-2-git-send-email-bongsu.jeon@samsung.com> <20201202171638.GA2778@kozik-lap>
In-Reply-To: <20201202171638.GA2778@kozik-lap>
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
Date:   Thu, 3 Dec 2020 07:16:38 +0900
Message-ID: <CACwDmQD8dFCd2u=BnL8VrzQ=NuPYA9z44uBJsKSaUN5yR4R8Mw@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 1/4] dt-bindings: net: nfc: s3fwrn5: Support a
 UART interface
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 3, 2020 at 2:16 AM Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On Wed, Dec 02, 2020 at 08:47:38PM +0900, Bongsu Jeon wrote:
> > From: Bongsu Jeon <bongsu.jeon@samsung.com>
> >
> > Since S3FWRN82 NFC Chip, The UART interface can be used.
> > S3FWRN82 supports I2C and UART interface.
> >
> > Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> > ---
> >  .../bindings/net/nfc/samsung,s3fwrn5.yaml          | 31 +++++++++++++++++++---
> >  1 file changed, 28 insertions(+), 3 deletions(-)
> >
>
> Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
>
> Best regards,
> Krzysztof

Thanks a lot for advising and reviewing my patches.
