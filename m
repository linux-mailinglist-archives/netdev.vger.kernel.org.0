Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4E244A332
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 16:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbfFROAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 10:00:53 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:41642 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729485AbfFROAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 10:00:53 -0400
Received: by mail-lf1-f66.google.com with SMTP id 136so9361964lfa.8
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 07:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HdUV7CzfBMqln17zR8zkIO3XNGBpw5OXNtAwnyi4zUU=;
        b=YKASZiZLPnCBby55M8HxvQ3P6hVicwek4YaqtAI8cITJMo4iBFAWa3Yij9dIdVNJQH
         DG1Y36EZ8g1RlQ36fuSZZlWJEos08p8a8NGCJ4ePwoJ/iuXCxhpGJk/5ImxWt9stwQa3
         yzSilSFRMmJXjChN9LX5EyZvKJu7NVi+g7+QVmSVxVxmE9hUq/fjv8eT20WOZ2CX6Gy1
         k+gKh2jDh1GJYeEQ804FDN2kPBVAKd0Ajibuja7XLyFwf9lbnePWZmNBToWcISiz5mD+
         aKQGxa3de+sSqrZXCcZkixnJCx3Go6nC+1fUrTBqDcbfKELH20imaBLJDuj2IuYSDZwJ
         9DLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HdUV7CzfBMqln17zR8zkIO3XNGBpw5OXNtAwnyi4zUU=;
        b=ipEZcwbedkXeQ8qQmzjCZcGMKLMv8kMAhjvdgOg/tjClcdprLGrFsMh+a8DwdXa/uX
         cHqSzdIJnWdCeihfSQiqY+qI4QYyQyasEN3nj3mEZ43Fm+/eH+NnJIE8DycM8aGvV8cW
         juTfS3X3JcAt6oiROkKouLrvZH7azYJnWAmkBmGsfQjKWqc4Pl47bBDXtm3MZ4/IbHD8
         wnc7Q+ptgQs2LHzQhODWV/cmiH0lUFXG+KqS361obWCq4IpzWWIRZ8vkFs59F0xmJBbX
         a9Uui1ENckKKHXr4/0dKs7BKW6qmBCnC6MaxPChq+mL2wHTMPS4XisK5P0bDIhUIxdKB
         WEXg==
X-Gm-Message-State: APjAAAVmota9+Of3ndSoM3cxs22tfBMHQz6jV2YV/FB4RN0HMHv8ZS9P
        KAwbL5Hcm1STm62KDG0j926A3a3IyEzzQhS/KfQAyA==
X-Google-Smtp-Source: APXvYqxZtj/5LSylMWRwAm5XoxiotJGXmZeOzoZYzvkHtOk3c+tM2Kf0qCRtTO0+6PRAgESjaawSeSGiHoL4zjd1R1U=
X-Received: by 2002:ac2:5382:: with SMTP id g2mr2936130lfh.92.1560866450515;
 Tue, 18 Jun 2019 07:00:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190615100932.27101-1-martin.blumenstingl@googlemail.com> <20190615100932.27101-4-martin.blumenstingl@googlemail.com>
In-Reply-To: <20190615100932.27101-4-martin.blumenstingl@googlemail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 18 Jun 2019 16:00:39 +0200
Message-ID: <CACRpkdZ8vY918mzaJyX38gENJtoA_KJq3RLGxVObdQjLKXULSQ@mail.gmail.com>
Subject: Re: [PATCH net-next v1 3/5] net: stmmac: drop the reset GPIO from
 struct stmmac_mdio_bus_data
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Giuseppe CAVALLARO <peppe.cavallaro@st.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 15, 2019 at 12:09 PM Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:

> No platform uses the "reset_gpio" field from stmmac_mdio_bus_data
> anymore. Drop it so we don't get any new consumers either.
>
> Plain GPIO numbers are being deprecated in favor of GPIO descriptors. If
> needed any new non-OF platform can add a GPIO descriptor lookup table.
> devm_gpiod_get_optional() will find the GPIO in that case.
>
> Suggested-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
