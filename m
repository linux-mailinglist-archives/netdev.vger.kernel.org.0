Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216BF32B3A0
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449853AbhCCEEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:04:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238849AbhCBRbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 12:31:20 -0500
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C610C0611C2
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 09:06:39 -0800 (PST)
Received: by mail-oo1-xc2b.google.com with SMTP id i11so3467349ood.6
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 09:06:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=V1cLzC3lV0ZuXpLtShiRSggtSVYjJPa1LYuRFOwrf+E=;
        b=QlPCPgBEdNyrlQkiRX0H0bEUgdld7sY+mtTldQ7suBRaaQ5X+sbHj8fyYCbnkNVblk
         dUVBPYMizlpCmw5EVITpkyg0tsi/Xo31PoPwkaGsVonb/I8rUYxCh4XdU/dzEJEUgjQv
         2ULJxeFIUL7Kgqwq4n9jJuV0XadE5KP5G13cQrN55Sb4g4Tyevz4An6Ibip7mSyFCBQp
         pGhTZA9djcmFrVJMYQ5qxZ0svq/ZJfU4Ky9tFlv9ZATm+V4OTNTStQQKIYKtU1Ns33Up
         gfiyYbunyNe7MXZPmLKmhVgQWIdllqwNoNEA793s740w2uzrNaHSabqpGohhp3mvKa5V
         2XiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=V1cLzC3lV0ZuXpLtShiRSggtSVYjJPa1LYuRFOwrf+E=;
        b=af+nSkk0HGw3M2jQdAyFnnhKhWJE9qB8Ws3ic/TZTnX9wRCCpdKp5p8EwkYT6C+oE4
         Niw83YHtnO23TPHMhdUlvuAHQX0zNufBFW+PQzLVxqZQMFK7pdcrAIaUEuWHtYeGt4AL
         0o+80GjLXwuOsOAvDqSfAfXaVXuzdcxalM4XgL8/SG/DRhZnjIM+nz8hkqvqTkSlRYAu
         mkCjhqvxsTEJUAvBL2yNoHOlX5YqX47lb2jP1L5k+oY7HJ45l9/VPaZo0g3nDJk7ho/w
         HeceJjpDv6KmsA+LBekzeZvF39noMYDytZVwxmlDkii1bSI2xT8L+Db6MVzsfwe6seUE
         KrlQ==
X-Gm-Message-State: AOAM530nn6D4jqISdqVHqIuiXq0JxA8TIB+sJplcM7BeE/AxBEOhsRra
        AZiXktoxsyArkIvW3mDD0BA4WB5lSBpc3pCLlZpn1xnmShlRQQ==
X-Google-Smtp-Source: ABdhPJwIdXvPL4DZGa+UtUMwf/1b7Ae4U+HmE9LjO3DtqUFCl+SvQqGLdBI3iyW4KXRUzKo1qb1Fw3cyHxhWkJFu0GE=
X-Received: by 2002:a4a:d50d:: with SMTP id m13mr17483206oos.2.1614704798510;
 Tue, 02 Mar 2021 09:06:38 -0800 (PST)
MIME-Version: 1.0
References: <CAFSh4UzYXp7OaNcZOWQfyxznQfcF+Ng0scboX9-kxhrcpLKd7w@mail.gmail.com>
In-Reply-To: <CAFSh4UzYXp7OaNcZOWQfyxznQfcF+Ng0scboX9-kxhrcpLKd7w@mail.gmail.com>
From:   Tom Cook <tom.k.cook@gmail.com>
Date:   Tue, 2 Mar 2021 17:06:27 +0000
Message-ID: <CAFSh4Uz3ZJBZqNTD35Fw5+B=_dgXJumW9nwE1RAgBJddGSQXkA@mail.gmail.com>
Subject: Re: MACSEC configuration - is CONFIG_MACSEC enough?
To:     Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Never mind, I found commit b3bdc3acbb44d74d0b7ba4d97169577a2b46dc88
that fixed this in 4.10-rc9 or so.  Sorry for wasting your time.

Regards,
Tom Cook

On Mon, Mar 1, 2021 at 3:00 PM Tom Cook <tom.k.cook@gmail.com> wrote:
>
> I'm trying to use MACSEC on an arm64 embedded platform; I'm trying to
> create an encrypted channel between two of them rather than doing
> switch port access etc.  The vendor's BSP only provides a 4.9 kernel
> so that's what I'm using.  I've added CONFIG_MACSEC=y to the kernel
> config.  This then forces CONFIG_CRYPTO_GCM=y and CONFIG_CRYPTO_AES=y.
>
> I've tried both manual configuration of MACSEC interfaces and also
> using wpa_supplicant to do MKA negotiation.  I then add IP addresses
> to the MACSEC interfaces in the 192.168.149.0/24 subnet.  In both
> cases, the result is that the macsec0 interface has flags
> BROADCAST,MULTICAST,UP,LOWER_UP but is in the UNKNOWN state.
> Attempting to ping from one to the other results in encrypted ARP
> frames being transmitted but then discarded at the receiver end.
> tcpdump shows the frames arriving at the receiver and `ip -s macsec
> show` shows these frames being added to the InPktsNotValid counter.
>
> AFAICT from macsec.c, InPktsNotValid means either that the decryption
> failed or that memory allocation for the decryption failed.
>
> Is there some other bit of kernel config I need to do to get the
> decryption to work correctly?
>
> The SOC is a cavium cn8030.  This part is equipped with a crypto
> accelerator but support for it is not compiled into the kernel.
>
> Thanks for any help,
> Tom Cook
