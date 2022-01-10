Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46333489AD4
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 14:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbiAJNxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 08:53:46 -0500
Received: from mout.gmx.net ([212.227.17.20]:39343 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230145AbiAJNxp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 08:53:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1641822815;
        bh=R4N6cv0ygG1JpZvIvUmhbpWB+CyOv2e3GilLhoinhwU=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Dlza32FeRq4JGn+weEZIibM+U58kIP87xukWluJxWEXMqmhlQEctBQcJo7x3jU12u
         vbT4dlkN9f1HNxlIGZ8KMa3/zbuRzT6J3XtR2pzStLcSZ6RsfzQS6TaQ9wWBZ75DQl
         qcEvG9tVN+FinrfBGtzr0Awk+qPqra9JBjvAd35c=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [80.245.76.59] ([80.245.76.59]) by web-mail.gmx.net
 (3c-app-gmx-bs62.server.lan [172.19.170.146]) (via HTTP); Mon, 10 Jan 2022
 14:53:35 +0100
MIME-Version: 1.0
Message-ID: <trinity-ea8d98eb-9572-426a-a318-48406881dc7e-1641822815591@3c-app-gmx-bs62>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Aw: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb:
 multiple cpu ports, non cpu extint
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 10 Jan 2022 14:53:35 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <87ee5fd80m.fsf@bang-olufsen.dk>
References: <20220105031515.29276-1-luizluca@gmail.com>
 <20220105031515.29276-12-luizluca@gmail.com>
 <87ee5fd80m.fsf@bang-olufsen.dk>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:PSz8bZR28UOSBwzx7zKgCnep6LafHzmZQ12seuzessATLTTe/5tFInK2qxpWRLq5yEiB/
 3iv7qcfjkVVn3YcsbebCpfq4BexF52Dt8sQycfIrtiOGRGX24gf2AW6gSNrBkOwRDfwDjL5/Ww0G
 mvEzBqKKY7R4zNF0ErsnqLmQFirbuOT10qYZ34yA7d53YzKhMYfD1yB9hnD55Y0GNon+CtNwJEZR
 qQ4yzzL0F4ZKzwEq169mKIUhRGtzRfBCvQCmsIZCqNzC5Fyut8QwYNoDVffgxrBJf7ZhyAf7X/mM
 V8=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:CcUeTaqG0iI=:+bSjJvKcVPNRUXrxn00tZJ
 gxTbF9vhwlza6RAJrMN3YWVWgKjq/CQluLZfEab8ZJbUVIik9FOciCUl0J3rBxzyt4EfSOvQU
 zEBYHlqUsPRHdDQaiBSFPqtx0U/q2wANElkXDivccBjZkFhg5dPeB4F0t08A5b6tASAuI5AjF
 +HU3pIPsEzC7AiXF+dVDYNJATZQHCzz+/MP/hup523+LfXSoKGEohI5QtOJnneTjpVaWQgps+
 dWAQ0pNmKwqWdhwg7+nsP5ySSZb6mioMLbNRs3tHcZhNmFew37PfWh6C1p+O054ey/6hC8JYV
 m5ZRliCizNrcFycFf29HU+WgS68WYKlpSHOvgLycvLWGDrKES3kEeRa3ho3sp+G6BCCvhe+AT
 +WJHKdkKWSiSl2N/2jNnZnn/mQ6pxtBtxNzXAlWGAOd5+6Y2HP7be9czwBwU8HWQAyNyaFaft
 d1AjqrTBooqZPuiDhYefp/1vE3yBpNARkIzCYW7GQowRMiv96vT92KqN9wptt3r3Gy1vMs+TZ
 2/740rS5LU8+1RX9d1hnNmHNyxaf9DaYCw6dVUPuI9yTt4CrV36BXeM6M5bz28lJwkc4E3wyS
 TwMExzhoM6ifZMOcgAlfeNXRZMlXrIT8jt60CSLB/6Ebz05r+3MqPhzTzMtOS/AYjrfK2E0Fr
 wVmgWxRwiTl229hkBwVH3y6t+BhwjzIQXWY0wjmHKGhacLbhtBkFL6PdLUQh2RrkOW/GCwlGS
 ThlUYG+xBlTeaDSDJvqc9VKTFjM5mYdCYDP78GPu6kaWEEylldBHS3S9Rp7MUkAOjIRogMUCk
 P+7fJc6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

i have 2 devices here i currently try this series=2E

1x Bananapi R64 v0=2E1 (mt7622 SOC) with rtl8367s (sgmii+rgmii) - configur=
ed to use extport 2 in rgmii mode
1x Bananapi R2 Pro v0 (rk3568 SOC) with rtl8367RB (rgmii+rgmii) - configur=
ed to use extport 1 in rgmii mode

on both devices i get mdio running after additional reset in probe and por=
ts are
recognizing link up (got the real port-reg-mapping)

on r64 i get pings working but tcp (ssh, http) seems not working=2E
on r2pro i cannot get even ping working (but rk3568 gmac seems to come up)=
=2E

but i'm not deep enough in driver coding to find out whats wrong not havin=
g technical documents for checking registers to values needed=2E

so i need support from anyone to test it further, but devices are here ;)

regards Frank

> Gesendet: Montag, 10=2E Januar 2022 um 14:39 Uhr
> Von: "Alvin =C5=A0ipraga" <ALSI@bang-olufsen=2Edk>
> Great work with this series! If I understood correctly from your last
> emails, you weren't actually able to test this due to hardware
> constraints=2E While I think this change is not going to introduce any
> surprises, I think you should still mention that it is not tested=2E

