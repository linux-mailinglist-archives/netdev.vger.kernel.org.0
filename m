Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392F5497066
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 07:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbiAWGv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 01:51:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiAWGv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 01:51:59 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA32EC06173B;
        Sat, 22 Jan 2022 22:51:58 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id f24so15859540ioc.0;
        Sat, 22 Jan 2022 22:51:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WkZMiG5mcgW7ss23YttlTYu8gm6xX9J+Ar8QWBIEq5E=;
        b=oaGUog1/7hTx8dmo7yRpesIsc557cfGEbHJnjvr9c5hMiQxA6u05aGKiYyQUQspRt2
         4ON7TfKiiBQ9z3JRQne0AVzVNiTdvWZ1T8zDPMi4wi5zgBJwtsFZSFNnVplwvXvkEbU6
         GfXTp3C3z6JM4Eeb33vqb3axHM7HdOiCQv27t270yDNymR1KGsnUXrQYymTeEc1MxoW8
         0wLYTubxTuzbIL4z/Q6GyO/EuG8rNEd+5oiD44+n/qW3pv3gIjoZQFFZj9W7YNM4qqkt
         Tcxh9NBFsF54VodsP4kaEylPtly4Y4DBtdm9KATvWhN1rMbTA7IUEljXf3m0nZrepK5j
         nipQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WkZMiG5mcgW7ss23YttlTYu8gm6xX9J+Ar8QWBIEq5E=;
        b=Fs5RL4f30FQtIln13V2j881K76r6H/hV3XAfH63FIcfTcmz3Lv+g6JbIDtB+Xezqwb
         orjzw3CmW+MtSf7VGc9ZWxKOdRG8goAFzwj47yAL1Bax5anVtftOGTDpE1VaphOScagW
         Hzm97QFsHS0hyi7iHsrC5R2lmPgWbK8KmUrDivhjgo5bYD9ue0Djoqv4RrrQtKpW8drV
         W1CajK/FniJkLBzQXUbdGXv3WdoOxe8OI5AbTe5C8YOLbtCVO+dzY2n5tIZ3PqXjBOC3
         oTpuedCGk3wEz0tnNJ2ZBbsKN90O4dIUI3d9/ChObGAjPmD/GRlkiaHuHpvnLNQKJhuV
         pc3g==
X-Gm-Message-State: AOAM532WxVWb4+gw00btZh6rfHkXqQ1zNaD/tg9+hJeQgAV9zScFu9M/
        NebD7cKt7FJ3YNh+0IkbrZG5oo6yB/tSBMoObJg=
X-Google-Smtp-Source: ABdhPJxkBxF5q3v2SWo90VE2ehQ+0DAwXb/trW2iTsTGxSX5CvWk1idKDUqv5e+Hryd2YRQH8FamR8EZJYbiFcBqkEU=
X-Received: by 2002:a5e:8201:: with SMTP id l1mr5502209iom.13.1642920717009;
 Sat, 22 Jan 2022 22:51:57 -0800 (PST)
MIME-Version: 1.0
References: <83a35aa3-6cb8-2bc4-2ff4-64278bbcd8c8@arinc9.com>
In-Reply-To: <83a35aa3-6cb8-2bc4-2ff4-64278bbcd8c8@arinc9.com>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Sun, 23 Jan 2022 14:51:46 +0800
Message-ID: <CALW65jZ4N_YRJd8F-uaETWm1Hs3rNcy95csf++rz7vTk8G8oOg@mail.gmail.com>
Subject: Re: MT7621 SoC Traffic Won't Flow on RGMII2 Bus/2nd GMAC
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Siddhant Gupta <siddhantgupta416@gmail.com>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>, linux-mips@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, openwrt-devel@lists.openwrt.org,
        erkin.bozoglu@xeront.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Do you set the ethernet pinmux correctly?

&ethernet {
    pinctrl-names = "default";
    pinctrl-0 = <&rgmii1_pins &rgmii2_pins &mdio_pins>;
};
