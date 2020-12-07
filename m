Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914552D1397
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 15:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgLGO1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 09:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbgLGO1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 09:27:14 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC83C0613D0;
        Mon,  7 Dec 2020 06:26:34 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id x23so8123372lji.7;
        Mon, 07 Dec 2020 06:26:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1B4ipYgOhPfv+d9TPnP1fvw4sKD2zjUHJ0ZUz1kJsk4=;
        b=nHDJ6961kd4vzacwTGOMER8fNFWyBeL2p/kPlIIggbsazO+mT0b7hWs1PMrf2Pyu7R
         5+1a6HO2FDGcy8/94NYqI8RUNzd0/Ff2ND6b8YKxfDv4jUpbqbhxkA5c8YJiZ9xdrB42
         OOUjVeveeN+Qc0fsSciHyx7JGyIQUJBc35kxbbdAjUehJEnxWwi3BkN6cHu1aGTt8Ko9
         IVRbcYBFWFDMWerSi+1LcIcH7qDoBJveqSTRzsuMmOBb99+9j11X1IEXkaJXvMQKH3zp
         +WW21ZuZcmguwkBWUd0Vcvi0b4B9T/RMuEJNr9IhkPxRtTTftjzsDCxw5IdqocQEXYTg
         4CkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1B4ipYgOhPfv+d9TPnP1fvw4sKD2zjUHJ0ZUz1kJsk4=;
        b=E2dOSj+sdvjZXUEEtl5LyCf+hxNsKNQj7BQbdhvjvLOVC+sjxClvybLFfdbk79wSss
         X/lgajUyBHaD4/JmggCMj/MPefp9pP65rJHS4A1fEQh7ADQhYWnumuQ7Kwxv+Ck399DI
         GN+N0dyd2Z05WzLjqfyqJboBHH2iogo7soFoCzspSIuDmg1b6hIZ0hQfOW9l1WP/OnhO
         4KFSjlgTrqwcys5BrNHi9VJrQswEykiU85T9KzprE+uLA3qyMrngBJtnFqLe57ytBZFc
         JDthhuMQ9QflB88+FbdKQDsJZ/yyTSIj5QdgR9MIQ+nnBXvrm+dhGScef29fbtadwIwV
         XijQ==
X-Gm-Message-State: AOAM532EMH8XBPm9ctDdSYKcpi1s/mzbNbSs2+eJQkWgXOvZd9WQd8Ku
        57BmDVsA3+PjbS06VeU5fUk2aKvBdSpwch0sX5g=
X-Google-Smtp-Source: ABdhPJx8fkI1pkpOflcZyIiQeJtY3tgXadpUV6BcFDkM1ZKLX7DBCJ5eJmEDff99x2MAH0xnax7xkBIykjvgEOlcnV8=
X-Received: by 2002:a2e:9842:: with SMTP id e2mr8814104ljj.373.1607351192458;
 Mon, 07 Dec 2020 06:26:32 -0800 (PST)
MIME-Version: 1.0
References: <20201207113827.2902-1-bongsu.jeon@samsung.com>
 <20201207115147.GA26206@kozik-lap> <CACwDmQDHXwqzmUE_jEmPcJnCcPrzn=7qT=4rp1MF3s30OM7uTQ@mail.gmail.com>
 <20201207141311.GB34599@kozik-lap>
In-Reply-To: <20201207141311.GB34599@kozik-lap>
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
Date:   Mon, 7 Dec 2020 23:26:21 +0900
Message-ID: <CACwDmQBON8bNDR1gEGafb6S63LgkQf9oS9T4=RVQDHQiHgTj9g@mail.gmail.com>
Subject: Re: [PATCH net-next] nfc: s3fwrn5: Change irqflags
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 7, 2020 at 11:13 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On Mon, Dec 07, 2020 at 10:39:01PM +0900, Bongsu Jeon wrote:
> > On Mon, Dec 7, 2020 at 8:51 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:
> > >
> > > On Mon, Dec 07, 2020 at 08:38:27PM +0900, Bongsu Jeon wrote:
> > > > From: Bongsu Jeon <bongsu.jeon@samsung.com>
> > > >
> > > > change irqflags from IRQF_TRIGGER_HIGH to IRQF_TRIGGER_RISING for stable
> > > > Samsung's nfc interrupt handling.
> > >
> > > 1. Describe in commit title/subject the change. Just a word "change irqflags" is
> > >    not enough.
> > >
> > Ok. I'll update it.
> >
> > > 2. Describe in commit message what you are trying to fix. Before was not
> > >    stable? The "for stable interrupt handling" is a little bit vauge.
> > >
> > Usually, Samsung's NFC Firmware sends an i2c frame as below.
> >
> > 1. NFC Firmware sets the gpio(interrupt pin) high when there is an i2c
> > frame to send.
> > 2. If the CPU's I2C master has received the i2c frame, NFC F/W sets
> > the gpio low.
> >
> > NFC driver's i2c interrupt handler would be called in the abnormal case
> > as the NFC F/W task of number 2 is delayed because of other high
> > priority tasks.
> > In that case, NFC driver will try to receive the i2c frame but there
> > isn't any i2c frame
> > to send in NFC. It would cause an I2C communication problem.
> > This case would hardly happen.
> > But, I changed the interrupt as a defense code.
> > If Driver uses the TRIGGER_RISING not LEVEL trigger, there would be no problem
> > even if the NFC F/W task is delayed.
>
> All this should be explained in commit message, not in the email.
>
Okay.  I will

> >
> > > 3. This is contradictory to the bindings and current DTS. I think the
> > >    driver should not force the specific trigger type because I could
> > >    imagine some configuration that the actual interrupt to the CPU is
> > >    routed differently.
> > >
> > >    Instead, how about removing the trigger flags here and fixing the DTS
> > >    and bindings example?
> > >
> >
> > As I mentioned before,
> > I changed this code because of Samsung NFC's I2C Communication way.
> > So, I think that it is okay for the nfc driver to force the specific
> > trigger type( EDGE_RISING).
> >
> > What do you think about it?
>
> Some different chip or some different hardware implementation could have
> the signal inverted, e.g. edge falling, not rising. This is rather
> a theoretical scenario but still such change makes the code more
> generic, configurable with DTS. Therefore trigger mode should be
> configured via DTS, not enforced by the driver.
>
Okay. I understand it.

> Best regards,
> Krzysztof
