Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61B7A31DF20
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 19:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbhBQSdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 13:33:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234916AbhBQSdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 13:33:21 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAB3C0613D6
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 10:32:41 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id l19so15969773oih.6
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 10:32:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=3Xng/SYJ/EvDfaWjGYI2omjC51Ent4LbZAYwA70zsec=;
        b=cK1lpmtBKTRKD82Uzd1PS66R/ni7KUhaS0ltU1zDRt6VWjCzAUc2XR8quCa5dTrZLb
         EhWw8GIllcKKId0WOLmMhoqskuB+qEVSWBdo1NthEtFNYnMcYNPzsbj4WV3lnS2a6505
         dlT1dYwMwkrMDEPRFl6Rrknv+8gYx7zmCv/gmgvxGK3AMoyiIgQ0QZeYAeqpWV/65OU4
         JPzc8kXNQ56VsvDXtg6e3Z5hTww9cn4bu9APVIUPbXbQ/YocBkWDi7aqZ6Al11NuyCo/
         KJr1YHgAADH5Mz3Ztgx5qf+fiFCVFSi8DXIX45VU1USSIGUKVqlWDkhv8qIjG5N+9MbR
         l1ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=3Xng/SYJ/EvDfaWjGYI2omjC51Ent4LbZAYwA70zsec=;
        b=Kn0aimJeJEsKFLpSvP4kVn2YgsMSPPH2Y7IXz9k0XzqH5Dyk5Ms5NkKv6g+8D+0933
         /FB1E4EZ2a4GYQOe8Q6aus6D637JpmXTDFGjvOmyvEOQCY9jSPgNqx0SiOlxLJTvEMO1
         KXBF58jDdlQYuNyYvKHEU4FypZA5X7knCCdYkkdh2dZHYo8ZujY3PS3cD4CvvPz4HHPO
         KMIVLImimDnON+cOYeieO1dpohO52CSvwx5DnK+OMhd/m8HVKUowpFd/nifnEPMKhNRs
         0fkEb3dQFWdxhq+E7JTsBYDJzzcHUFijJwtyYcIaVO2WlIlGLGlZmVjgEUqtWSS7azoL
         6Nuw==
X-Gm-Message-State: AOAM531hcCK5sBCTOe4o3K4mE+voMaNw8Dab4eXcMBbnRclGdjWV3Bm5
        gvQ4tbW/4huCCHJUIMkhTrI7twuq+kaTI6x8yQSz9/TO9mMTif3O
X-Google-Smtp-Source: ABdhPJye734NIPqGVtdwgyQtZy3eb+AU2hP5rMSqCl0iR/IHi9Uh7p4GertOsQd8ngu1+dV9/iF1jVGKuc1HAaJr8lg=
X-Received: by 2002:aca:7556:: with SMTP id q83mr146106oic.0.1613586759846;
 Wed, 17 Feb 2021 10:32:39 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 18 Feb 2021 00:02:28 +0530
Message-ID: <CA+G9fYtjWiqPaKNmXdyyO-W05BT5+OzG2=VGJyV7jGGah4k2TA@mail.gmail.com>
Subject: MIPS: net: mscc: ocelot: undefined reference to `packing'
To:     Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-mips@vger.kernel.org, lkft-triage@lists.linaro.org
Cc:     Jakub Kicinski <kuba@kernel.org>, UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mips defconfig build failed on today's Linux next 20210217 tag.

make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=mips
CROSS_COMPILE=mips-linux-gnu- 'CC=sccache mips-linux-gnu-gcc'
'HOSTCC=sccache gcc' uImage.gz

mips-linux-gnu-ld: drivers/net/ethernet/mscc/ocelot.o: in function
`ocelot_xtr_poll_frame':
drivers/net/ethernet/mscc/ocelot.c:(.text+0x1c08): undefined reference
to `packing'

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

build link,
https://builds.tuxbuild.com/1obrU4klh0OkIctHBFbxIwHO0Gd/build.log

-- 
Linaro LKFT
https://lkft.linaro.org
