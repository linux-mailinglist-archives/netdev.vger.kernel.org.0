Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0934E63AA7
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 20:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbfGISSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 14:18:18 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:36910 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727315AbfGISSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 14:18:17 -0400
Received: by mail-ot1-f68.google.com with SMTP id s20so20905204otp.4
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 11:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jlhZmfre9KHr9WOFHDQfgWnq1R08I0SY653B8NdhfuI=;
        b=PZGi73+DezJq6tXQnUCQDoHP61gXCKgXF+pZ7BK3BWrRJfH9uU5yVoTVIjH92j0JcT
         lSAhuu9O8whiAqxxh4boOKIFKAhzFAqm7wTu5glY1nz5fjz1DiuRPuDv38V7Bx4gjq+o
         Sjw5MUGZST33gFL1yvPdLOTD+lVJ6XhXHCzcaaIHwuJLIl74MUjGMsrgae0aawoe90m8
         AYmk+ai8LsbMhWyIc/kQX5+SagiqN0oq2QpmnD/JcLtfel80jTnSY4C2ZsdtFbSqkQwX
         k1UphaVY9++2RVgLT/nARAN2vmp4/hsJktr9DPruCBGQYAtV9oovsjjCjzi5yiZ4nd/6
         LYXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jlhZmfre9KHr9WOFHDQfgWnq1R08I0SY653B8NdhfuI=;
        b=LVwFoa6rTLuOoqbuQAuay2wagoCc9iqFuRIi5sGZkcKyG0W9WezFOBOnnN5i72kuvh
         H8Ef8QvcQ/uS+rhRu0Y/ESDteiqYVRbAcAlHnlHI+GW+VxGb8zjb6EVmQzKFjsAgfS60
         1B3Qbma8ib6zs2iJ4poejB0RWa7+cOWlkhbl4lRkvYhcB8TbPBlizAVr1+pap/kw3/H/
         jdeggAhjKrDEP05IVpV0DyKUxVc86qf6Kujhq5AnNiAvF0aPuf889eqqs1XJUlhlrfYO
         pWcnywJHEJu6rucpnsZ3VU5EMpNeV8pcEsZvfeq2BCkefEJWi+kczppp4/RVcjzRXWs9
         ioxA==
X-Gm-Message-State: APjAAAWAbMDZGImsEk85y4N54OU9VsqaA7WjYyv3TdrgD23YbELwgCwr
        NKuNvCR5zM4pDV6obfUNeYrZu77uwqpq9SM6eZ9qOku0
X-Google-Smtp-Source: APXvYqzlADKfrFovHEGleiZNTfzRJTxqzjCXz9u08jeNZc0Kn1KS27q44lwYA3f+SQT25KaB9xhBaGJNDLobIK6+BjQ=
X-Received: by 2002:a9d:7352:: with SMTP id l18mr20818459otk.292.1562696296559;
 Tue, 09 Jul 2019 11:18:16 -0700 (PDT)
MIME-Version: 1.0
References: <201907081633.62bX7tN5%lkp@intel.com>
In-Reply-To: <201907081633.62bX7tN5%lkp@intel.com>
From:   Christian Lamparter <chunkeey@gmail.com>
Date:   Tue, 9 Jul 2019 20:17:59 +0200
Message-ID: <CAAd0S9ALjV+miN1MDaV=QeN6hHYc9TvZ4mAttp3w12n-HhR8+A@mail.gmail.com>
Subject: Re: [net-next:master 342/422] drivers/net/dsa/qca8k.c:1050:21: error:
 implicit declaration of function 'devm_gpiod_get_optional'; did you mean 'devm_gpio_request_one'?
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@01.org, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(let's hope that the gmail web interface doesn't mangle this too much)

On Mon, Jul 8, 2019 at 10:16 AM kbuild test robot <lkp@intel.com> wrote:
>
> tree:   https://kernel.googlesource.com/pub/scm/linux/kernel/git/davem/net-next.git master
> head:   61a582be1a668a0c1407a46f779965bfeff88784
> commit: a653f2f538f9d3e2d1f1445f74a47bfdace85c2e [342/422] net: dsa: qca8k: introduce reset via gpio feature
> config: x86_64-randconfig-s2-07081539 (attached as .config)
> compiler: gcc-7 (Debian 7.4.0-9) 7.4.0
> reproduce:
>         git checkout a653f2f538f9d3e2d1f1445f74a47bfdace85c2e
>         # save the attached .config to linux build tree
>         make ARCH=x86_64
>
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    drivers/net/dsa/qca8k.c: In function 'qca8k_sw_probe':
> >> drivers/net/dsa/qca8k.c:1050:21: error: implicit declaration of function 'devm_gpiod_get_optional'; did you mean 'devm_gpio_request_one'? [-Werror=implicit-function-declaration]
>      priv->reset_gpio = devm_gpiod_get_optional(priv->dev, "reset",
>                         ^~~~~~~~~~~~~~~~~~~~~~~
>                         devm_gpio_request_one
> >> drivers/net/dsa/qca8k.c:1051:10: error: 'GPIOD_ASIS' undeclared (first use in this function); did you mean 'GPIOF_IN'?
>              GPIOD_ASIS);
>              ^~~~~~~~~~
>              GPIOF_IN
>    drivers/net/dsa/qca8k.c:1051:10: note: each undeclared identifier is reported only once for each function it appears in
> >> drivers/net/dsa/qca8k.c:1056:3: error: implicit declaration of function 'gpiod_set_value_cansleep'; did you mean 'gpio_set_value_cansleep'? [-Werror=implicit-function-declaration]
>       gpiod_set_value_cansleep(priv->reset_gpio, 1);
>       ^~~~~~~~~~~~~~~~~~~~~~~~
>       gpio_set_value_cansleep
>    cc1: some warnings being treated as errors
>
> vim +1050 drivers/net/dsa/qca8k.c

Ok, I think that just the

#include <linux/gpio/consumer.h>

is needed. I can make a patch for this no issue. I'll download
net-next over the next days
(currently I'm just on a 3G/EDGE connection, so the 1.53 GiB will have
to wait until the
weekend.)

Regards,
Christian
