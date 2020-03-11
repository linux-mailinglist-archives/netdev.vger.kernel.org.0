Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43D15181F1C
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 18:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730470AbgCKRU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 13:20:28 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:33646 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730322AbgCKRU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 13:20:27 -0400
Received: by mail-vs1-f67.google.com with SMTP id n27so1878253vsa.0
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 10:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MEkaiHQZMx1UJA9RPgEM4Gg2VNhyN6paaXR7j/Fo1Hs=;
        b=DxkJwdYB2pE55yk2uohYiCIxvUd2RfSY0xgbwxZSRdlVNQXspPc65ZzAEqaVwDUvvw
         HQvs8uHNlP3u+/LIioDnxGa26S8ZMPqF/OJv3pA2r5z5GqhGONIrzSHeT5rt/OumVHTY
         efB2XSO4fgf1K5Rft2dfoGNnenwPrk5roFVOE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MEkaiHQZMx1UJA9RPgEM4Gg2VNhyN6paaXR7j/Fo1Hs=;
        b=qoO0JqKgTS2G8IJlzwpONWIqmeSEIUFg4+7rPbhBe/FszvqssGSfDzXxb/feA1UomB
         E7h83KSoM8PqDESMczY7Fr7s7PE724VEafqCkyCQG0I6aqaq7g2mFj9KRvEQfUR+Kcmk
         YkuEp+95lPNeR4v8Lbx7MiOzQoykocm7Zyg8O+H1z4OT1A0rJW+BCScnWdMi5A8qMVgj
         K+5IgvtXTlAG2JLHk73tH/4ism3oOkYbtc2ELlvukg0KofIUI0Y4G88RCn2VnRo02f7L
         VVPqOxLM8QGkPA6vLPgf7YPQ5I3Kehqpc1glar11zsYlVlKuTcHBUjxnHhmT52Li94vA
         tFMg==
X-Gm-Message-State: ANhLgQ2s2U5UQBpw/EGpJvex8YwM/5K8F5JWaZmxPeYgwXfWbmkKUt9q
        x5cRPhxl1f5tGxVPcOuf0B+HoBdrc2APgE4J6wlV5g==
X-Google-Smtp-Source: ADFU+vsm48zQXYAH+XHZSsly3C3Iz0YrevywINbpKGf7IJNsROsnavS2KVQwpDvPZmQWsJ2sHnsknN2/rlM5sI4a2dk=
X-Received: by 2002:a67:f641:: with SMTP id u1mr2714335vso.86.1583947226874;
 Wed, 11 Mar 2020 10:20:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200311155404.209990-1-abhishekpandit@chromium.org> <99C097F2-FD84-49B8-B3D7-F03C34C4F563@holtmann.org>
In-Reply-To: <99C097F2-FD84-49B8-B3D7-F03C34C4F563@holtmann.org>
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Date:   Wed, 11 Mar 2020 10:20:16 -0700
Message-ID: <CANFp7mV-0HjEzYwh4LacMPOJCqgF1=1zwQ66e+8Hd6pODa3dMQ@mail.gmail.com>
Subject: Re: [RFC PATCH v6 0/5] Bluetooth: Handle system suspend gracefully
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Alain Michaud <alainm@chromium.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
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

Let's continue the discussion on the bluez list.

I will update the patch series so that the "set_wake_capable"
management change is last in the series there as well and send out an
update today.

Thanks
Abhishek

On Wed, Mar 11, 2020 at 10:05 AM Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Abhishek,
>
> > This patch series prepares the Bluetooth controller for system suspend
> > by disconnecting all devices and preparing the event filter and LE
> > whitelist with devices that can wake the system from suspend.
> >
> > The main motivation for doing this is so we can enable Bluetooth as
> > a wake up source during suspend without it being noisy. Bluetooth should
> > wake the system when a HID device receives user input but otherwise not
> > send any events to the host.
> >
> > This patch series was tested on several Chromebooks with both btusb and
> > hci_serdev on kernel 4.19. The set of tests was basically the following:
> > * Reconnects after suspend succeed
> > * HID devices can wake the system from suspend (needs some related bluez
> >  changes to call the Set Wake Capable management command)
> > * System properly pauses and unpauses discovery + advertising around
> >  suspend
> > * System does not wake from any events from non wakeable devices
> >
> > Series 2 has refactored the change into multiple smaller commits as
> > requested. I tried to simplify some of the whitelist filtering edge
> > cases but unfortunately it remains quite complex.
> >
> > Series 3 has refactored it further and should have resolved the
> > whitelisting complexity in series 2.
> >
> > Series 4 adds a fix to check for powered down and powering down adapters.
> >
> > Series 5 moves set_wake_capable to the last patch in the series and
> > changes BT_DBG to bt_dev_dbg.
> >
> > Please review and provide any feedback.
> >
> > Thanks
> > Abhishek
> >
> >
> > Changes in v6:
> > * Removed unused variables in hci_req_prepare_suspend
> > * Add int old_state to this patch
> >
> > Changes in v5:
> > * Convert BT_DBG to bt_dev_dbg
> > * Added wakeable list and changed BT_DBG to bt_dev_dbg
> > * Add wakeable to hci_conn_params and change BT_DBG to bt_dev_dbg
> > * Changed BT_DBG to bt_dev_dbg
> > * Wakeable entries moved to other commits
> > * Patch moved to end of series
> >
> > Changes in v4:
> > * Added check for mgmt_powering_down and hdev_is_powered in notifier
> >
> > Changes in v3:
> > * Refactored to only handle BR/EDR devices
> > * Split LE changes into its own commit
> > * Added wakeable property to le_conn_param
> > * Use wakeable list for BR/EDR and wakeable property for LE
> >
> > Changes in v2:
> > * Moved pm notifier registration into its own patch and moved params out
> >  of separate suspend_state
> > * Refactored filters and whitelist settings to its own patch
> > * Refactored update_white_list to have clearer edge cases
> > * Add connected devices to whitelist (previously missing corner case)
> > * Refactored pause discovery + advertising into its own patch
> >
> > Abhishek Pandit-Subedi (5):
> >  Bluetooth: Handle PM_SUSPEND_PREPARE and PM_POST_SUSPEND
> >  Bluetooth: Handle BR/EDR devices during suspend
> >  Bluetooth: Handle LE devices during suspend
> >  Bluetooth: Pause discovery and advertising during suspend
> >  Bluetooth: Add mgmt op set_wake_capable
> >
> > include/net/bluetooth/hci.h      |  17 +-
> > include/net/bluetooth/hci_core.h |  43 ++++
> > include/net/bluetooth/mgmt.h     |   7 +
> > net/bluetooth/hci_core.c         | 102 ++++++++++
> > net/bluetooth/hci_event.c        |  24 +++
> > net/bluetooth/hci_request.c      | 331 ++++++++++++++++++++++++++-----
> > net/bluetooth/hci_request.h      |   2 +
> > net/bluetooth/mgmt.c             |  92 +++++++++
> > 8 files changed, 558 insertions(+), 60 deletions(-)
>
> patches 1-4 have been applied to bluetooth-next tree.
>
> I skipped patch 5 since now we have to discuss how best the API for setting the wakeable devices will be. Care to start up a discussion thread for that?
>
> Regards
>
> Marcel
>
