Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244C82C3777
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 04:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbgKYDIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 22:08:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbgKYDIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 22:08:48 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF0DC0613D4;
        Tue, 24 Nov 2020 19:08:40 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id y7so706316lji.8;
        Tue, 24 Nov 2020 19:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=t9WCWsnnCS0HjAluEuyOs6Y1ik0naTnbcxAT6lOfnCY=;
        b=RKdLKWUXVadiG3r0jVpgelQMtYmcS4CpN7wGwAsslONQm/+dnWL59MJE26B7Nqu/X6
         kLYhV8r/IsarKuOzVCN4yakN48MPYpjL55xW0F4JLbSknShhZTPoNqUMLvBh7K1Oc9pS
         8T2HohUt8JYB3LORZX6qIinOw4GhKbjD0Gqk7PYzsERF01eVT3y2Y9JnuXNZ5Rt167N2
         qwV7GPmdpF84bv/ugQOgBMi4tgAoxbDiRofKNoK2t1F7DXryMOXJt5YTJcMYrgsSUrne
         bmhNxZRoz6fzcj1Bz2ICAIVsk2n81WqnP0kTWBJPUywmeJJen6W1CuDB9sLvbr0poe0l
         9oDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=t9WCWsnnCS0HjAluEuyOs6Y1ik0naTnbcxAT6lOfnCY=;
        b=KdyHugCcxC3Qmcx9iCtTi9D+C7q6hLG6jbD8a+yz9+23FJJKRnT+XVSo3lGRo7ds9W
         3bBiJmEM+kp7NlaQ/aHHQma3bJHsQkeQYPlieb4HSi2TcMSWnQaYp3WSE8UqLPzHtruD
         uE+UETwTDo4fass3z7uU5Yf33PwAOmF7UHBPqrHY706ClX85hWz/+ezsHcIGJNQIhn0X
         KHB9rbEjEolDp2LWqzTmyxFIeBtNRJ5STzthjhmw7zj9P9nfRuwrW3EVQmQ90JOYgpRx
         TFWiv3JxljDoV04qY9Sn1fl+b1dKIpATS5rMwRHI3zdPB/+X5LejeJj95dRrNkZrWcSK
         RoGA==
X-Gm-Message-State: AOAM533uuF9SBZefb4T+uxcfWr0IfdKj9cA1OJvEh5sVfv/aCw874ZNj
        EBesXApm6peX5cuzCFZoGxgtZQ2B1cVCXgg84b4=
X-Google-Smtp-Source: ABdhPJzDuHVIB4O6tYV9XeAPbHQQL17O9nVMT5QcLVzySXs8keyrLAsFVuhLOVhoGalmy5Iy1RUKIrrFmCKFu70R+AQ=
X-Received: by 2002:a2e:7c08:: with SMTP id x8mr493125ljc.8.1606273719116;
 Tue, 24 Nov 2020 19:08:39 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a9a:999:0:b029:97:eac4:b89e with HTTP; Tue, 24 Nov 2020
 19:08:38 -0800 (PST)
In-Reply-To: <20201124114151.GA32873@kozik-lap>
References: <CGME20201123075526epcms2p59410a8ba942f8942f53a593d9df764d0@epcms2p5>
 <20201123075526epcms2p59410a8ba942f8942f53a593d9df764d0@epcms2p5>
 <20201123080123.GA5656@kozik-lap> <CACwDmQBh77pqivk=bBv3SJ14HLucY42jZyEaKAX+n=yS3TSqFw@mail.gmail.com>
 <20201124114151.GA32873@kozik-lap>
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
Date:   Wed, 25 Nov 2020 12:08:38 +0900
Message-ID: <CACwDmQDWtfa8tXkG8W+EQxjdYJ6rkVgN9PjOVQdK8CwUXAURMg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: nfc: s3fwrn5: Support a
 UART interface
To:     "krzk@kernel.org" <krzk@kernel.org>
Cc:     Bongsu Jeon <bongsu.jeon@samsung.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/24/20, krzk@kernel.org <krzk@kernel.org> wrote:
> On Tue, Nov 24, 2020 at 08:39:40PM +0900, Bongsu Jeon wrote:
>> On Mon, Nov 23, 2020 at 5:02 PM krzk@kernel.org <krzk@kernel.org> wrote:
>> >
>> > On Mon, Nov 23, 2020 at 04:55:26PM +0900, Bongsu Jeon wrote:
>  > >  examples:
>> > >    - |
>> > >      #include <dt-bindings/gpio/gpio.h>
>> > > @@ -71,3 +81,17 @@ examples:
>> > >              wake-gpios = <&gpj0 2 GPIO_ACTIVE_HIGH>;
>> > >          };
>> > >      };
>> > > +  # UART example on Raspberry Pi
>> > > +  - |
>> > > +    &uart0 {
>> > > +        status = "okay";
>> > > +
>> > > +        s3fwrn82_uart {
>> >
>> > Just "bluetooth" to follow Devicetree specification.
>> Sorry. I don't understand this comment.
>> Could you explain it?
>> Does it mean i need to refer to the net/broadcom-bluetooth.txt?
>
> The node name should be "bluetooth", not "s3fwrn82_uart", because of
> Devicetree naming convention - node names should represent generic class
> of a device.
>
Actually, RN82 is the nfc device.
So, is it okay to use the name as nfc instead of Bluetooth?

> Best regards,
> Krzysztof
>
>
