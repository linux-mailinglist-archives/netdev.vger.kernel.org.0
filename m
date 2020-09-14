Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F085268279
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 04:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbgINCNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 22:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgINCNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 22:13:36 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75AC8C06174A
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 19:13:35 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a9so4660436pjg.1
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 19:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=NTPEhSTHlRsn+Cr9ilSj+EM6hitMM44IwHm5ITwwFyY=;
        b=MxlbuPZImhwgz1/KkQsCtpWd69+Vk4LNfsIL1smDk0f/vodky9XyMh9DULU3t55a5Y
         y78Tz3mMLN2otwjgLxSOdbOLNt2IuC5CuFBcDYOHnb4c9hDPgZLYYLwkyCKjK5mVaSWY
         B41MRnZUS7OlkFB22Jvju5zrllrdFuM2OQwh9lN+hr5IM4Zvc0fi5NWCKCshRW8bOMpE
         Qc36gU5Hfo7cU9vIvGSa8j3nIYqPfiwJZn+VduSbGfB8clTvBp5efJLg39oObGt/LxdZ
         EIg9etPuQ3y3BXfWTECz4a4LJHDNBdM5Bi9fBsNNrDrIVvrXUrYoK6No5tqyxQLBtKgD
         ZeWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=NTPEhSTHlRsn+Cr9ilSj+EM6hitMM44IwHm5ITwwFyY=;
        b=kVtqJ1Wvxcnb5LBY2ZfqS4x/43/mZfGQBhWWZc13qOCjEpD67Tavn72iHE9MDhnhfc
         pKqxaOpMHb3RoEw/ZtXKEBXf3lRnJtX+22sT2Kw8s72tdD4C7bYt2LbbkaQB3EN545az
         Da9RXI+8tLrfLHJuejZOvfDztD1e2500tPtREdn7ZZyPDUzcD3vLFUnMdCQtNepjtY4e
         3LhCsaqj3uMQ0Px+BaNK/U28hbKz5zTt7Ort/Y1eZKgj5rJcTXom5sYVu0XUOuJIwBVs
         p3gqN/PzLZ4pEQjilr9ShbnfvzSidhCLfOn3hILLgRCPYei98ynmrj285uqeHyXUOfA3
         hoQw==
X-Gm-Message-State: AOAM531Lj1JG2OIiVzOXHWMGLFPxOjnpoGl1BroqvdPrvnWIf6CwZ0oa
        O3g6ZyZK2kg6m0UGCSzDH5hUjeA3LGIeYuYs2dUaCiKVc5D2Ng==
X-Google-Smtp-Source: ABdhPJwPmDs31o3K2/y1tjcMZou2BVHfgm37DJtiS4Lu/KcTILWqFACtnVlH7NvcUpGunLOFo5I7Y9Xkfx9Jzfs90Nc=
X-Received: by 2002:a17:90a:d704:: with SMTP id y4mr12510199pju.159.1600049614763;
 Sun, 13 Sep 2020 19:13:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAB4CAwfqbaR7_ypZDp=hi_3u_F2E5eYv5ExUoSPK97qcTxiWZQ@mail.gmail.com>
In-Reply-To: <CAB4CAwfqbaR7_ypZDp=hi_3u_F2E5eYv5ExUoSPK97qcTxiWZQ@mail.gmail.com>
From:   Chris Chiu <chiu@endlessm.com>
Date:   Mon, 14 Sep 2020 10:13:24 +0800
Message-ID: <CAB4CAwezTL6LeUeW5QApC4AVyu2t-pH1CBQSNMPCMC6VXZTX4A@mail.gmail.com>
Subject: Re: mt7615: Fail to load firmware on AZWAVE-CB434NF module
To:     sean.wang@mediatek.com, ryder.lee@mediatek.com,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        nbd@nbd.name, lorenzo@kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 8, 2020 at 8:33 PM Chris Chiu <chiu@endlessm.com> wrote:
>
> Hi Sean, Ryder,
>     We have an ASUS laptop X532EQ with the wifi module AZWAVE-CB434NF
> which fails to bring up the wifi interface on kernel 5.9.0-rc1. The
> dmesg shows the firmware load error.
>
> [   25.630850] mt7615e 0000:2d:00.0: Message -4294967280 (seq 1) timeout
> [   25.630851] mt7615e 0000:2d:00.0: Failed to get patch semaphore
> [   25.630853] mt7615e 0000:2d:00.0: mediatek/mt7663pr2h.bin not
> found, switching to mediatek/mt7663pr2h_rebb.bin
> [   46.111154] mt7615e 0000:2d:00.0: Message -4294967280 (seq 2) timeout
> [   46.111178] mt7615e 0000:2d:00.0: Failed to get patch semaphore
> [   46.111179] mt7615e 0000:2d:00.0: failed to load mediatek/mt7663pr2h_rebb.bin
>
> The lspci information for the device shows as follows
> 0000:2d:00.0 Network controller [0280]: MEDIATEK Corp. Device [14c3:7663]
>         Subsystem: AzureWave Device [1a3b:4341]
>         Flags: bus master, fast devsel, latency 0, IRQ 177
>         Memory at 6032100000 (64-bit, prefetchable) [size=1M]
>         Memory at 6032200000 (64-bit, prefetchable) [size=16K]
>         Memory at 6032204000 (64-bit, prefetchable) [size=4K]
>         Capabilities: [80] Express Endpoint, MSI 1f
>         Capabilities: [e0] MSI: Enable+ Count=1/32 Maskable+ 64bit+
>         Capabilities: [f8] Power Management version 3
>         Capabilities: [100] Vendor Specific Information: ID=1556 Rev=1
> Len=008 <?>
>         Capabilities: [108] Latency Tolerance Reporting
>         Capabilities: [110] L1 PM Substates
>         Capabilities: [200] Advanced Error Reporting
>         Kernel driver in use: mt7615e
>         Kernel modules: mt7615e
>
> I also tried the latest linux-firmware with the most up to date
> mediatek firmware
> https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/commit/?id=7a237c6ee2c7af48723c356461ef80270a52d2c6.
> But still get the same error.
>
> Any suggestions on what I can do here?
>
> Chris

Gentle ping. What should I do for the next step?
