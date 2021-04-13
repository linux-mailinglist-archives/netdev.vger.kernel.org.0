Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C298435E805
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 23:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346593AbhDMVHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 17:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344575AbhDMVHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 17:07:44 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86ED4C061574;
        Tue, 13 Apr 2021 14:07:24 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 12so9476031wmf.5;
        Tue, 13 Apr 2021 14:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+h9YEJvRri5MunnYFCNIxEPQwGH0MaRhmpl1ZOUzYuc=;
        b=QLrvrJ9MZ7YQLbbwmC4On25zNCD1Dzr1A71vyEp5yZFnnXeMTRzIiZ0IZWH2MCKzHk
         O+KA0EJTfbdCPxUi/EUqHFOd9VSjpYRIs7AeHhFu9fTyRXVpVwAiajt8J9/i1XsL2mIA
         tPdbl8sYSHYYvyLcqaDEZ2TSYVVCX2UwWyZnYAwo2xCyWyeRrv3Po+NhDUVisRQToobd
         oDmG+MtStwrO1H4ok65Ak/Ed44xT6uwvgSiE6jdU1LJRX/T6QAPamRW+rO2kZ6mRO8ZC
         hlqXmRk/s5TPcx61aRBJowBOhPq2dPpNB7QeFx1EMAmXBt/i3+tI1pxC+C3fhyHioF1D
         0Tng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+h9YEJvRri5MunnYFCNIxEPQwGH0MaRhmpl1ZOUzYuc=;
        b=fA34Y7EjHK0jfXYoTZySt8BeYSGpxy55wyzrrh3xEW0ZIf5035YSW8Iz15KfHZj7/+
         vggdgDToUWYAQECtBcod5GdJY/Khdwq3AtllmT1ATS46ANMty+jG2KRuHYDRMOwBbbpF
         nuk7djwht4eEekqVIv8K7hTmZvV/NrO/oT9cJWD1QopWI3K+LlKFhFm9lCNLVpl3bdkk
         Fb2rsOKQWO6u1YEb2Rf+4KpjroTcTlemcHtMYU711SBJxPySdKmZUTNYMMNrnaVKlijr
         juYUpIzi564QdxpmWQLttqL+YAxX+ktpBA/xNncPYU678UuV2zlOm1hyZDs0QnAM6hw0
         z3jA==
X-Gm-Message-State: AOAM5307KrYg/HJ6I2Ktaa+q2BmKmHf2P2NZP9lgoDsmPy8Dm0WCtoUf
        QL4AT9qAyAnan7tAzCj3ZzpKtEyETEcqDg==
X-Google-Smtp-Source: ABdhPJzfn+xHHTrmxu827y62FEPvzLG8WSdpdoydcXf+QrSWNDukJBSBIv8cCXOoys7jBlSPfraWyg==
X-Received: by 2002:a05:600c:4f55:: with SMTP id m21mr1745111wmq.11.1618348042932;
        Tue, 13 Apr 2021 14:07:22 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:858c:dcb8:c991:8e09? (p200300ea8f384600858cdcb8c9918e09.dip0.t-ipconnect.de. [2003:ea:8f38:4600:858c:dcb8:c991:8e09])
        by smtp.googlemail.com with ESMTPSA id z15sm14933279wrv.39.2021.04.13.14.07.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 14:07:22 -0700 (PDT)
Subject: Re: [BUG]: WARNING: CPU: 5 PID: 0 at net/sched/sch_generic.c:442
 dev_watchdog+0x24d/0x260
To:     Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Realtek NIC <nic_swsd@realtek.com>,
        NETDEV ML <netdev@vger.kernel.org>,
        KERNEL ML <linux-kernel@vger.kernel.org>
References: <8ab3069a-734f-80ee-49a0-34e1399d44f1@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <b828de51-3932-1264-dfd3-eb7af2a5c539@gmail.com>
Date:   Tue, 13 Apr 2021 23:07:17 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <8ab3069a-734f-80ee-49a0-34e1399d44f1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.04.2021 22:59, Xose Vazquez Perez wrote:
> A non-recurring bug, on 5.11.12-300.fc34.x86_64 (Fedora kernel).
> 
> Thanks.
> 
> 
> 0c:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller [10ec:8168] (rev 06)
> 
> [    2.968280] libphy: r8169: probed
> [    2.968844] r8169 0000:0c:00.0 eth0: RTL8168e/8111e, 2c:41:38:9e:98:93, XID 2c2, IRQ 47
> [    2.968849] r8169 0000:0c:00.0 eth0: jumbo features [frames: 9194 bytes, tx checksumming: ko]
> [    4.071966] RTL8211DN Gigabit Ethernet r8169-c00:00: attached PHY driver (mii_bus:phy_addr=r8169-c00:00, irq=IGNORE)
> [    4.323834] r8169 0000:0c:00.0 eth0: Link is Down
> [    6.729111] r8169 0000:0c:00.0 eth0: Link is Up - 1Gbps/Full - flow control rx/tx
> 
> [106378.638739] ------------[ cut here ]------------
> [106378.638757] NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed out

This is a standard tx timeout and can have very different reasons.
Few questions:

- Is this a regression? If yes, can you bisect?
- Can you reproduce it? If yes, which type of activity triggers it?
