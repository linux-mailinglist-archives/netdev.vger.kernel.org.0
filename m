Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40E3FF6000
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 16:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfKIPV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 10:21:56 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:34504 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbfKIPVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 10:21:55 -0500
Received: by mail-ed1-f66.google.com with SMTP id b72so8472469edf.1;
        Sat, 09 Nov 2019 07:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=7B3KT7m27I86KEF7GR0Y9+xEe3Sei4avLWRZmXEU+Jk=;
        b=sEGkHO5Nw1u6YcsssOPb+qWLT0+J4O2g+quMEbopIoR6AUc5cls51K6fTJeGB4Suoq
         o1vH2h12opauX6KqHDFayhjEdKbrE2K9fckiFR3/hgHJaLsorO3YQWMo+8s5e6vSoWq6
         oOEiBc2ewlQZpvHryuICklYX/lWxwkH6ZsmdYNNZhKuje91eIzG2RyZsAyOpjjQXO1Yu
         MKUgHshy0nAs+3KHhQEZG7V4S608gU5RtcBjbDzz+TJuoho8xN/PMw96ShwFV3ixY082
         SegwMBa1VZYHYPa9eYkXap7eVhgyyGzbLU+8EvO+NCkrvvf7XDURyzFhiZMtNt71w9YJ
         J9Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=7B3KT7m27I86KEF7GR0Y9+xEe3Sei4avLWRZmXEU+Jk=;
        b=PM2YIIgKGh8BaRhvVo9MCMpQfrgLwVlaDkq8Mmyxf8KAtQvbeS//Syojj0EcQdMgsc
         iOokksgmA/JBg13U5Xk/pHEbKq/OQHtvMxTI5tNmQPsh2BN+yI3zsFRVc7Y6xmdB60D/
         W0sYH3Uo849+Cj77Ezyo7qENjHNSZZ7z2zQBQyu6EdAnwLo097RYO4L0s9JmX0n5uZZX
         6SomeDI/05YljQ9PGjp20huCrom9+MHinNDnPZz0D2wknb8fY0x5YZ6ezzc/hx8yUwwe
         JDtidADyxyDSOddAF0yjVi5vGXQDTu2gQAE3YFGHazweOuxLty7rpTDa77rAjmc6Bxrq
         GB0w==
X-Gm-Message-State: APjAAAXkm3vZ2TlTRGNmbmaWaaPu4HDmKah1L/zvg0Yx3DCf+KVm544c
        54vRQ/fiU2bNdg4VC6D1KOYw/j8EstvG/s9XSnY=
X-Google-Smtp-Source: APXvYqw2xy+TORlK9D3NsUd6J7Zs/SmAvifrskcUq5ND66YP9APND+9oBSZCimLdnMzy1MQF2p48oh0a34pC8u3dbWo=
X-Received: by 2002:a50:b63b:: with SMTP id b56mr16737146ede.165.1573312912091;
 Sat, 09 Nov 2019 07:21:52 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:906:12cf:0:0:0:0 with HTTP; Sat, 9 Nov 2019 07:21:51
 -0800 (PST)
In-Reply-To: <20191109150953.GJ22978@lunn.ch>
References: <20191109105642.30700-1-olteanv@gmail.com> <20191109150953.GJ22978@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 9 Nov 2019 17:21:51 +0200
Message-ID: <CA+h21hoqkE2D03BHrFeU+STbK8pStRRFu+x7+9j2nwFf+EHJNg@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: ls1021a-tsn: Use interrupts for the SGMII PHYs
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     shawnguo@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, leoyang.li@nxp.com, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/11/2019, Andrew Lunn <andrew@lunn.ch> wrote:
> On Sat, Nov 09, 2019 at 12:56:42PM +0200, Vladimir Oltean wrote:
>> On the LS1021A-TSN board, the 2 Atheros AR8031 PHYs for eth0 and eth1
>> have interrupt lines connected to the shared IRQ2_B LS1021A pin.
>>
>> The interrupts are active low, but the GICv2 controller does not support
>> active-low and falling-edge interrupts, so the only mode it can be
>> configured in is rising-edge.
>
> Hi Vladimir
>
> So how does this work? The rising edge would occur after the interrupt
> handler has completed? What triggers the interrupt handler?
>
> 	Andrew
>

Hi Andrew,

I hope I am not terribly confused about this. I thought I am telling
the interrupt controller to raise an IRQ as a result of the
low-to-high transition of the electrical signal. Experimentation sure
seems to agree with me. So the IRQ is generated immediately _after_
the PHY has left the line in open drain and it got pulled up to Vdd.

Thanks,
-Vladimir

[Sorry for the repost, for some reason Gmail decided to send this
email as html earlier]
