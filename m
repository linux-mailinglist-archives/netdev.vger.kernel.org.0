Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A212F2B5E
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 10:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405880AbhALJd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 04:33:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392649AbhALJdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 04:33:55 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3062CC061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 01:33:15 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id m12so2324889lfo.7
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 01:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IqiZEbRQcwCtjD1LO6y+NMBTL0OXveAwwo9Y+0t4/Xg=;
        b=J2CXhZ5hYfWH6CK+TGLl0DK1GDcUhb2Fz75Rz0HN3IRbADE90b2r2FKxLXk7FwxqIT
         JQMGHoPxDU2yTR73FC3d+VS6iqUXFNZSMmFCD551yn4wEpjuXwPPLr1Uk2RXVzJXqmPH
         aej/Z9fCEHyhnkCvtbE+kQ2RBtbuSe8W9NPJ6vEHJu2k5IFq1UUECen8tSsgrkW4KNdl
         JrF7fER1yl0MyBGV7E75V5rtMZ4uokOMTf8TEOZk76eeEDIFWRDceshxdzBn0hMUj4d7
         krFdABkh0G1Ss0/wtY8wkb9Pa71nZnrbqdIH8gSHwLC+HM1uXXDjHT51PPyqJPt7K0i/
         f+4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IqiZEbRQcwCtjD1LO6y+NMBTL0OXveAwwo9Y+0t4/Xg=;
        b=GdyJkATKvYhqmWghEaxc9PPKe2fHQuTBBvEmh4xXt+lmHr9COjFTFs371CHa5vLriO
         oOIotq8wzOTAuwOZgW3IbXuP3ANL2cSTqWsfzsAr3nrXiYdE/QlIm28HlzUUdMbO8z4U
         dbXOqmj7TCAEkTA4M5HkS5nLbTQHFt1FIXfyl7TqDqtWlZkdv5QHoC8xllp8FRsa+Eim
         ow2Aj4PC1zOtnykltTWn/jQvIZ4UOYAblnXpJoRSHT0qPfgPCqTHmekMyMJaZOiLvaWS
         pATyuXUA9v1vKY4KfD0Y0iy07pcGXb+jfv7/9/E1jF4n7NSTwgRq0wNAA/25KoEUkxnU
         qtvw==
X-Gm-Message-State: AOAM5321O3VVjDN8a5xowWKBTetZ9PzVeGWRL5AMaOn/76r4lYEDGWJo
        EEfbaDt1hOyKGFAVtTo2KZx6KoM22cWL/MMYUNu9og==
X-Google-Smtp-Source: ABdhPJyyXORht4jpPyJMKyduwAn/uvJKQn5+vRCiYXf3HRLBztOxZYK+F75neMbfn1F422xk8qRu2RxTtGYgbMXcOjc=
X-Received: by 2002:a19:495b:: with SMTP id l27mr1662837lfj.451.1610443993417;
 Tue, 12 Jan 2021 01:33:13 -0800 (PST)
MIME-Version: 1.0
References: <20201222102629.1335742-1-apusaka@google.com>
In-Reply-To: <20201222102629.1335742-1-apusaka@google.com>
From:   Archie Pusaka <apusaka@google.com>
Date:   Tue, 12 Jan 2021 17:33:02 +0800
Message-ID: <CAJQfnxFX0-uJG7Ds7Jxmyfpbq4EHWdEWW3=QqcXMOHu2oWT9Dg@mail.gmail.com>
Subject: Re: [PATCH v5 0/5] MSFT offloading support for advertisement monitor
To:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi maintainers,

Gentle ping to review this patch, thanks~!

Regards,
Archie


On Tue, 22 Dec 2020 at 18:26, Archie Pusaka <apusaka@google.com> wrote:
>
> From: Archie Pusaka <apusaka@chromium.org>
>
>
> Hi linux-bluetooth,
>
> This series of patches manages the hardware offloading part of MSFT
> extension API. The full documentation can be accessed by this link:
> https://docs.microsoft.com/en-us/windows-hardware/drivers/bluetooth/microsoft-defined-bluetooth-hci-commands-and-events
>
> Only four of the HCI commands are planned to be implemented:
> HCI_VS_MSFT_Read_Supported_Features (implemented in previous patch),
> HCI_VS_MSFT_LE_Monitor_Advertisement,
> HCI_VS_MSFT_LE_Cancel_Monitor_Advertisement, and
> HCI_VS_MSFT_LE_Set_Advertisement_Filter_Enable.
> These are the commands which would be used for advertisement monitor
> feature. Only if the controller supports the MSFT extension would
> these commands be sent. Otherwise, software-based monitoring would be
> performed in the user space instead.
>
> Thanks in advance for your feedback!
>
> Archie
>
> Changes in v5:
> * Discard struct flags on msft_data and use it's members directly
>
> Changes in v4:
> * Change the logic of merging add_adv_patterns_monitor with rssi
> * Aligning variable declaration on mgmt.h
> * Replacing the usage of BT_DBG with bt_dev_dbg
>
> Changes in v3:
> * Flips the order of rssi and pattern_count on mgmt struct
> * Fix return type of msft_remove_monitor
>
> Changes in v2:
> * Add a new opcode instead of modifying an existing one
> * Also implement the new MGMT opcode and merge the functionality with
>   the old one.
>
> Archie Pusaka (5):
>   Bluetooth: advmon offload MSFT add rssi support
>   Bluetooth: advmon offload MSFT add monitor
>   Bluetooth: advmon offload MSFT remove monitor
>   Bluetooth: advmon offload MSFT handle controller reset
>   Bluetooth: advmon offload MSFT handle filter enablement
>
>  include/net/bluetooth/hci_core.h |  34 ++-
>  include/net/bluetooth/mgmt.h     |  16 ++
>  net/bluetooth/hci_core.c         | 174 +++++++++---
>  net/bluetooth/mgmt.c             | 391 +++++++++++++++++++-------
>  net/bluetooth/msft.c             | 453 ++++++++++++++++++++++++++++++-
>  net/bluetooth/msft.h             |  27 ++
>  6 files changed, 963 insertions(+), 132 deletions(-)
>
> --
> 2.29.2.729.g45daf8777d-goog
>
