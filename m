Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D031C3D36DF
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 10:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234455AbhGWH4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 03:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234276AbhGWH4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 03:56:05 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD2EC061575
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 01:36:38 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id u8so2531449plr.1
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 01:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=8Fh1AmsX8lTEP6wAub3MAWGaox9nC2Imv6c0kMa0AgI=;
        b=tbUodMwhfJGxDSwsfLzYLgCQn6CCPlaUQlVB0sdl2F/gzOAWVmqgR+uSdAaZWBM9XF
         8UPrpsB+XdtVGrIE6K3PyNr51S94qrrOD67i3b8kDPEYDnETR7MY4sm77T4T5HG+vEsC
         JqbtCFLkO00Df4qxf4/jKOhHy9OMJYM4Zm4ATXz+SBodZ37clx6A3Da7KHlhDw9dJh7q
         xHB36WGC/5vkJLd8wSfNFBLxcv6XM/sh+HTn9sdym30TcuV23HeGliOlqfJ8gvAANeJj
         5QCS26CEGIR1xM1MOa7kmxZpUw82iZLmrQ3ca09sgCkmEjhS2ex0q5hQMgGcI6P0hM1N
         prSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=8Fh1AmsX8lTEP6wAub3MAWGaox9nC2Imv6c0kMa0AgI=;
        b=itSKsXmNZL2Wvf8BFXfdNAt1BCfMcsTobyLL/E5aiE/0h3fSnmkNosbC1ZpJzSEAk2
         5WrFQAgkcLNBjtkcKeY3qn+eh5VwBoeJ1/KtYMu5dVJwb/5j8Cbf/O4PsZAwVPzv+zU5
         JfxcPpRr2lNrJqkbG8wydBtpYvX3CabZRCELEP8aAqYMmCegjsmGBhDBK1sNxdxPRxTo
         3f1VuC13cEAHi9VqTzdZOVx9Kc5PX7RalrWOyLwbDNWv9RXUZ3FLeqAh6fSWA68GtLr2
         vTtk0cjIFa1ecscDXhmNOBOC+TKkq/kVW86NFQrrqx0aIvqtnZjLhHc9fJyhFSDMtfUa
         DaVQ==
X-Gm-Message-State: AOAM531ErqbN3DencRoHU7cksZMmVGLnMytEv4R4vfA2OxP1cXIkEmk6
        kqSK+0MWVS6R/ItwY9GUiRWBZ6Yt2HnnJMFbYQ4=
X-Google-Smtp-Source: ABdhPJyvfCG0AGIzIXKrX6VoaanQvbBIKvI5Rjg9UdlPtTp0w3SXk7esiDvJ8b0qEQ9nr3uyInrSjhTc9lPf+emKAVs=
X-Received: by 2002:a63:fb08:: with SMTP id o8mr3885063pgh.72.1627029397893;
 Fri, 23 Jul 2021 01:36:37 -0700 (PDT)
MIME-Version: 1.0
Reply-To: jabbarqasim39@gmail.com
Sender: julia.flesher.koch@gmail.com
Received: by 2002:a17:90a:9f46:0:0:0:0 with HTTP; Fri, 23 Jul 2021 01:36:37
 -0700 (PDT)
From:   Jabbar Qasim <jabbarqasim673@gmail.com>
Date:   Fri, 23 Jul 2021 08:36:37 +0000
X-Google-Sender-Auth: Gx4TBkSNKSkd0jwcv5lqFOhoadE
Message-ID: <CANMrOi-GmYJfmr33N891EybqF-CzSR_bzbmZ50enry5rdZfPfw@mail.gmail.com>
Subject: Reply me very urgent
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings,

I know that this mail will come to you as a surprise as we have never
met before, but need not to worry as I am contacting you independently
of my investigation and no one is informed of this communication. I
need your urgent assistance in transferring the sum of $13,300,000.00
USD immediately to your private account.The money has been here in our
Bank lying dormant for years now without anybody coming for the claim
it.

Best Regards,

Mr.Jabbar Qasim
