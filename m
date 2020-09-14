Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 118D32698CC
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 00:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgINW37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 18:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbgINW34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 18:29:56 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D13C06174A;
        Mon, 14 Sep 2020 15:29:56 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id u48so396480uau.0;
        Mon, 14 Sep 2020 15:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3c4307dFtJoszJTzzblad9nRl3L9HSJ6wHovHTO2Naw=;
        b=SsGkUVnT+wyLYEMrJwbR5ahknAGSio/pvIsr0qxxUU+Tmf8oQQ/OJIGJalJfJcz9NX
         fAD+Nd2frRw6CsbIAoVbf3L3lHS9RWdESLtMcfV/ojJ2hsTbENzpfTSq0S/lxUwYTMJO
         rajCTHvwc/iX5WIVQgHC41LiOhBLGVbQVntDLi+OMJgZlNqantry/FtUl0B3qpehodcS
         oOCfnRK1MfC/NxpA2R+V1EJ72cZqPNpZslWuQRwLQd7sGkNg5dcjgja6XEwdgiTH4hdH
         0r+P0paYvndr81fUbdT9oFUZI06jMvvZZ8R3sACu1EdPiEQ7iLolAMRGdEtHe31wYpt0
         ZhVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3c4307dFtJoszJTzzblad9nRl3L9HSJ6wHovHTO2Naw=;
        b=SC3XitldwZpLY7pnmXgmb9ndwVCxjRaoTXPw9yY/X/5AEaz79n/bvjNkxeARNVkchZ
         L9cwrQ52b9T6CnjGhTJHx3KNe15Flicv9hVVFWkpErh+Mcc3LvtfDQPu6rMM62/HbnIu
         6qiOu1yoU+Lo4kM38OpFC84ClRH4EAt/jFDM6c34DlLgKsauHa8pFbovxxf0Jd1wv5K/
         vhqYtAdipXHe39+JHupJUJ8bS137Y43pwAMV2ov1x6EXUmtvM2KwBL+akjfIQnSe+r/j
         dbePNY+cIwxrUa2xnvQbHv/hzoqnR2QwWDwRF3wiTtDsPEK2MVsYnEfCxX5FzcRxp5w8
         I9YA==
X-Gm-Message-State: AOAM531c3VB/hY1NRz5TK+aDNUmWbibn55cG95i0y3HGoWFXK/6LX7rp
        0be5wohRnAeTfd9t2rmGNv1CkuYTB2fnErNW88zA/UgmfKc=
X-Google-Smtp-Source: ABdhPJxqARS58arVpo/LeqYIUHUkFptYIvBRvVTAWEvVSqNBBBXOz/v5p68ne13gWphGBZRYUSPimBdRHvR/8XzwxVc=
X-Received: by 2002:ab0:768:: with SMTP id h95mr8493828uah.23.1600122595847;
 Mon, 14 Sep 2020 15:29:55 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20200907173945eucas1p240c0d7ebff3010a3bf752eaf8e619eb1@eucas1p2.samsung.com>
 <20200825180134.GN2403519@lunn.ch> <dleftjwo15qyei.fsf%l.stelmach@samsung.com>
In-Reply-To: <dleftjwo15qyei.fsf%l.stelmach@samsung.com>
From:   jim.cromie@gmail.com
Date:   Mon, 14 Sep 2020 16:29:29 -0600
Message-ID: <CAJfuBxx1CvYqQkU1ypR0ePt9r0TTGLNp4rwwqPfsUwp0zx4H9A@mail.gmail.com>
Subject: Re: [PATCH 1/3] net: ax88796c: ASIX AX88796C SPI Ethernet Adapter Driver
To:     Lukasz Stelmach <l.stelmach@samsung.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >
> > Please you should not be using netdev_info(). netdev_dbg() please.
> >
>
> I changed most netif_msg_*()+netdev_*() to netif_*(), including
> netif_dbg() in several places. However, after reading other drivers I
> decided to leave this at INFO level. I think this is the way to go,
> because this is what user asks for and with dynamic debug enabled users
> would have to ask for these in two different places.

dynamic_debug_exec_queries is now exported,
allowing module authors full  >control of their debug
