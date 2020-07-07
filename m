Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35C19217852
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 21:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728696AbgGGTwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 15:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726951AbgGGTwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 15:52:14 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE32C061755;
        Tue,  7 Jul 2020 12:52:14 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id d18so2412842ion.0;
        Tue, 07 Jul 2020 12:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0Cspl6RQza0BoSmE5XXIXy/+J4esPE2BdRB9cMVQHRY=;
        b=G4POi9w8Qq0IGizNb7ryCd4o0A1m/mKhcPpW+MPVzcB5AqQMqFZOZtvcrjTx1ZC6NZ
         IHSOP0iTG0JhubvRBG4VEfwfjNtaAWwFZSntwZZOeLVByAPR0Qar4rugJzW4h4WVU4zm
         K4jIxmQJrKM7wya5lZTvHwBpwDLgcHBrT4KUcGqQ9ft2wh/u2O2a+50OaYZrAVsNXUPX
         Ah+t1cueopn/VXWcyLbwxRK5pY43wwih64BIK8AcE9unuFUsDpt94lkJ0BHpdgFS0ZHu
         7RVJf8qKeYk6GPK2NDihdb/2Ls3GThu3DyFjqeY6VBjV7MyN05IAF5m+x5C3NWv2HJnT
         zbTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0Cspl6RQza0BoSmE5XXIXy/+J4esPE2BdRB9cMVQHRY=;
        b=Azj3JxQNCyM+8QPU/3Jxma21bYwfTkaJgZ/4j8ZY6pfN7QZDY4aQemiyIeLsJ37S0s
         m//5Kmhj7zOVrgkrGoDRVcwrOSRwM9mUPkhm5nS0Wed577XGVh7VT5L4Av7ICMTLGlvl
         hyhtiqVfP2QGUlj649aZFc1wXf3VQvuZIC6Z2EIlyDb1pk9zd7t7tsPtaptGHJC0VE5q
         sELfdBTr5RFZxr9sNMfi83AMlcHNsrtuQ3qziXD70axT0kb3dvR2MTwBoS9e6M4rgyIz
         xiNKTp51oSwmCWAOzK8Ya8pm3rssl5pAsMM8fNQvbRF6jg+3wLx5noQMbUMLoJcCaUQe
         GpLQ==
X-Gm-Message-State: AOAM531e8btTr3TGg1H1aBB7cLHCmGyLYmXan1jEzmUnRyAvRehE6SzE
        FG4N/ezTL7BIfLdEPXWi/r9VdGLcLseP9AQA0hU=
X-Google-Smtp-Source: ABdhPJxpDcMU/6sQeaJ1MKQrqBTwFVPhJ9rzxB93g8MotvV5VkpDFwvRg+1fpk1xkEqPqtgSRUNbSOS+dlN976DVvBc=
X-Received: by 2002:a02:c7cc:: with SMTP id s12mr63300691jao.79.1594151533957;
 Tue, 07 Jul 2020 12:52:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200707012707.13267-1-cphealy@localhost.localdomain> <CAHp75VedcWazv9=KkWXU75SP3giPtBXvyDF3dQbCEETRM5bjaQ@mail.gmail.com>
In-Reply-To: <CAHp75VedcWazv9=KkWXU75SP3giPtBXvyDF3dQbCEETRM5bjaQ@mail.gmail.com>
From:   Chris Healy <cphealy@gmail.com>
Date:   Tue, 7 Jul 2020 12:52:00 -0700
Message-ID: <CAFXsbZr5Yy3kyScVZoNrEYGy9-H76YwQhbXS4cpq45RfqUtgWA@mail.gmail.com>
Subject: Re: [PATCH net-next v3] net: sfp: Unique GPIO interrupt names
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 6, 2020 at 11:52 PM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
>
>
> On Tuesday, July 7, 2020, Chris Healy <cphealy@gmail.com> wrote:
>>
>> From: Chris Healy <cphealy@gmail.com>
>>
>> Dynamically generate a unique GPIO interrupt name, based on the
>> device name and the GPIO name.  For example:
>>
>> 103:          0   sx1503q  12 Edge      sff2-los
>> 104:          0   sx1503q  13 Edge      sff2-tx-fault
>>
>> The sffX indicates the SFP the los and tx-fault are associated with.
>>
>> Signed-off-by: Chris Healy <cphealy@gmail.com>
>>
>> v3:
>> - reverse Christmas tree new variable
>> - fix spaces vs tabs
>> v2:
>> - added net-next to PATCH part of subject line
>> - switched to devm_kasprintf()
>> ---
>>  drivers/net/phy/sfp.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
>> index 73c2969f11a4..7bdfcde98266 100644
>> --- a/drivers/net/phy/sfp.c
>> +++ b/drivers/net/phy/sfp.c
>> @@ -2238,6 +2238,7 @@ static int sfp_probe(struct platform_device *pdev)
>>  {
>>         const struct sff_data *sff;
>>         struct i2c_adapter *i2c;
>> +       char *sfp_irq_name;
>>         struct sfp *sfp;
>>         int err, i;
>>
>> @@ -2349,12 +2350,16 @@ static int sfp_probe(struct platform_device *pdev)
>>                         continue;
>>                 }
>>
>> +               sfp_irq_name = devm_kasprintf(sfp->dev, GFP_KERNEL,
>> +                                             "%s-%s", dev_name(sfp->dev),
>> +                                             gpio_of_names[i]);
>
>
>
> No error check? Why?

Good point.  I will add this.  I see this patch was just applied so
I'll submit a follow on patch to add the appropriate error check.

>
>
>>
>> +
>>                 err = devm_request_threaded_irq(sfp->dev, sfp->gpio_irq[i],
>>                                                 NULL, sfp_irq,
>>                                                 IRQF_ONESHOT |
>>                                                 IRQF_TRIGGER_RISING |
>>                                                 IRQF_TRIGGER_FALLING,
>> -                                               dev_name(sfp->dev), sfp);
>> +                                               sfp_irq_name, sfp);
>>                 if (err) {
>>                         sfp->gpio_irq[i] = 0;
>>                         sfp->need_poll = true;
>> --
>> 2.21.3
>>
>
>
> --
> With Best Regards,
> Andy Shevchenko
>
>
