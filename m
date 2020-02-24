Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7144416A411
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 11:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbgBXKi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 05:38:27 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:42907 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgBXKi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 05:38:27 -0500
Received: by mail-ed1-f65.google.com with SMTP id e10so11288449edv.9;
        Mon, 24 Feb 2020 02:38:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6Uw+EFVoa4I93GT2kj8Y5Rr/8NCWuvO6exBhY+QuuAk=;
        b=c5AcVu9PctAre5ABV75TS3znJyeDih2j1yHWb4Wfz/I/N1JpBKbK4dNfH2npBrnLnw
         IEQtZlIcQjmb0e/SMBt2xU46exTD4aA0NrjeDJfOz2dVMd2ad4zP7nzUacFVNyQWDiYH
         XNwbISsZTcUWTwPlQwL8SrZD416ykM+ccxrjrD5ee5rlPF0iMsdQ5p46Q7GGN6M+jjjb
         zGlhE+OCHvQy6b8sHfh8kJre4M2NlvfHrwzrUngGyukcrAMDkB1q1XL4JtNs0Z+iAbuz
         pV+OEi22T/RMZHB4Dk9dGs7XZH9j+0mu02SiNyc14s8a9LCyVzbCByAJ1NmEdl2SPqm7
         cc0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6Uw+EFVoa4I93GT2kj8Y5Rr/8NCWuvO6exBhY+QuuAk=;
        b=BTaoHkiLuntczZN7/MOVzwFrLnkPieaLb9sPQB5cEyPhiTUJHaamRKjV4WGkuaz6fv
         V7E75R2vRnX30TSod0/AY9dUGnEUF4FwUa31ns/F6La6u2ftLjvsnSLGoaxqi2KJryKK
         8mRoRpTpUsyMHfNIJrlQym1mMf4WDh7Ao+g6WVS3hDLf34bHhdboi5cOTTFMEjiFVRqt
         Yd/8SYBWW894K61Xw6V7yUKlguYJJvjJaQo/eB8bsH2/iLJA2vZGknX0M2qAGxfuRRjx
         owAci2GSv+h2hwsBDFsvq/tKCBJFTD9SpyxbSGg5OVpa2Cb5VPc2GOPKLg44t7xq6dmj
         FFbg==
X-Gm-Message-State: APjAAAXw4dPdCEsOmk7W9Ydj5+c2CZHO5v4dXqlEFe1D6H1kO6il9TPk
        IKVSQqmxjMFg3VFXX8YmZmgh7jQ34yzCtubJvR7uFCr8
X-Google-Smtp-Source: APXvYqwLc8EpHY93rVYt2IJXVaFijY0IR4REiDEXSkA+bIixGeASRBQOWvOJJG9DFOsEdRQdFnuPVT/PZvPS8ELwr50=
X-Received: by 2002:aa7:d3cb:: with SMTP id o11mr46199101edr.145.1582540704910;
 Mon, 24 Feb 2020 02:38:24 -0800 (PST)
MIME-Version: 1.0
References: <1559287017-32397-1-git-send-email-horatiu.vultur@microchip.com> <1559287017-32397-2-git-send-email-horatiu.vultur@microchip.com>
In-Reply-To: <1559287017-32397-2-git-send-email-horatiu.vultur@microchip.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 24 Feb 2020 12:38:14 +0200
Message-ID: <CA+h21hoSA5DECsA+faJ91n0jBhAR5BZnkMm=Dx4JfNDp8J+xbw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/2] net: mscc: ocelot: Add support for tcam
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, devicetree@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Horatiu,

On Fri, 31 May 2019 at 10:18, Horatiu Vultur
<horatiu.vultur@microchip.com> wrote:
>
> Add ACL support using the TCAM. Using ACL it is possible to create rules
> in hardware to filter/redirect frames.
>
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  arch/mips/boot/dts/mscc/ocelot.dtsi      |   5 +-
>  drivers/net/ethernet/mscc/Makefile       |   2 +-
>  drivers/net/ethernet/mscc/ocelot.c       |  13 +
>  drivers/net/ethernet/mscc/ocelot.h       |   8 +
>  drivers/net/ethernet/mscc/ocelot_ace.c   | 777 +++++++++++++++++++++++++++++++
>  drivers/net/ethernet/mscc/ocelot_ace.h   | 227 +++++++++
>  drivers/net/ethernet/mscc/ocelot_board.c |   1 +
>  drivers/net/ethernet/mscc/ocelot_regs.c  |  11 +
>  drivers/net/ethernet/mscc/ocelot_s2.h    |  64 +++
>  drivers/net/ethernet/mscc/ocelot_vcap.h  | 403 ++++++++++++++++
>  10 files changed, 1508 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/net/ethernet/mscc/ocelot_ace.c
>  create mode 100644 drivers/net/ethernet/mscc/ocelot_ace.h
>  create mode 100644 drivers/net/ethernet/mscc/ocelot_s2.h
>  create mode 100644 drivers/net/ethernet/mscc/ocelot_vcap.h
>

I was testing this functionality and it looks like the MAC_ETYPE keys
(src_mac, dst_mac) only match non-IP frames.
Example, this rule doesn't drop ping traffic:

tc qdisc add dev swp0 clsact
tc filter add dev swp0 ingress flower skip_sw dst_mac
96:e1:ef:64:1b:44 action drop

Would it be possible to do anything about that?

Thanks,
-Vladimir
