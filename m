Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D312D124C
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 14:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgLGNjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 08:39:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbgLGNjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 08:39:54 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A1BC0613D0;
        Mon,  7 Dec 2020 05:39:14 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id s30so18105175lfc.4;
        Mon, 07 Dec 2020 05:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=haYuw1U4BccfG85AJy6UKy/JEpo0rY/0T3AlACW5eW4=;
        b=lceDpgpB9ECdPjkXDCjqSD76y2sf7IL7RnMhU+Ifuy7i3KpyVwh2imPRzT0C+BgeYg
         /iiQm7H6G7jPx9csy3+70wnE1XutohYO7T4sQ08F1D8U0DB7yhYSDTTNKhE0ucw3OafR
         2Kl0Kr1g7qI6+yNQEIuz/TprMqtZ0S/HhLi9Ezv61z+GSOn2Q2V3IUZR+Hq+1NxZ+qjI
         VY8JlFUYxk3S0Hmg14AN6rxEleYI2P+KJILLG6iAWF9GYi6bySFK3jNPYu1lTQjc4+0R
         uFtcwq+GmqHAo4D7Pnk0YS6NqvVFuz+MYbuNbGEaRWc1EkObGXQXAbE0fctyr+/jQoaR
         iD2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=haYuw1U4BccfG85AJy6UKy/JEpo0rY/0T3AlACW5eW4=;
        b=AFeUW+4WaF0s4RL1BezdUcJjZPNVqrnJa67vFX0g5eRnugoh0JNtLd0sa0UpRqpRQM
         WKI8IWFpUCY7sypyc6rdzjvkF9xn9ckFz0sd5H9r4ZqPXaIqHUIQABjCkVtdSIot0BAp
         tUarrCTsU5K+d7mvRzD2OpjON/jNc2e2LMC4TRQwFKiGd+lOBmbVkUMaupzXsi2yJ5WZ
         4yMOaJWo7VtGxJGSy1qwuZsHjNUPo1k0gkpdGOWRIQAgw8OtlMNgvbPKSy1brYV8upDa
         1TMBrqLCf+lPFceWxYvVDPtzESYz4WE/Aaxx9T4PYe7MoIQmycvZVFD8vi0TTMpRK4nW
         ULAg==
X-Gm-Message-State: AOAM533t8hf2lXJuC8ExnJIzoZPLRnUsMR0pQrCrQfj7upiw6iScpEKu
        ohRjeecSEt2us970BsqDiMm8klbCKhRDl35fXZiohfLXdQM=
X-Google-Smtp-Source: ABdhPJwoN1WM78qhNmeSV1jQdAIJRuuMdGsVjs9ehZ8oLCLbit/50ecVgvmX0kPu1ATZkmyjnG387KSnFyzc3iJpyDA=
X-Received: by 2002:a19:384d:: with SMTP id d13mr5444839lfj.548.1607348352610;
 Mon, 07 Dec 2020 05:39:12 -0800 (PST)
MIME-Version: 1.0
References: <20201207113827.2902-1-bongsu.jeon@samsung.com> <20201207115147.GA26206@kozik-lap>
In-Reply-To: <20201207115147.GA26206@kozik-lap>
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
Date:   Mon, 7 Dec 2020 22:39:01 +0900
Message-ID: <CACwDmQDHXwqzmUE_jEmPcJnCcPrzn=7qT=4rp1MF3s30OM7uTQ@mail.gmail.com>
Subject: Re: [PATCH net-next] nfc: s3fwrn5: Change irqflags
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 7, 2020 at 8:51 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On Mon, Dec 07, 2020 at 08:38:27PM +0900, Bongsu Jeon wrote:
> > From: Bongsu Jeon <bongsu.jeon@samsung.com>
> >
> > change irqflags from IRQF_TRIGGER_HIGH to IRQF_TRIGGER_RISING for stable
> > Samsung's nfc interrupt handling.
>
> 1. Describe in commit title/subject the change. Just a word "change irqflags" is
>    not enough.
>
Ok. I'll update it.

> 2. Describe in commit message what you are trying to fix. Before was not
>    stable? The "for stable interrupt handling" is a little bit vauge.
>
Usually, Samsung's NFC Firmware sends an i2c frame as below.

1. NFC Firmware sets the gpio(interrupt pin) high when there is an i2c
frame to send.
2. If the CPU's I2C master has received the i2c frame, NFC F/W sets
the gpio low.

NFC driver's i2c interrupt handler would be called in the abnormal case
as the NFC F/W task of number 2 is delayed because of other high
priority tasks.
In that case, NFC driver will try to receive the i2c frame but there
isn't any i2c frame
to send in NFC. It would cause an I2C communication problem.
This case would hardly happen.
But, I changed the interrupt as a defense code.
If Driver uses the TRIGGER_RISING not LEVEL trigger, there would be no problem
even if the NFC F/W task is delayed.

> 3. This is contradictory to the bindings and current DTS. I think the
>    driver should not force the specific trigger type because I could
>    imagine some configuration that the actual interrupt to the CPU is
>    routed differently.
>
>    Instead, how about removing the trigger flags here and fixing the DTS
>    and bindings example?
>

As I mentioned before,
I changed this code because of Samsung NFC's I2C Communication way.
So, I think that it is okay for the nfc driver to force the specific
trigger type( EDGE_RISING).

What do you think about it?

> Best regards,
> Krzysztof
>
> >
> > Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> > ---
> >  drivers/nfc/s3fwrn5/i2c.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
> > index e1bdde105f24..016f6b6df849 100644
> > --- a/drivers/nfc/s3fwrn5/i2c.c
> > +++ b/drivers/nfc/s3fwrn5/i2c.c
> > @@ -213,7 +213,7 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
> >               return ret;
> >
> >       ret = devm_request_threaded_irq(&client->dev, phy->i2c_dev->irq, NULL,
> > -             s3fwrn5_i2c_irq_thread_fn, IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
> > +             s3fwrn5_i2c_irq_thread_fn, IRQF_TRIGGER_RISING | IRQF_ONESHOT,
> >               S3FWRN5_I2C_DRIVER_NAME, phy);
> >       if (ret)
> >               s3fwrn5_remove(phy->common.ndev);
> > --
> > 2.17.1
> >
