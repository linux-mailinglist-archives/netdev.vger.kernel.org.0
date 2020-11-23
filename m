Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92FBD2C1853
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 23:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729653AbgKWWXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 17:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728161AbgKWWXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 17:23:23 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6CAC0613CF;
        Mon, 23 Nov 2020 14:23:23 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id n12so13963021otk.0;
        Mon, 23 Nov 2020 14:23:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PhFFzUYuu3kiiGwxciZFZrbqQ/Aj7BOjCk2nVZt0710=;
        b=ND7+5P3Fbtz0YfySSQrjkwg8+bbpMBdPEgsQhTtZ3ndxtUYUi5EdeJNzWLrJiV4hIP
         iMcwmx8R7byFwn4PWAUOgdI299yjPtliLCi21Fcz336pv/EZ/DlbzQ2xSBA8imRBs1dL
         1roLcvzjhDNKdSOcyVZbTbkHjInZX1+DomP5zOACYOghQBc6LLDDFzQ4nfqwt9T3luSU
         zSlZj7yLjnSpUTUad1325CCbAKUvV4kNCo/YCFLJEKVtt3ht+w+iLPIZq1ASdqj968ck
         A1eGktAjzGy0oNus2M1VE2Dv44ujeLzsMgPYP+efgTAMvDWXq4U+112Els4GwTtzwLVx
         im7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PhFFzUYuu3kiiGwxciZFZrbqQ/Aj7BOjCk2nVZt0710=;
        b=UdrdNrXi2RojZmrqXRj9VPFStyBZzDwvp/bbwMjK0kx3ZYDH4FDE7/SYjJn6U/mZNA
         V2YTVwEuKNKW/pKzfQ2roTN3KMkiRJ714eMmze1bmI+VGAE1mrrNuz6z7FUejvkBmFDD
         JS7oD9Yz615v3kALqvumxxdfhvbu4SD+DjgI9ey7NDxh2RUeSSFdJdA6oSfEyOHmJvIw
         pMNFBMcuiD6T9VssvJfZa8T1kaZZx/ZDx+3/UHiUHSFM/vXrksnYikAUHLp1gwi17UMb
         gzIDK41MP+51FOZeP2HCQAGYk8uLlwrJC6lQF9PS+7GVQRYsOIE0pWvIMidqc5VUMdtZ
         YKXg==
X-Gm-Message-State: AOAM532AWJH0eLIW7OBQtLo6I/oMD8jCaqdfLHzYatNKR82YUtlZqwSO
        Ey7NirWvF0PCG7kBxvK6NUtQkz0MyG1QOaXqvw==
X-Google-Smtp-Source: ABdhPJzKRLpCSzDaueG5CwyyJeVapLdoS8niSbvWw+S0uNdSEUTnE4Emdy6VYZnaV62W4DbRhEOQb0+vcHOh8yj3Qsw=
X-Received: by 2002:a9d:3e6:: with SMTP id f93mr1178709otf.340.1606170202534;
 Mon, 23 Nov 2020 14:23:22 -0800 (PST)
MIME-Version: 1.0
References: <20201120181627.21382-1-george.mccollister@gmail.com>
 <20201120181627.21382-3-george.mccollister@gmail.com> <20201120193321.GP1853236@lunn.ch>
 <CAFSKS=P=epx3Sr3OzkCg9ycoftmXm__PaMee7HWbAGXYdqgbDw@mail.gmail.com>
 <20201120232439.GA1949248@lunn.ch> <CAFSKS=M-2rwM2UC58xf8n0ORuwxHq06BjLj7QP=JuU19-tCpGg@mail.gmail.com>
 <20201123220914.GC2036992@lunn.ch>
In-Reply-To: <20201123220914.GC2036992@lunn.ch>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Mon, 23 Nov 2020 16:23:10 -0600
Message-ID: <CAFSKS=NfbfJs4hk1Ao3yjVukE+kU_7E9Zck8oNOWzEOgtKEp-A@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net: dsa: add Arrow SpeedChips XRS700x driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 4:09 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > > > https://www.flexibilis.com/downloads/xrs/SpeedChip_XRS7000_3000_User_Manual.pdf
>
> Section 6.1.4
>
> The forwarding decision is presented in Figure 19. Note that also
> frames coming into a disabled port are received to the buffer memory,
> but because their forwarding decision is not to forward them to any
> port, they are dropped.  This behavior however can be changed, and
> frames can be forwarded from disabled ports to other ports by using
> Inbound Policy (see Chapter 6.1.5).
>
> Sounds promising. And Section 6.1.5:

Indeed, I missed this.

>
> Inbound Policy checks the source and the destination MAC addresses of
> all the received frames. The user can configure through the register
> interface what kind of a treatment should frames with certain source
> or destination MAC addresses get. Many protocols use protocol specific
> multicast MAC addresses and the destination MAC address can therefore
> be used for forwarding those frames to CPU port and not to other
> ports.
>
> Looking at table 36, i think you can add a match for the BPDU
> destination MAC address, and have i forwarded to the CPU port.

I'll give it a try.

>
> Looks like you can add 15 such filters. So you might want to think
> about how you want to use these, what other special packets do you
> want to allow through?

Okay.

>
>             Andrew

Thanks!
