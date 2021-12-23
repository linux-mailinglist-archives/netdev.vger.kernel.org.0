Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A078447E1AF
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 11:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347737AbhLWKqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 05:46:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243211AbhLWKqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 05:46:18 -0500
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F631C061401;
        Thu, 23 Dec 2021 02:46:17 -0800 (PST)
Received: by mail-vk1-xa2f.google.com with SMTP id u198so2955731vkb.13;
        Thu, 23 Dec 2021 02:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=udkI7QMUeDrVioHXKLugL+N72UQFHAQI9ILWskSEf2E=;
        b=Rc0SRinyGXdlYdn0ZVN1Y935n9Dl1CIaD+7eWT3czQueDH2PxPcw7Uzxzct7gYF/4A
         y3ptI26CJIsKq39UAQ9i96cwBKuYYMz/Dy6RrWXmvke/LljlZ3qT4wFhIqq3JZWQnhGS
         dwjsBKFfTeCzBYryc5wT1bYHeFJmcMOmBWPXJ6kn3Vo/8x2epHuIHkhdRwdhPhdfs/vl
         kEpwmjeTNo81kA53aIebSZPVYIQA7p3feT3mklXBlrYSOpcEuMS6/L0hgqkGrWWIiV89
         q+wTTueB9O2Mu9tKIboe6XZhOEj7zqkKEy0/ITGkGp/yT1CdUIAvNv9GO8krPdPXrhT+
         QlTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=udkI7QMUeDrVioHXKLugL+N72UQFHAQI9ILWskSEf2E=;
        b=7JpswZShdSWk54sILSLwCx96O9BFdP0dn5x4yLUzLkQ4LA2ET9N6ue9ewUYSua297T
         ta5ZQy91egiopWFip2GTTdxMqlEkdwNgwKOPbJ8JYxChzd3/DUH0u4JVnJv8Egh7N0F2
         VDbhxGwkhe/SZbU8pLtNob++BO2NrCCxAseC1RrY6QaKCX/zphvMrV6DM1By6OwqFNCN
         6oUQCrI6V1bwpxFuP6BaE2VcfcKoKx23ZVyeAzeI8SCKtltxODBZW6JmwvZzCCyjM/3o
         tlvBZOkAc/AclAU8CtOvm2s6YNBe+/5eKwmynCySnrbFWE21SwR/RvVIy5pDGrBXyg8h
         XJfQ==
X-Gm-Message-State: AOAM531YLZ8FFqwlmzKiDl7Myz4CJyeDS9w9bk1AGTr36lakz4+/kHh2
        yDcPBWmg8yvhFeaVy06IGhhDWuoPeqrqm0MXBJ4=
X-Google-Smtp-Source: ABdhPJwFv+t2sLKF20hGj3tcSWKJno8hh4couorNtGMG0CPg4D7X9f5hsSO1PYZ2XzpeJ0JpICQEs+iw/Yeyu2ejeBc=
X-Received: by 2002:ac5:c395:: with SMTP id s21mr570745vkk.3.1640256376693;
 Thu, 23 Dec 2021 02:46:16 -0800 (PST)
MIME-Version: 1.0
References: <20211222163256.66270-1-andriy.shevchenko@linux.intel.com>
 <CAHNKnsS_1fQh1UL-VX0kXfDp_umMtfSnDwJXWxiBXFdyrK1pYA@mail.gmail.com>
 <YcRL8Ttxm8yMj77U@smile.fi.intel.com> <YcRMlp6ux+R0op3Q@smile.fi.intel.com>
In-Reply-To: <YcRMlp6ux+R0op3Q@smile.fi.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Thu, 23 Dec 2021 13:46:05 +0300
Message-ID: <CAHNKnsSuo52J0Az_fNfRUj6P8CCZMWm+SVkYjoik_Py74N6Yzg@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] wwan: Replace kernel.h with the necessary inclusions
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 23, 2021 at 1:18 PM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On Thu, Dec 23, 2021 at 12:14:09PM +0200, Andy Shevchenko wrote:
>> On Wed, Dec 22, 2021 at 11:38:44PM +0300, Sergey Ryazanov wrote:
>>> On Wed, Dec 22, 2021 at 7:32 PM Andy Shevchenko
>>> <andriy.shevchenko@linux.intel.com> wrote:
>
> ...
>
>> Not sure what it's supposed from me to do. The forward declarations are
>> the tighten part of the cleanup (*) and it's exactly what is happening h=
ere,
>> i.e.  replacing kernel.h "with the list of what is really being used".
>>
>> *) Either you need a header, or you need a forward declaration, or rely =
on
>>    the compiler not to be so strict. I prefer the second option out of t=
hree.
>
> Ah, seems indeed the skbuf and netdevice ones can be split. Do you want m=
e to
> resend as series of two?

No. The single patch cleanup looks pretty good.

It might be worth pointing out in the commit message that the other
included headers were removed as they indirectly include the kernel.h
header. This will be helpful for future readers. But I don=E2=80=99t think
such a comment is worth a patch update. So I am Ok if this patch will
be applied as is.

> (Sorry I have sent many similar changes and haven't remembered by heart w=
here
>  I did what exactly, but here it looks natural to cleanup that stuff at t=
he
>  same time, so the question is if it should be a separate change or not)

The patch looks good. Thank you for this hard cleanup work!

--=20
Sergey
