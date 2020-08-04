Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C13423BEAC
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 19:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbgHDRMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 13:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726580AbgHDRL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 13:11:58 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6618C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 10:11:57 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id y17so6987938uaq.6
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 10:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NDe2U+JQQtlm6PkmOwl5fjQfHoZ0o3DW3eDHCm6kTvQ=;
        b=SoyMHVPkgxHGIyVFghEqt+dz76dWygdZK5qv96mgYHIB8BQDfnDSdlwicrCousdePt
         6kFYSc0n7RSJRhh/WbIBfAW1Mu0Sap9jaMdg6UlhNdK0k672HQpR0CmBGVutHlwlHgV+
         jMC83l8tqgA+ALlv4CakhMvyvvf1kF8Uhx/7c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NDe2U+JQQtlm6PkmOwl5fjQfHoZ0o3DW3eDHCm6kTvQ=;
        b=DctBhJ+X/zjTP5rNt3X6Rn3Cx1Brs4LQXAV0hFVfcsGVNb0CCvlawZGbZjg8J78aGY
         Op/vbRClFazdVuR21iNm+5WM/Koirq9InRsNRHfR6o3gBx+SmVwltzLreRcSlP/YgUoC
         9uxzBDA5zoS8dUOxbgSOE2uCDo5Dq2QWk4anAMoySHHRGP1NFcn0MCi3u2Nv5yu+3fNR
         4ivr5PLFxskfejGKdgY7ID46VbMA6i9FPLiANOqIJEwv2lkVRECDBk2L/hkD9BJrk0YL
         /2pTjkLzzLoThDzwqOkFiYPsiYEQeTk+jl+RCN/xPu33BZ9d+Yj8DX198XkAZSlAQUQP
         crxw==
X-Gm-Message-State: AOAM533xNpzISKBEDm4faal9rEl8Laz96XIZ+7Luqi/PF4WXA2XSEVhm
        aV3qm7JzI9JOp2k1iTrYuuDbjRwA6rDlSrLkqJ1fMg==
X-Google-Smtp-Source: ABdhPJzdxejwD5qJ3tvpESkSc0h2CyPb4WDolKHYh5SfDmcf4Fg5xK3WK/bLFsJz2MfIniAOjYF53pvHQqw0ach4VHA=
X-Received: by 2002:a9f:2197:: with SMTP id 23mr15629203uac.60.1596561115676;
 Tue, 04 Aug 2020 10:11:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200729014225.1842177-1-abhishekpandit@chromium.org>
In-Reply-To: <20200729014225.1842177-1-abhishekpandit@chromium.org>
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Date:   Tue, 4 Aug 2020 10:11:44 -0700
Message-ID: <CANFp7mV0TP-WbBWGSpduERaf9-KBXevhG7xKvjkMrqrtWWkZ5w@mail.gmail.com>
Subject: Re: [PATCH 0/3] Bluetooth: Emit events for suspend/resume
To:     Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Gentle reminder that this is waiting for feedback. Related userspace
changes are here to see how we plan on using it:
https://patchwork.kernel.org/project/bluetooth/list/?series=325777

Thanks
Abhishek

On Tue, Jul 28, 2020 at 6:42 PM Abhishek Pandit-Subedi
<abhishekpandit@chromium.org> wrote:
>
>
> Hi Marcel,
>
> This series adds the suspend/resume events suggested in
> https://patchwork.kernel.org/patch/11663455/.
>
> I have tested it with some userspace changes that monitors the
> controller resumed event to trigger audio device reconnection and
> verified that the events are correctly emitted.
>
> Please take a look.
> Abhishek
>
>
> Abhishek Pandit-Subedi (3):
>   Bluetooth: Add mgmt suspend and resume events
>   Bluetooth: Add suspend reason for device disconnect
>   Bluetooth: Emit controller suspend and resume events
>
>  include/net/bluetooth/hci_core.h |  6 +++
>  include/net/bluetooth/mgmt.h     | 16 +++++++
>  net/bluetooth/hci_core.c         | 26 +++++++++++-
>  net/bluetooth/hci_event.c        | 73 ++++++++++++++++++++++++++++++++
>  net/bluetooth/mgmt.c             | 28 ++++++++++++
>  5 files changed, 148 insertions(+), 1 deletion(-)
>
> --
> 2.28.0.rc0.142.g3c755180ce-goog
>
