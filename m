Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECDF2FA368
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 15:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405135AbhAROog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 09:44:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405095AbhAROoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 09:44:16 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC81BC061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 06:43:33 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id x23so18416699lji.7
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 06:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=runo5vK1iqFTp6/RwnDUEbOVNz8ibclO8u1aZro9VKc=;
        b=twoDGBDgrvw/4Z2eIupJoAhRxuYzGgcaExa9KOHpEypH1Vk9381GnGErvyDNSjo8f6
         lW6pf9vgJurz+efm6dJ4OURkT1cE1oVfxeXOOn5+gKc7iC+AIW/nbee7s2JjHZOSpKOm
         r+UDYxdvmLOiKQRfR1AFBtSbWY3X/F9rkgam6a2/uhrIYc9WvZuTiyBAW3Zloz1SJGz9
         dQW/peQUHGiUVkjXQJ3TVBOYM+zTMmf2nSeawPhThpJH+WT5xmQGEpKUBUI3zIO0ecxJ
         hQJD1nMNUfnHh/V1xWVhUBRyf2AY+atyGgy4uyiwYQw5vF3qvBwN0jdAk0+W8h1yJFJD
         ppnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=runo5vK1iqFTp6/RwnDUEbOVNz8ibclO8u1aZro9VKc=;
        b=fgoMLkAfPzFTCdUlTnymoRP+jqhJkKWhsdqWczDHPnqbVNMxGEgoLgnq1Jm1FR4KQC
         r2CjLAJWpH1V4k3Oc5D6tqkIY1RlgUlxNn3jpE6Ztbff0iin9JH/cM2l+vSWOSdYqfPU
         fzA6hhe+lUaWuDpkQ8rBHaYOcsefFLUOeE3oPhgQujYmpceSop5/zaV9bgYyFF6BsRIU
         7Hh2CWtsd/hvJmNWYVLd3TOyeGuByB1vUiA/HjrPC7+xvdAXjCJKquS5hgHZDWjDJm9w
         dDNxewD2RgIeKV5sPPMow03Fotb+2BH4+7bmDTN/4WR1JFsNm/gBFqkrmDQ8a3xNi6qP
         zEvQ==
X-Gm-Message-State: AOAM533VAGnzmzQLnxk9+OxnaBVN4uCNKNyL4t+ivNduoD9dTUVBaItn
        v5vEBX4rf3sKlnJTdlrWKaL8UeKGa4xFyiu5G8Ntiw==
X-Google-Smtp-Source: ABdhPJy2OOVKezjRgxxe5iT3gY3n3WlV9ouw3Rb0zCDWbrU5ySb671mcJXZMhaBCBrs5KgGrosV27j0P0GOQijbiL3o=
X-Received: by 2002:a2e:3503:: with SMTP id z3mr30858ljz.74.1610981012277;
 Mon, 18 Jan 2021 06:43:32 -0800 (PST)
MIME-Version: 1.0
References: <20210111054428.3273-1-dqfext@gmail.com> <20210111054428.3273-2-dqfext@gmail.com>
In-Reply-To: <20210111054428.3273-2-dqfext@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 18 Jan 2021 15:43:21 +0100
Message-ID: <CACRpkdY8K8N84iAZhDrxPT6+W6Df85h5O+zE5NqW3z4AWvePmw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: dsa: add MT7530 GPIO
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
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 6:46 AM DENG Qingfang <dqfext@gmail.com> wrote:

> Add device tree binding to support MT7530 GPIO controller.
>
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

This is a good way to turn it into a GPIO controller.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
