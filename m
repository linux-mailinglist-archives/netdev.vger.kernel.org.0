Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4058F2803F
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 16:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730905AbfEWOxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 10:53:10 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:39347 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730672AbfEWOxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 10:53:10 -0400
Received: by mail-oi1-f194.google.com with SMTP id v2so4572965oie.6;
        Thu, 23 May 2019 07:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O0uMxTnfP+/hXCIQ74nquohFY3NHJwYjI26x2LR70Ak=;
        b=BRHvzn19h6XsCYeXK2+Hm/earZgXCKqh2N+cMhHkzUUXjOr4bvlgcM7cS24sm+3fX6
         c2IYYOpSiKLaXSmd3oOaeUdw4c8uBS1nvNlZapWxM/Gi0frS2ESpejabL/II9CrInDg/
         ufkR0hZkSgGt2ljA1G/r+JOBV9s4rxm+fntnNtgszJjoI5R2cQ5i/fNCWp5MBvUB/1rs
         GwV5E6lmOJGYEhDzfjpM84QENK1jn486uB9X5nWHeL7igPdQBLNbDZCsbfLCtzKIV1v2
         K1ZVytKnFlrSuDFy6nIMoe5VfFn4WZ2vHhJmrDYUz+iiEmXVLXKNEqMzqvQ67dZPmJF4
         ZL6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O0uMxTnfP+/hXCIQ74nquohFY3NHJwYjI26x2LR70Ak=;
        b=qFN6BCFrQdM0w/Ip8GExf4wP1M2mnEXmKvAjuTyNGMBiJiUKzhSk97X7c6dDXQYdwg
         Re/a+eavmJMor2W/COGDsI8TWLJ+tNNU5yvcngAX3LrIM5KLwDSefssGAus8FLlcZ80G
         ma3JChMqstWH3VIz69yGkLncR/MUj9yZZUJgLpBjuUM61yEq4uGNSowUsIRZ3sJXl4c2
         w6j4eCdKn967CE2HFfxSwPqtBgqQdan0F5BNoEaC6Zfi46YLh2aXi45/8O7wkpMRWd9Z
         QJjDkv/PrLBvzdwAOVa6hYaw0dDMYgzFW0hGvrh9Kz2JutL0d5ux1IJsz1HziJuIHHOv
         Wl9g==
X-Gm-Message-State: APjAAAW7X3EoqY5nDKiO7lRDCs4VdUmsr5Vjr3OdjafqFTUFBvwbhVeN
        4Bu41besxhVp3n79yYca/M81In1/nDrU071RKjM=
X-Google-Smtp-Source: APXvYqyzXzvZ6yPDb95ZsCQV9OIWIjHaIxtlrVTQrzcdpGSR/hUJcheMvHFjq5q3jn+oK5EXFvNa6tEZz7x32gv3Iuk=
X-Received: by 2002:aca:efc6:: with SMTP id n189mr3048044oih.34.1558623189175;
 Thu, 23 May 2019 07:53:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190522052002.10411-1-anarsoul@gmail.com> <6BD1D3F7-E2F2-4B2D-9479-06E27049133C@holtmann.org>
 <7B7F362B-6C8B-4112-8772-FB6BC708ABF5@holtmann.org>
In-Reply-To: <7B7F362B-6C8B-4112-8772-FB6BC708ABF5@holtmann.org>
From:   Vasily Khoruzhick <anarsoul@gmail.com>
Date:   Thu, 23 May 2019 07:52:43 -0700
Message-ID: <CA+E=qVfopSA90vG2Kkh+XzdYdNn=M-hJN_AptW=R+B5v3HB9eA@mail.gmail.com>
Subject: Re: [PATCH] Revert "Bluetooth: Align minimum encryption key size for
 LE and BR/EDR connections"
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 12:08 AM Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Vasily,
>
> >> This reverts commit d5bb334a8e171b262e48f378bd2096c0ea458265.
> >>
> >> This commit breaks some HID devices, see [1] for details
> >>
> >> https://bugzilla.kernel.org/show_bug.cgi?id=203643
> >>
> >> Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
> >> Cc: stable@vger.kernel.org
> >
> > let me have a look at this. Maybe there is a missing initialization for older HID devices that we need to handle. Do you happen to have the full btmon binary trace from controller initialization to connection attempt for me?
> >
> > Are both devices Bluetooth 2.1 or later device that are supporting Secure Simple Pairing? Or is one of them a Bluetooth 2.0 or earlier device?
>
> I am almost certain that you have a Bluetooth 2.0 mouse. I made a really stupid mistake in the key size check logic and forgot to bind it to SSP support. Can you please check the patch that I just send you.
>
> https://lore.kernel.org/linux-bluetooth/20190522070540.48895-1-marcel@holtmann.org/T/#u

This patch fixes the issue for me. Thanks!

>
> Regards
>
> Marcel
>
