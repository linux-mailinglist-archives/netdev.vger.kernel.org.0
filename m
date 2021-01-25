Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4794E304A4B
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731290AbhAZFHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:07:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728683AbhAYNOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 08:14:02 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E914C061793
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 05:13:17 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id p21so12561565lfu.11
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 05:13:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dkjGH+G3sbPs0AwBpKTZTNMo6PAnhVg3Vk9O+oPBcYo=;
        b=Jh7/FEpR91Kn0N8agvzoZbDt8Vo0Re5umfDss3QUmF1BVvSaj9lIq8UbWi6u8L58yZ
         DZA92Cn7qbWCqYz+j1NHBTG9c95BbJLfjZbNc+pHZqcNlBjqsl2f930JkVnnekbroya/
         Pan4OWOrhztzpXYSMxzPpkCTRDLqxWFcnqDGUIyMiYCLgt+7Sf2HKwR6WGphRoXg+IY7
         NioWkdeZjyDA17yR1tK0y8Ze1vyNNDByrWKrewGm+9VSIHFtkyCC+5uIrIwx/gNTBdKf
         4bYbf3cNy0fKzaUDFkIO1IUc3smoFFfFAop5sisWtetjF7iKYE4KGd/KvXhrF/aGLwoS
         3R7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dkjGH+G3sbPs0AwBpKTZTNMo6PAnhVg3Vk9O+oPBcYo=;
        b=KPT6lTu/2rcFnfhLzMq2fbwnIoaCVqLUAkbbwXwohor1HQvkVTJK8UXiXlsaiik4XP
         7Yfj/yni8c8L2AXpfE1j8QM9B+X2K57R1BxSCg+ynb11mURkM8ugo/5m85v9xarFt9TM
         on2CwPyyDUDqmI1tFPA79uHwtrO6IessUb8A7Xx5sRZv1iM+h502jxEfVZN8A+T753Rb
         0DlbWVVCJlZK5MUqGYdoO9cBy70Dzqr3DIsvsQAKfHpq7eX3pzQUE8QD4bd6Fk04cOB+
         TQaAPWSjZAsJF7JRucC0LWOPRXt1hvCrI7EgeahxUvZKHwfTapy7uM3SW8M47Gjn6sfd
         u4fw==
X-Gm-Message-State: AOAM533PIXf37gRHCoari/1aA4/OsWzloG8Mv/ckFCZT+TUEv8S95Y0r
        97rbXHGLMCwOXjwaxP7fgxaWnoDy1m8k3My0lanJ1A==
X-Google-Smtp-Source: ABdhPJxb7i93hzji/0XqwZuGFblpA4aj5dMHr9srYEFMDhw8118iclkxarMinp3+461hMdPJxmB4BxSJZ/B8GxjDcRU=
X-Received: by 2002:ac2:5c45:: with SMTP id s5mr250905lfp.586.1611580395894;
 Mon, 25 Jan 2021 05:13:15 -0800 (PST)
MIME-Version: 1.0
References: <20210125044322.6280-1-dqfext@gmail.com> <20210125044322.6280-2-dqfext@gmail.com>
In-Reply-To: <20210125044322.6280-2-dqfext@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 25 Jan 2021 14:13:05 +0100
Message-ID: <CACRpkdag3P7yGVmzkcdi8zw=3WJFNDDTQDOWujBB54YgFZJ22g@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/2] dt-bindings: net: dsa: add MT7530 GPIO
 controller binding
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 5:43 AM DENG Qingfang <dqfext@gmail.com> wrote:

> Add device tree binding to support MT7530 GPIO controller.
>
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
