Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1405CC2936
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 23:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732047AbfI3V5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 17:57:04 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45433 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727681AbfI3V5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 17:57:04 -0400
Received: by mail-lj1-f193.google.com with SMTP id q64so11097244ljb.12
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 14:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4G8UhfmOAU+vf176VW3ixtgHtt4omHWSmMUKQqJYu4I=;
        b=zxeBRvzt144Q4MDycJBV/iY/2eVJfo8OGtkSJ0SJijBO2SEblZzrVzwlMUbAM+75SS
         LNt8hYAXph/R13Qlfc4X4Ugg10gDi9uZoyrf3aIEGtHaARdlCMS8W6Hv/Gyg1aA7NhRg
         +5YcShk/mkdFeO4SABR6+AehSLtFVMI9hV0IZvm+xNaDRU5ri2jxn8wN8+R2531bip9n
         HWBEiqrzP+T1djmmDaowqv+2jDvWaaqtPXvH9ttR19WAiFNmZfzReUc6pUSYmzdCWlCo
         SGlbCAYv2DyxRTmvQ2x85hx7Fhc++TSYqMt/xumnFrYkYOJyZ42kIwDm0UDHbqZFiWeX
         mCfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4G8UhfmOAU+vf176VW3ixtgHtt4omHWSmMUKQqJYu4I=;
        b=ocs95vrpF0wjrU5HtRL0xsIwXEz03m/kujCv9RuSZNqiZordO15AxNL1pcqkb2ahiU
         o5t320n00ZKdtP1RX/zJvOYnfVun7cxsicoF+85jc7LtuV+6Ls8T9M1odsYtNq5W69ID
         c28siXEU1WIqRqxFrAJeKAyMUdlzKuad+Ktri3M2mPwaOmSFgJzSTGHX9RnTBZg3JjgG
         6O/DONIrRVo7MJSK79xQuVq9gI/tZxG7cZL/RKZnsNqRL4W5K2aLvWzYNGIgQkbNKNKc
         GuLI5ib9lOlN36wiBbtGmj6H2DNijB9VRqvEXeB5zvy+nzWBGG1uTFSYAqubulBnVpO1
         isCA==
X-Gm-Message-State: APjAAAW77ViRYih/KbeMGrzxXJyMNX/h0EYEzKiEDF+sFwTbSQgaD0AI
        f+Iv9Ps5lWa9apl/Ly2vkInyMINsmW8bkKxCpQj7p6jmVss=
X-Google-Smtp-Source: APXvYqxTMPGQmp2QxQwSjPnSlD2DfIy461Be7tP5jcA0wNeXj15OTh6X0ZFBtVo8y+wCLVjDeIruFT+9xcgMQuaamL4=
X-Received: by 2002:a2e:b4c4:: with SMTP id r4mr13939072ljm.69.1569880621961;
 Mon, 30 Sep 2019 14:57:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190929070047.2515-1-wenyang@linux.alibaba.com>
In-Reply-To: <20190929070047.2515-1-wenyang@linux.alibaba.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 30 Sep 2019 23:56:50 +0200
Message-ID: <CACRpkdY-SnPjocWzoujah6c=Tnj8G7XqBgULXYNwnt6FvED37g@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: rtl8366rb: add missing of_node_put after
 calling of_get_child_by_name
To:     Wen Yang <wenyang@linux.alibaba.com>
Cc:     xlpang@linux.alibaba.com, zhiche.yy@alibaba-inc.com,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 29, 2019 at 9:01 AM Wen Yang <wenyang@linux.alibaba.com> wrote:

It's nice to see some Alibaba kernel contributions!

> of_node_put needs to be called when the device node which is got
> from of_get_child_by_name finished using.
> irq_domain_add_linear() also calls of_node_get() to increase refcount,
> so irq_domain will not be affected when it is released.
>
> fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
> Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Vivien Didelot <vivien.didelot@gmail.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
