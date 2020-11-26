Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFC632C5DFC
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 23:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388266AbgKZWxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 17:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgKZWxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 17:53:44 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F12C0613D4;
        Thu, 26 Nov 2020 14:53:44 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id 10so2849058ybx.9;
        Thu, 26 Nov 2020 14:53:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xyAGZbF2XZTc0HZSbh/ZZVibzXOl/zvLgv9c2CTS+3Y=;
        b=EtNZ0loCIigTeQVF78AVeynbc/Y/JNxjuka9KZlczsavXPTW0PTEp1Jio6eaOKkp8z
         FLP4+3hacF1TNRxsAsU8qvaPt5/N7J1aPDHSJ7dtihrjF9FuxH/ZMRajOPEAsWF+4mJC
         pmTeS3+sHt7RXA0Yo5LjbMN3RIQv5YOZWwdKIlNt1MkN2En1ewueQv/jKIQaqWT93+GE
         EnCyB1uFMGao6fsJsTbID+xIB61ACd2p2e55c6ZfvH/53kzGiX+6Bxi424bfLce61Hcj
         qY8dDIm0DHQC4cdo0njYP+MgN+vSYNad18CSMGoN7wQzS/0fxzRx9ReHhrK+/or8mxbt
         0pAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xyAGZbF2XZTc0HZSbh/ZZVibzXOl/zvLgv9c2CTS+3Y=;
        b=eWsHgrXovPPFUXrTLcM6mX2EDwFZ8m/ebgXw4LQsWXADGNJTeJFohwX8Gv2c5zfYSl
         IkdldYvpU/8CDMO0tdzEZUZ1watXhaKeViSERPW7eD9wd89jMb47vnqMc08GpNpMAObD
         vwo3QsxbtCp77itiTR7FPJ7aEqlFiCw6DH1YMVCRjesWp8/Kp9VWgBNiF1CXhWC44xyB
         Kz5oy87yZMfN+AE1lblcj+/X8ihiZwjuZEtABXV7V7KZH/zz2/w4e1nTpLNcQ+KdWSpr
         17ObOebcaHZC2xqXm3R7jY1qe0uaxXlv8vXhGTur80VM9k8YFTQ8dSZbqzg+KIE8uDAL
         S3kg==
X-Gm-Message-State: AOAM532p2Dj0n1yYim2UdCTV5tG0gWe1OP+v/kBKHcjiTKHJYhx2hIH6
        C9b3BZRS6ZhogL3baNPQMVlm+Hs6OqRa0bDVXI0=
X-Google-Smtp-Source: ABdhPJyhJ5+tv2mOKm8kcz0QECU0AZeGyP9PGIQezzDWUDyeZSc9LIYsmx7ZevwA+GrTLQBaV5OfBQ9LpZEuegGd8mA=
X-Received: by 2002:a25:cad2:: with SMTP id a201mr6900779ybg.327.1606431223367;
 Thu, 26 Nov 2020 14:53:43 -0800 (PST)
MIME-Version: 1.0
References: <1606404819-30647-1-git-send-email-bongsu.jeon@samsung.com> <20201126170154.GA4978@kozik-lap>
In-Reply-To: <20201126170154.GA4978@kozik-lap>
From:   Bongsu Jeon <bs.jeon87@gmail.com>
Date:   Fri, 27 Nov 2020 07:53:32 +0900
Message-ID: <CAEx-X7esGyZ2QiTGbE1H7M7z1dqT47awmqrOtN+p0FbwtwfPOg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] nfc: s3fwrn5: use signed integer for parsing
 GPIO numbers
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Bongsu Jeon <bongsu.jeon2@gmail.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 27, 2020 at 2:06 AM Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On Fri, Nov 27, 2020 at 12:33:37AM +0900, bongsu.jeon2@gmail.com wrote:
> > From: Krzysztof Kozlowski <krzk@kernel.org>
> >
> > GPIOs - as returned by of_get_named_gpio() and used by the gpiolib - are
> > signed integers, where negative number indicates error.  The return
> > value of of_get_named_gpio() should not be assigned to an unsigned int
> > because in case of !CONFIG_GPIOLIB such number would be a valid GPIO.
> >
> > Fixes: c04c674fadeb ("nfc: s3fwrn5: Add driver for Samsung S3FWRN5 NFC Chip")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
>
> Why do you send my patch?
>

I think that your patch should be applied before refactoring for this driver.
So, I applied your patch to net-next branch and included your patch at
my patch list.
Is this the wrong process?

> Best regards,
> Krzysztof
