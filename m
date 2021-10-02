Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C89FD41F983
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 05:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbhJBDbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 23:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbhJBDbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 23:31:51 -0400
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD53C061775;
        Fri,  1 Oct 2021 20:30:06 -0700 (PDT)
Received: by mail-ua1-x92e.google.com with SMTP id u5so5121860uao.13;
        Fri, 01 Oct 2021 20:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nhqob+ur3rl0nxfWA04tovJKHGNP9BJv5OHGstDKmoc=;
        b=UTwsGCidGCtibwg4D4HEx/ouCa1Mjc8urrZFalPGzW2G1fQWfPoQgwXITyOHU7ZL3n
         lmfV0lydxZJzComRtbUhx6wGjocRzhSHvJxbgbouIbIpRg/FxSGdv9pQ9+esN1GjHqfu
         ldMMXBeJN+0ORbKp0i3EG8rNvK71BMgII9F3rVf+oYV1ailbXhliXullv2VxjYtVU4Bg
         Ir5TmC23utopp4k7/aIxhTSR8XnPM4TdKac9WwPJJsMvpOB4BpwuaY9lLrkj4A1uWylp
         g7UaNuNvZXR4GUMiXcL/KR7tzrAsi14Z12+/7jLWcSb5kxoHJvbxzAdqtnI+GhbKAocs
         2drQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nhqob+ur3rl0nxfWA04tovJKHGNP9BJv5OHGstDKmoc=;
        b=iRgMHG4rycbp/MAMMKwrqFHUKq0GlnCbwvjwNUsR8gvYXcDjLNmfswdZHkXlefz1Sv
         DaluhmZkZHNr9sqaIu51/kOeI+oUAJBHae4+lOMl+ZRn84Ws4TG8Z4QEGDknM/enOjG5
         JYYlT2MwaFBSweuq2vn84lCd2ewpM+5v2NwGaI2ejq5Uq9E3wmTDepfsP08RdkL1GZhm
         ENX5/XbXVCQG6cE3OFX0/ugGY5VAYRy+Z3uPDAQeadla7kPHW47hAwMJ6HAeMpg0gBA9
         DDyj84XxdtE+98qbSdLFsJgzwd7aNnvycEvB3NBeFQ86N5ifIpTIfCPHs6HATgJymIIz
         94MA==
X-Gm-Message-State: AOAM531qrtxs0N2KosG2y06bRJgO9iGPdYuZHsqvH6/gxqvnZzXpApSS
        ShxfRGJlQ3mZtn+xVr5YSy4mrg2SQyoJeppRPuwBBTHy
X-Google-Smtp-Source: ABdhPJy79Dw+OO2YfsHrA/OjhtGkr/PsgJV8DYVt/zZmhqbYau6QUdppf/SvopYtdMX8sgshzPSsHbHVa5PT2zO02Yw=
X-Received: by 2002:ab0:2b13:: with SMTP id e19mr854835uar.3.1633145405736;
 Fri, 01 Oct 2021 20:30:05 -0700 (PDT)
MIME-Version: 1.0
References: <20211001230850.3635543-1-luiz.dentz@gmail.com> <20211001201128.7737a4ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211001201128.7737a4ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 1 Oct 2021 20:29:54 -0700
Message-ID: <CABBYNZLE-iVAT0Tt1aJK9VqYhWPYJeSTiWh6s2HTeqyQczMbVQ@mail.gmail.com>
Subject: Re: pull request: bluetooth 2021-10-01
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Fri, Oct 1, 2021 at 8:11 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri,  1 Oct 2021 16:08:50 -0700 Luiz Augusto von Dentz wrote:
> > bluetooth-next pull request for net-next:
> >
> >  - Add support for MediaTek MT7922 and MT7921
> >  - Enable support for AOSP extention in Qualcomm WCN399x and Realtek
> >    8822C/8852A.
> >  - Add initial support for link quality and audio/codec offload.
> >  - Rework of sockets sendmsg to avoid locking issues.
> >  - Add vhci suspend/resume emulation.
>
> Lots of missing sign-offs from Marcel:
>
> Commit 927ac8da35db ("Bluetooth: set quality report callback for Intel")
>         committer Signed-off-by missing
>         author email:    josephsih@chromium.org
>         committer email: marcel@holtmann.org
>         Signed-off-by: Joseph Hwang <josephsih@chromium.org>
>         Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>
> Commit ae7d925b5c04 ("Bluetooth: Support the quality report events")
>         committer Signed-off-by missing
>         author email:    josephsih@chromium.org
>         committer email: marcel@holtmann.org
>         Signed-off-by: Joseph Hwang <josephsih@chromium.org>
>         Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>
> Commit 93fb70bc112e ("Bluetooth: refactor set_exp_feature with a feature table")
>         committer Signed-off-by missing
>         author email:    josephsih@chromium.org
>         committer email: marcel@holtmann.org
>         Signed-off-by: Joseph Hwang <josephsih@chromium.org>
>         Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>
> Commit 76a56bbd810d ("Bluetooth: btintel: support link statistics telemetry events")
>         committer Signed-off-by missing
>         author email:    chethan.tumkur.narayan@intel.com
>         committer email: marcel@holtmann.org
>         Signed-off-by: Chethan T N <chethan.tumkur.narayan@intel.com>
>         Signed-off-by: Kiran K <kiran.k@intel.com>
>         Signed-off-by: Joseph Hwang <josephsih@chromium.org>
>         Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>
> Commit 0331b8e990ed ("Bluetooth: btusb: disable Intel link statistics telemetry events")
>         committer Signed-off-by missing
>         author email:    josephsih@chromium.org
>         committer email: marcel@holtmann.org
>         Signed-off-by: Chethan T N <chethan.tumkur.narayan@intel.com>
>         Signed-off-by: Kiran K <kiran.k@intel.com>
>         Signed-off-by: Joseph Hwang <josephsih@chromium.org>
>         Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>
> Commit 81218cbee980 ("Bluetooth: mgmt: Disallow legacy MGMT_OP_READ_LOCAL_OOB_EXT_DATA")
>         committer Signed-off-by missing
>         author email:    brian.gix@intel.com
>         committer email: marcel@holtmann.org
>         Signed-off-by: Brian Gix <brian.gix@intel.com>
>         Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>
> Commit 0b59e272f932 ("Bluetooth: reorganize functions from hci_sock_sendmsg()")
>         committer Signed-off-by missing
>         author email:    penguin-kernel@I-love.SAKURA.ne.jp
>         committer email: marcel@holtmann.org
>         Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>         Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

I suspect those fixed and force pushed since I originally applied them
given them all have my sign-offs, is this a blocker though?

-- 
Luiz Augusto von Dentz
