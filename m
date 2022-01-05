Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99192484B8B
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 01:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234636AbiAEANB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 19:13:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234119AbiAEANA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 19:13:00 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB6DC061761;
        Tue,  4 Jan 2022 16:13:00 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id c9-20020a17090a1d0900b001b2b54bd6c5so1507812pjd.1;
        Tue, 04 Jan 2022 16:13:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yEEjORyDHr/UE6RbMr2kar9GaUil9VsJ5e9/kxtvdtk=;
        b=FlrXMiPJxNmwbFLoDC7Hs5wUH07aJa+mVYLGH13U77XLHEOW1o7M9l9a8dtuf/xb8Y
         EZKjtnvQcnZ49HgQGtgNuiYNPlvEK6mTmZVPRCniaS9wvpcO+AIAh174ZxAdR/E/CIy/
         Bb8EBXkzb3hqmBq5jq06V7jGeJqe2Aj4Lbmrb76FQ8oM8uVNc8i1N4N/AkdjtKaHJXrc
         RRXmexTg+I21R8DmwQOetO+2xl0otqimCu+tGN3SLYymaqNtLP0mUWGyZ++NzrSO9il3
         h0tMuxyxIDKNBZ6F7761/Cjcf4uXjbmhZ0wbuUd8XAxaAiCryEL9EOxjznOhPgCLTzBh
         /irQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yEEjORyDHr/UE6RbMr2kar9GaUil9VsJ5e9/kxtvdtk=;
        b=Z3vnmKflXzOc+JLj7HLqy8lXGL8ILVdlBC4w1I8524ALz6/lBDKDuZWwdgSSDjVYrZ
         KZ2ULKvCHtQPTRBBJO+FkWIZKUloWJUzc5KpbjaQB5y3+N34aaC7okld5v7baRkLi2Hn
         u4WUpqPjZytp4Y1wWv57Qj2AI788D048zPN2XubnF9zLacXAw0pCapu8P1ckpDCOpMDl
         sMaQg7NcSsawT4Uc1gztEWCCyW8QrcW6TN9ixKQEpBopRphIt8Rn50t7FPFkM8IO+N2e
         YGQSQZLF0mrNAgXNgdNnM5K/eXyzWwB3AKDvBtH46u200DaxBhXQTwi7XdZx5iITwcjz
         stTw==
X-Gm-Message-State: AOAM530STSLg3k7i+0QBSPef/+n2oNXxuLATMvw2WqtekBUAvNOti0CX
        QQgSiMPsxBP3Izuor27eyL4ExtAW5yZv4/VDL1I=
X-Google-Smtp-Source: ABdhPJxGSypl4WHoICJiUI/E0we9KC0f2nA//dCM8Gk8uR0KdRsPmdnHlgQjkmp0+804oDbgNnhPb78KFhhmzDHB1/o=
X-Received: by 2002:a17:902:7003:b0:149:ba80:8740 with SMTP id
 y3-20020a170902700300b00149ba808740mr13670625plk.143.1641341580039; Tue, 04
 Jan 2022 16:13:00 -0800 (PST)
MIME-Version: 1.0
References: <20211223181741.3999-1-f.fainelli@gmail.com> <CACRpkda_6Uwzoxiq=vpftusKFtQ8_Qbtoau9Wtm_AM8p3BqpVg@mail.gmail.com>
 <CAJq09z6_o9W8h=UUy7jw+Ngwg26F8pZVRX5p0VYsgoDKFJRgnA@mail.gmail.com> <YdSry15jzwdbh6GO@robh.at.kernel.org>
In-Reply-To: <YdSry15jzwdbh6GO@robh.at.kernel.org>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Tue, 4 Jan 2022 21:12:48 -0300
Message-ID: <CAJq09z5gBwDi+iPGYm0+=HWCiiGUDfLk62fKzwbimzgchLd2Nw@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: net: dsa: Fix realtek-smi example
To:     Rob Herring <robh@kernel.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Then just fix this in the conversion.

Hi Rob,

I'm not sure if I got your suggestion. Should I post the new patch
in-reply to this thread?
It is related but something completely different.

I sent YAML conversion v1 a little while ago.
https://lore.kernel.org/netdev/20211228072645.32341-1-luizluca@gmail.com/

I'll send v2 soon. I'll mention it in this thread when I do it.

Best,

Luiz
