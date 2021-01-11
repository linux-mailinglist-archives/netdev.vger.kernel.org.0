Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8BA2F157B
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 14:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387518AbhAKNko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 08:40:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731984AbhAKNkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 08:40:41 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A6FCC061786;
        Mon, 11 Jan 2021 05:40:01 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id 81so17761534ioc.13;
        Mon, 11 Jan 2021 05:40:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VPX+TWLUVWMLDjFiSnhOZGL+SWYosAkfqkHnqdSxUAM=;
        b=oYpWOHIwy6XftMFufPxgO9fchZbGj2sitlgT6yrncOYW3o+rDnEaoDdEBgXbnIkNeX
         BRgMVzfxXtPehTLtxH6/A+/pCGEJ3rhhXAiCTmRByGxtCcl8HuLLDc4BXZpAV55H3biZ
         0yDuJ/sOHEfW0HPXS5Fkcy+xtw+eO8Vz+ABu8n7XEudo17TUNCRfI2C5ZA6PpHF0HWLe
         Lx7Pjc40cr4XA321nE1pFq1IE4Pg7cHaco2k4hd0nh2MkbN3i8tPv7ypcjFqWMR7xBRv
         c3Bd9zDm7FaaHKwWj0GVydeK7Us4jjDSjh2RO7254w2P/sPOk9WCkIF5XTrXgUCTwGu8
         z98g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VPX+TWLUVWMLDjFiSnhOZGL+SWYosAkfqkHnqdSxUAM=;
        b=ExQYTm2mjN9pDwKXVoFR7DGfblCYkkdZkc4f9UaQ7+fkxpHeXRVhVMvENp7hSN/Y8S
         YqUc8vgAPYotsIiKOg9iFsSYqxpYIKm2wiIjaRdiwANVdVXqHXXTN59t82ZfYmaieIEj
         K4mmHeSN2h65tGQV/b5UFf1KXRowRtJBN0ctomcpdecmkzITic1BnaSv4lxEmltu+ybB
         RK0PngNCKnciaKKu1mHbyZpj4TojRH7Tbz9BpHHvpp3AOvFvquPT/SUoS0rVEMfmFmhE
         oyExkAKPDRtAfPagJWpA/d6ZicvTE9R4tl9Wr9+oy/yr7c3onK+sHs4vTWTST+gnkJQ5
         T2RA==
X-Gm-Message-State: AOAM532w/nemwmpkAXu4NksVBYPXr34KoLkKWZcFfvLtKUYx0u7WCE9r
        pLCxSViWjNhEen45aRq3XBPuJTLt7bj0QUMNKwU=
X-Google-Smtp-Source: ABdhPJxdIHd1jmADjrtYp3Zsp0l/yfn12bjpz+qSZpWV+XVteUVCntZjcfHonB6Q9MK8aoe7wB6LwfSgeU+sRkaghGs=
X-Received: by 2002:a02:c8c7:: with SMTP id q7mr14527159jao.7.1610372400687;
 Mon, 11 Jan 2021 05:40:00 -0800 (PST)
MIME-Version: 1.0
References: <20210111054428.3273-1-dqfext@gmail.com> <20210111054428.3273-3-dqfext@gmail.com>
 <20210111110407.GR1551@shell.armlinux.org.uk>
In-Reply-To: <20210111110407.GR1551@shell.armlinux.org.uk>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Mon, 11 Jan 2021 21:40:00 +0800
Message-ID: <CALW65jaqciOiRxJxzPiEADgpmKa7-q2QfQnBdaVMcOa5YDHjRA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] drivers: net: dsa: mt7530: MT7530 optional
 GPIO support
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
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
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>, linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 7:04 PM Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> FYI, Documentation/driver-api/gpio/consumer.rst says:
>
>   For output GPIOs, the value provided becomes the initial output value.
>   This helps avoid signal glitching during system startup.
>
> Setting the pin to be an output, and then setting its initial value
> does not avoid the glitch. You may wish to investigate whether you
> can set the value before setting the pin as an output to avoid this
> issue.
>

So, setting the Output Enable bit _after_ setting the direction and
initial value should avoid this issue. Right?
