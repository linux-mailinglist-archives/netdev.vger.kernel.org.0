Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E793249177
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 01:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgHRXea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 19:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726612AbgHRXea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 19:34:30 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1556C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 16:34:29 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id q13so11024653vsn.9
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 16:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cB70dETR/NyGQeHCHTARFj9L+SQvd7OlAWQERQoCVII=;
        b=VH/aoSyZVjORXv3NGcpvObwwphjJTPh8Teb99rTAe6HRr/0164LWsOX0ahj5q7dRDH
         5XIXK3BbjyjgmjpUwj+nAZSn4w6cRWSM6sGsH3NJe0BMbCbtUqKkHOyOIsqpouIwIB9O
         4HAUlPnDMdu4VX491vMC+FOMEBW2rpYRT6IV0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cB70dETR/NyGQeHCHTARFj9L+SQvd7OlAWQERQoCVII=;
        b=okptuwnBAJLsf8+sWyS/HJ6QWIW5ikBEJWHaSIniwer3ZiVznkHcVRgykaCL8h1cur
         abHbe6miOtpvslvKlUMsQHNbgV4GqowQAgRGo5olrvs3pjTWiVO7AXDGUBH/cHuvSt/I
         6WYywGrpZWjypuFIZ1ZEK8WsHYXjzgsX/cpVo2xOuNJypfjilICgJF70Zp1o4a79eZQv
         dQsIlm00/kzaz4+YtRyb/1syTFn7ysaQhIiUfDQaKAfFLE2GKXkrPQgPowajPnkKVTBJ
         dY094kjeB8y+BG4k0vcZAjKrOvB/MZ6VcRr4MPx9avm+/Qy/KQjl5ZZyIyWpi99SofpQ
         0PAA==
X-Gm-Message-State: AOAM530IThBLi7YTHGmSrFUBAxduXT2KJgMh4/8r0xEqT4gs9326sRuV
        neGWldZyyMf+i7NsX3EPETY499AMmFaQtfCqzgQnWg==
X-Google-Smtp-Source: ABdhPJzHyqzCkUdY55haN8OFBGZb0CYfaDh2JhndlSCGSs7EgCkjOFsKH6Ao88fQ+4pSMDiQMP+cyYhtv/6vgWxYkag=
X-Received: by 2002:a05:6102:311a:: with SMTP id e26mr13531599vsh.86.1597793668644;
 Tue, 18 Aug 2020 16:34:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200729014225.1842177-1-abhishekpandit@chromium.org> <CANFp7mV0TP-WbBWGSpduERaf9-KBXevhG7xKvjkMrqrtWWkZ5w@mail.gmail.com>
In-Reply-To: <CANFp7mV0TP-WbBWGSpduERaf9-KBXevhG7xKvjkMrqrtWWkZ5w@mail.gmail.com>
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Date:   Tue, 18 Aug 2020 16:34:17 -0700
Message-ID: <CANFp7mW3jXf1Djp=j3nYRzzoJAptJ8Z2JJCP+N6pMHGWXx=9cg@mail.gmail.com>
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

Hi Marcel,

Please review this patch. A newer series for how the controller resume
event will be used is available at
https://patchwork.kernel.org/project/bluetooth/list/?series=334811

Besides usage in bluez, these events will also make debugging and
testing suspend/resume for Bluez easier (i.e. finding spurious wakes
due to BT in suspend stress tests, asserting that wakeup from peers
occurred as expected in tests)

Abhishek

On Tue, Aug 4, 2020 at 10:11 AM Abhishek Pandit-Subedi
<abhishekpandit@chromium.org> wrote:
>
> Hi,
>
> Gentle reminder that this is waiting for feedback. Related userspace
> changes are here to see how we plan on using it:
> https://patchwork.kernel.org/project/bluetooth/list/?series=325777
>
> Thanks
> Abhishek
>
> On Tue, Jul 28, 2020 at 6:42 PM Abhishek Pandit-Subedi
> <abhishekpandit@chromium.org> wrote:
> >
> >
> > Hi Marcel,
> >
> > This series adds the suspend/resume events suggested in
> > https://patchwork.kernel.org/patch/11663455/.
> >
> > I have tested it with some userspace changes that monitors the
> > controller resumed event to trigger audio device reconnection and
> > verified that the events are correctly emitted.
> >
> > Please take a look.
> > Abhishek
> >
> >
> > Abhishek Pandit-Subedi (3):
> >   Bluetooth: Add mgmt suspend and resume events
> >   Bluetooth: Add suspend reason for device disconnect
> >   Bluetooth: Emit controller suspend and resume events
> >
> >  include/net/bluetooth/hci_core.h |  6 +++
> >  include/net/bluetooth/mgmt.h     | 16 +++++++
> >  net/bluetooth/hci_core.c         | 26 +++++++++++-
> >  net/bluetooth/hci_event.c        | 73 ++++++++++++++++++++++++++++++++
> >  net/bluetooth/mgmt.c             | 28 ++++++++++++
> >  5 files changed, 148 insertions(+), 1 deletion(-)
> >
> > --
> > 2.28.0.rc0.142.g3c755180ce-goog
> >
