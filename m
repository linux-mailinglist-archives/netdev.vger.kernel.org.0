Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8163D47AF
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 14:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234191AbhGXMHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 08:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbhGXMHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 08:07:47 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE29C061575;
        Sat, 24 Jul 2021 05:48:18 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id n6so5061667ljp.9;
        Sat, 24 Jul 2021 05:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RfMSh6YLaZEkpisGzz8tzT+CWBhFXuhceR7+JI0KV/M=;
        b=kA3ig6s28YpJPVSPJ4rtpTNz6R12Y92GVLIz6CG/yYbl686dISHG8qmMtBV+Nx9UFM
         cAfH1i8HmgS9Qv9/1rYlY2QcUc5E2O1mrRYQTv4a0nuPS9WliPcBxIQUng5dFmFb2cpV
         4nM9QvwpGgS/ySlcc7v6fypZSFiaWGG4lQt4knNUwvQu+otuc0etkjVBkpnORVpIh1qG
         Os0pIBT7MSQvtArgSdVC2uo/5ZQhV94cBj1Oks2JsfHFkv+SXF9lhC6bPTG0UGf/Pj4r
         vPwhWodCbpjrG9VbxxoUowMoG9TWURnoGhn9XnxbtqhDr6OY84F7//Vyn48ITMTjHdmV
         3mwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RfMSh6YLaZEkpisGzz8tzT+CWBhFXuhceR7+JI0KV/M=;
        b=GsO9BvQ8DD6VBHC7/3XL3iIn84xrHVvCp7nu+tU7FDEhaphEEwnYh47L0TtTxUORf+
         KN74ZO5bVpIMF0M+2oNZlsDgr25+8VJR9mtcGLoCzQmqkNa1athv9QUOvgoyt5C61IUl
         Pt4fN4/RPmWxvtQ3Oy2cuqrQYuGVcSgWlCKIB4Dq+Y10Q8hCA8RPVUHliHXV5b9gxGC1
         punxSj3lFxO3VMvickIfvk7Rl9e95gzgsz303VPueDan3AhvDu5HvuB1+xHjwFiT1OSH
         AmGsOIjF1kBRNkbZ6uzom4o807gc6nK7sdNARyxzxm6KnfaKlVpkFQ/EPdZUKKnVcjGj
         st2A==
X-Gm-Message-State: AOAM531/MOgYrVlTY0YG3AdBFjLy74vjvI0FjKSNum2rBam5zwzjoKnZ
        dbnUUY/Rd0P5QQgB8pLhJPvjhg1hI4nk2sUXz1w=
X-Google-Smtp-Source: ABdhPJwTKMzqfmKrpi+o6iZEl3eiwHJlpHehq/87sN2KhUYNKmn4LsVc1dET97l4kEBYxCo3vc5v0zH5kuzC+9kKgQA=
X-Received: by 2002:a2e:a164:: with SMTP id u4mr6069456ljl.121.1627130896569;
 Sat, 24 Jul 2021 05:48:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210723112835.31743-1-festevam@gmail.com> <20210723130851.6tfl4ijl7hkqzchm@skbuf>
 <CAOMZO5BRt6M=4WrZMWQjYeDcOXMSFhcfjZ95tdUkst5Jm=yB6A@mail.gmail.com> <DB8PR04MB6795F1B7B273777BA55B81ABE6E69@DB8PR04MB6795.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB6795F1B7B273777BA55B81ABE6E69@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Sat, 24 Jul 2021 09:48:05 -0300
Message-ID: <CAOMZO5CvVA8xfkinRAhf=WLnLxjZ9mZask3jYm8=NSiSa5z+TQ@mail.gmail.com>
Subject: Re: [PATCH net-next] ARM: dts: imx6qdl: Remove unnecessary mdio #address-cells/#size-cells
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Shawn Guo <shawnguo@kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joakim and Vladimir,

On Sat, Jul 24, 2021 at 2:21 AM Joakim Zhang <qiangqing.zhang@nxp.com> wrote:

> I prepare this patch to fix dtbs_check when convert fec binding into schema.
> I realized that we need a "reg" under phy device node, but I also don't know how to add it since
> the phy is obviously not on board. And I check the phy code, it supports auto scan for PHYs with empty
> "reg" property.

I looked in the U-Boot code for the nitrogenx6x board:
https://source.denx.de/u-boot/u-boot/-/blob/master/board/boundary/nitrogen6x/nitrogen6x.c#L343-356

and it scans for a range of Ethernet PHY addresses.

As we can't pass a reg property in the dts in this case, the patch I
sent that removes the
#address-cells/#size-cells properties looks good, right?

What do you think?
