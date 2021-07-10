Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D583C357B
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 18:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbhGJQPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 12:15:47 -0400
Received: from linux.microsoft.com ([13.77.154.182]:39436 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbhGJQPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 12:15:46 -0400
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
        by linux.microsoft.com (Postfix) with ESMTPSA id 509C520B7188
        for <netdev@vger.kernel.org>; Sat, 10 Jul 2021 09:13:01 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 509C520B7188
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1625933581;
        bh=ul0TgK5M2CBLEyDz+/9bqHBZX02laY4YZl9VOwOplys=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=r0dUhnzq4LSzN16+GPLQyKgCWqlHfQZLTU3R/HMIVh4yiJ/G4eW8crT0WgYggPqm5
         +Sp2xTVbXPoegP3WZQ7NipOvuT3So6kdzkjRLd3tVmRYhIK6dNb2p597biRC6l2+JG
         qABPKe+vmANiOvyqeHQwVB0iU/dWLcIiEF3sJOt4=
Received: by mail-pg1-f182.google.com with SMTP id 37so13275815pgq.0
        for <netdev@vger.kernel.org>; Sat, 10 Jul 2021 09:13:01 -0700 (PDT)
X-Gm-Message-State: AOAM533FTROLpiXeLc97T3cydWwuEbMQoW30rUxbkW4E2t1kbTP8f858
        G3NaGK8FhCBmlYrQ4Q6Fc9YUhvjXpa9uQ8p197Q=
X-Google-Smtp-Source: ABdhPJw+V7haknAIxuK9qeMyQjUC5p3Dw/S7vFU2DCae7KUEFxDo9dmyHyvLAPGUTRgi4B4D9nom1vTH/fnFRrZrEKc=
X-Received: by 2002:a63:fe41:: with SMTP id x1mr12592448pgj.272.1625933580658;
 Sat, 10 Jul 2021 09:13:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210407202254.29417-1-kabel@kernel.org> <20210407202254.29417-12-kabel@kernel.org>
In-Reply-To: <20210407202254.29417-12-kabel@kernel.org>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Sat, 10 Jul 2021 18:12:24 +0200
X-Gmail-Original-Message-ID: <CAFnufp3CokRFn5zfsWgJdZTE2TrHPtqjpPJnBxhDXowUQfxLwQ@mail.gmail.com>
Message-ID: <CAFnufp3CokRFn5zfsWgJdZTE2TrHPtqjpPJnBxhDXowUQfxLwQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4 11/16] net: phy: marvell10g: add separate
 structure for 88X3340
To:     =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 7, 2021 at 10:24 PM Marek Beh=C3=BAn <kabel@kernel.org> wrote:
>
> The 88X3340 contains 4 cores similar to 88X3310, but there is a
> difference: it does not support xaui host mode. Instead the
> corresponding MACTYPE means
>   rxaui / 5gbase-r / 2500base-x / sgmii without AN
>
> Signed-off-by: Marek Beh=C3=BAn <kabel@kernel.org>
> ---

Hi,

this breaks the 10G ports on my MacchiatoBIN.
No packets can be received with this commit in, but booting an old
kernel and rebooting into net-next fixes it until the next power
cycle.

I tried to revert it and the 10G ports now works again, even after a cold b=
oot.

Regards,
--=20
per aspera ad upstream
