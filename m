Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 213094D1BA5
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 16:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347797AbiCHP1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 10:27:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241017AbiCHP1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 10:27:43 -0500
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB1F49F3D
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 07:26:47 -0800 (PST)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-2dc242a79beso195041577b3.8
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 07:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BDg83KmxExGv2FTVzKSEUkIFPafp8SLQqggPFQR6FYo=;
        b=i57L6Z+tbb7HROJlg+BbVrHHFL+dr6ZTQym4TJ1LIhKfteG/s4OkwFbOkBRqfS20+W
         Uk+h5tB3/gb4V9xAXo0nr8EDXvCGyWb9ES6bLCNWr9IcFfhgrYwOrVd/TnY+dKIVbwsM
         W8YH4JqK1fYahcX8d5Q3KaTgozihTANwCFeYfHfEw2t7ZjfIjtwFqp3KuQW5nJvXo/CG
         JrLHkgDQjz1Ks88fc21Pf62HB4li084AMgHs33PuzW3KG3aJbdvUXniwB3WsPlMEGjmH
         Zw1z4XHSrlpgBy+BmcQuuhrn0/pqh3D60f3Zn6UIyPM83YBBW5enm31VcSYI859ljPEG
         5EAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BDg83KmxExGv2FTVzKSEUkIFPafp8SLQqggPFQR6FYo=;
        b=4bR4er2AbdBo2gkh+O1HqvH4gnBWBTWTeKPKLbTBxNPgjy+7hvM8jHXb9e472zl7eN
         Cp+lX5m8Xvr0wGfR1tVFUEYYeI4L1GG4acFY4chOZ7U41VwVBVAwqnt0YX9H08n5lsLQ
         Nbk4Tb22wCU3edeiVYuX15mEWnvwtTInt5qcMDjFKWMfXxjJv/nqD7KgvEi+Z3pegtuR
         JoSLAssn2Z6OgzecaPbk3Df3m/wCbGIuFI5IYJVX6wnfNlHG3xwUGCgmpQxSs+hzinR7
         xSpkxKh2byJnMUrivkLQuyxfap1eQP+bE4RCoCS+JsP5Dc9vRou7mMKqmdIC5Q/Cj7av
         kHeA==
X-Gm-Message-State: AOAM530cWy1isfZ7q+m/R+AlnHhm7ku3CQUJECspWumBX5IqOv9fpRaN
        Sl1ysKBO8vTG89v94qYBRf2PUUlVYyB2KLswXDeE3g==
X-Google-Smtp-Source: ABdhPJxLlp5No+qYWJ6byYFHq0gYnFD75Zl8qKyzpnp75MjksryAO9rMKbI2ZtH9mya7XknA9Tix8MROT4Q2zzrd3oI=
X-Received: by 2002:a81:9c47:0:b0:2db:9e18:6e75 with SMTP id
 n7-20020a819c47000000b002db9e186e75mr13379232ywa.437.1646753206417; Tue, 08
 Mar 2022 07:26:46 -0800 (PST)
MIME-Version: 1.0
References: <20220308103027.32191-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20220308103027.32191-1-lukas.bulwahn@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 8 Mar 2022 16:26:35 +0100
Message-ID: <CACRpkdZJYVRQKWDkp95pF8cdokBw3C0gx1ckmHq=F3tDiV3FvQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: rectify entry for REALTEK RTL83xx SMI DSA
 ROUTER CHIPS
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 8, 2022 at 11:30 AM Lukas Bulwahn <lukas.bulwahn@gmail.com> wrote:

> Commit 429c83c78ab2 ("dt-bindings: net: dsa: realtek: convert to YAML
> schema, add MDIO") converts realtek-smi.txt to realtek.yaml, but missed to
> adjust its reference in MAINTAINERS.
>
> Hence, ./scripts/get_maintainer.pl --self-test=patterns complains about a
> broken reference.
>
> Repair this file reference in REALTEK RTL83xx SMI DSA ROUTER CHIPS.
>
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
