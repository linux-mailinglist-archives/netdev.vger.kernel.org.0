Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7C26261D49
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 21:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732315AbgIHTe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 15:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730986AbgIHP5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 11:57:30 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54856C06138B
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 05:33:14 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id n3so8693054pjq.1
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 05:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=iDh5oerIwDKilwa4JO3Vp5i5/Awtl6AjVqpak4FAWc8=;
        b=Gbr4FBBBQDv9ZAtzDnFOa+KkTbb0lywtPcVM6jMh7dHNvzODW30O5NBlRmaCwFHKyn
         1axKQY2tHW6AeOingHWn2FQmItKgZ4NXXQgRucqrgi3lgZJVlW+4QX9TNlECVeYGwizT
         hmdTDX1yap1u/4k4im5Xpwu7qkVi8ByuDoIFyOV3XWcjKMBHMEb7dRvX+d9pKyujloiL
         W++OjYGQYtoZxvhTlDxmW7iQmuBwI/KtZ9zgL/YFq30w3BTXLmPotQZ9BEx4wzIiL/G9
         sU0VqUXAmWPW3cPtyuvGXd1lQDPTQG4qKzsXp2vxhSIhZXyoHMaeC5h08bjdnzpDGJEC
         MEfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=iDh5oerIwDKilwa4JO3Vp5i5/Awtl6AjVqpak4FAWc8=;
        b=ahQ2bn57lqMYuwDeBfaKdV2U2cRyVz9VBoE+W+C2DqGJroNEgAlAuVkYm0yrUVPgVn
         xjEdDpSQPMmaHvY4axn+nDzgzA/LxN+oBFplsirVdo7qy+staaee/j38LVusYx2jFOQQ
         UsuniN1Sjjbwafh1tEqH8XPOD8YtdD2BbZzmAPfbIS8wSXbXli2Gysl0POl5YHq/tGcS
         KH6dCxCqxceWoza8MV2scRZmDLGBcPFWZo77qJgfLFn0pSXiYGQUr1Rhzhz8E9PAe65k
         2D0g0PRowayCIR58VqcHOol27HOFnYuOQxIoqBn2CIefMjCcbhcisYgjyFSR0nzH2oFY
         dZKg==
X-Gm-Message-State: AOAM530qsZIM7r4GiTtJDkgFFr1qjFByc1Vg7M5gy0cAQ7qNgmQlNp7m
        Cw6JYBT8wc80H+VrgCs+hyfd0zGsE17uSvmgcc/65w==
X-Google-Smtp-Source: ABdhPJzisWqjC8V6say/8z120ClJ8mNkK3sLAFliQAtEk7eFToZXeLaQo6/FMzQPo0hM+if6DS5Fyz+HqMD0bqPrlrE=
X-Received: by 2002:a17:90a:9292:: with SMTP id n18mr3950216pjo.159.1599568393391;
 Tue, 08 Sep 2020 05:33:13 -0700 (PDT)
MIME-Version: 1.0
From:   Chris Chiu <chiu@endlessm.com>
Date:   Tue, 8 Sep 2020 20:33:02 +0800
Message-ID: <CAB4CAwfqbaR7_ypZDp=hi_3u_F2E5eYv5ExUoSPK97qcTxiWZQ@mail.gmail.com>
Subject: mt7615: Fail to load firmware on AZWAVE-CB434NF module
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

Hi Sean, Ryder,
    We have an ASUS laptop X532EQ with the wifi module AZWAVE-CB434NF
which fails to bring up the wifi interface on kernel 5.9.0-rc1. The
dmesg shows the firmware load error.

[   25.630850] mt7615e 0000:2d:00.0: Message -4294967280 (seq 1) timeout
[   25.630851] mt7615e 0000:2d:00.0: Failed to get patch semaphore
[   25.630853] mt7615e 0000:2d:00.0: mediatek/mt7663pr2h.bin not
found, switching to mediatek/mt7663pr2h_rebb.bin
[   46.111154] mt7615e 0000:2d:00.0: Message -4294967280 (seq 2) timeout
[   46.111178] mt7615e 0000:2d:00.0: Failed to get patch semaphore
[   46.111179] mt7615e 0000:2d:00.0: failed to load mediatek/mt7663pr2h_rebb.bin

The lspci information for the device shows as follows
0000:2d:00.0 Network controller [0280]: MEDIATEK Corp. Device [14c3:7663]
        Subsystem: AzureWave Device [1a3b:4341]
        Flags: bus master, fast devsel, latency 0, IRQ 177
        Memory at 6032100000 (64-bit, prefetchable) [size=1M]
        Memory at 6032200000 (64-bit, prefetchable) [size=16K]
        Memory at 6032204000 (64-bit, prefetchable) [size=4K]
        Capabilities: [80] Express Endpoint, MSI 1f
        Capabilities: [e0] MSI: Enable+ Count=1/32 Maskable+ 64bit+
        Capabilities: [f8] Power Management version 3
        Capabilities: [100] Vendor Specific Information: ID=1556 Rev=1
Len=008 <?>
        Capabilities: [108] Latency Tolerance Reporting
        Capabilities: [110] L1 PM Substates
        Capabilities: [200] Advanced Error Reporting
        Kernel driver in use: mt7615e
        Kernel modules: mt7615e

I also tried the latest linux-firmware with the most up to date
mediatek firmware
https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/commit/?id=7a237c6ee2c7af48723c356461ef80270a52d2c6.
But still get the same error.

Any suggestions on what I can do here?

Chris
