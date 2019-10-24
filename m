Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCC8E3184
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 13:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439480AbfJXLxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 07:53:05 -0400
Received: from mail-ua1-f65.google.com ([209.85.222.65]:36533 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439472AbfJXLxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 07:53:04 -0400
Received: by mail-ua1-f65.google.com with SMTP id r25so7050682uam.3
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 04:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q1KiAq2b3z/Z+oO2kUL2b8SkIvQVsNiMUo4648osU6s=;
        b=CPG7f8FL9wOLdK9nhKnhAgR/LLHSeGiIsfemayzM3YOM8k9DvqtDznLrnrK5HaZW34
         WuJ1PDvb7d3Atvp9n5QVciTPz2djxe8E5PYkMZFxeBtYzoQxasezhAivF80vRCYjuHDZ
         Oau45TlDXKUS+xiX+T3OVtKal/X3GH/4RwyLNj5iE5M1lvnSC+E/3fz0ofEtGdT5ZGu6
         Ez+BoOyCsGvk4IMmxp4ga/qiVxvLNNl4q4ERovcOQA+hKf6aBIwFxpf8qZ28vRRpUUcx
         5PaAzGBUbmh+gBHzmGOfXNjEUs/4TTi4rIM3bnGsP0DOTkMj3OcheKRC/H7By+liQp7Y
         m8Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q1KiAq2b3z/Z+oO2kUL2b8SkIvQVsNiMUo4648osU6s=;
        b=F/3a1YtreKopDrl7eZoX4CkMqX6TxR43F3O1Uif6lXZ5A/LWuP7sfhb7HuotaWqWVc
         4YuLviawAuX5jKDNTLhCqaf/1lSE7Taliydg5LZd3vQqq7OPXtwAvOWsWooV7C03hxNk
         D9aewPU4ZIDcIUY2uBCGMKnbZd2yZp/XSandc4eHA9TgIDTJUp+CjnV5C7LUmCZqRcvO
         JCvTQSCsoE4DPxB2fr7XctP7qtCfGguDRF/DlLWp3ebHAPHi6FXgLo6jhWa67/e+Amzy
         QC1mPLiB8Q3ZeVl7DuZzi5rkUKKAEv3mswktyDnhn6xvL8BkHywNm6StJ2JpkECNxtom
         2CzA==
X-Gm-Message-State: APjAAAVQnA/yEpHKb5DgsW85cdSv24dPvFO7cOncR68lmiF/YzvEPj/I
        qHp029RR5OWxQulobSIg86YoO6hdjnpQqKrf+3EIWw==
X-Google-Smtp-Source: APXvYqyY6iH8uNxzgTDilZDyz8IFIHovN0BIzfSE7mUMD+SKYWqS0pz2SdLZyWU+lC9L/MycjWutzQj5TgAf2o9qcso=
X-Received: by 2002:ab0:7043:: with SMTP id v3mr8383913ual.84.1571917983366;
 Thu, 24 Oct 2019 04:53:03 -0700 (PDT)
MIME-Version: 1.0
References: <20191023152634.GA3749@nishad>
In-Reply-To: <20191023152634.GA3749@nishad>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 24 Oct 2019 13:52:52 +0200
Message-ID: <CACRpkdYmE9uQOJzxHBjcFa1mwr6t1G5FJ_fE2aSdKJB1fxEhsg@mail.gmail.com>
Subject: Re: [PATCH] net: ethernet: Use the correct style for SPDX License Identifier
To:     Nishad Kamdar <nishadkamdar@gmail.com>
Cc:     Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 5:26 PM Nishad Kamdar <nishadkamdar@gmail.com> wrote:

> This patch corrects the SPDX License Identifier style in
> header file related to ethernet driver for Cortina Gemini
> devices. For C header files Documentation/process/license-rules.rst
> mandates C-like comments (opposed to C source files where
> C++ style should be used)
>
> Changes made by using a script provided by Joe Perches here:
> https://lkml.org/lkml/2019/2/7/46.
>
> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
