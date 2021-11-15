Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1EB6451D13
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351445AbhKPAZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:25:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349931AbhKOUUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 15:20:35 -0500
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11877C110F13;
        Mon, 15 Nov 2021 11:53:27 -0800 (PST)
Received: by mail-ua1-x931.google.com with SMTP id ay21so37312964uab.12;
        Mon, 15 Nov 2021 11:53:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L1VrMq4SopJrvMJ2HcwjMjsGBbXO+WvGB0d95Qy0qHI=;
        b=gLYt2avAmnwO91Fr34MeSunRD8TOmf2Pu3T361Ic/HdPlsvdpnEk7orDBBR0+P+abD
         CNjjkpx031EZ9umMmChaTVlgdNjLy+nv5khVeOhjwCjV5mgXQIJMCN/IRbt/T4W32K8F
         WXRP10Zb0jgSe2NXPvGBGv6tEivMLdjFnuf/NIBYb+NSyQ7RucboZYpraGLNVJQIZjbB
         66dELiCeUpMBhsZ07neTpEXRK4SU21aQ1FUJ6TFv7phVXKQD/yhm6+xHkzE5dFR1inPE
         b32GqsymdAImblz8EgLadm1lG8tadqrqQIX6MuZwRIuXwCSs2IBBIUArd9jq5OaO18EM
         Aj9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L1VrMq4SopJrvMJ2HcwjMjsGBbXO+WvGB0d95Qy0qHI=;
        b=fHXPS0m31U+4TxpyQbNxz/wTlTi48XJW60X2iRMONM5thBi5rxAxiqpn8JLj8ZD7+d
         mZUqYdo5DC+mBVv5REDdevHSLlc9HBg/9JlbJLZRJNmBphA6oWvHbyCX9awb2afLtbeL
         vsShAES1IvDDa2Brr7itU8rmwlMPErhSmQMgf7SdgEsAyGsgfEv2HwQhWh9ST5McB8SD
         7X3feAZByCyYhAM5NtFNlMLU6i25e6vt1YJBXjrs3vGY56wFMDdz628/oR9ybc9uGcbD
         Ip5C+A0cTfzAxyajKxe8tl267sCw2+XVtfx/CaCOx/gXZUmskYeRL1IXPnsma/+Xf1Gy
         L90g==
X-Gm-Message-State: AOAM5315i7bHjZK1K9uRsOVFRFgq9/NWYG5c74ofb8n9CEkBHkNH+pfQ
        PF7LFG6Ch8yK3Nrp33JEOaxA9geSU0KyubXKonA=
X-Google-Smtp-Source: ABdhPJyvS1KJXzKhqScXy69oHzHB62OzvLoOY/IAkuqp0J10T+Uy3SJ0JNh5lnhWxosBazVccoWbIgz6ntQTMcEf1as=
X-Received: by 2002:ab0:3e3:: with SMTP id 90mr2081162uau.102.1637006006119;
 Mon, 15 Nov 2021 11:53:26 -0800 (PST)
MIME-Version: 1.0
References: <20211102213321.18680-1-luiz.dentz@gmail.com> <CABBYNZ+i4aR5OjMppG+3+EkaOyFh06p18u6FNr6pZA8wws-hpg@mail.gmail.com>
In-Reply-To: <CABBYNZ+i4aR5OjMppG+3+EkaOyFh06p18u6FNr6pZA8wws-hpg@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 15 Nov 2021 11:53:15 -0800
Message-ID: <CABBYNZJPanQzSx=Nf9mgORvqixbgwd6ypx=irGiQ3CEr6xUT1A@mail.gmail.com>
Subject: Re: pull request: bluetooth 2021-11-02
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David and Jakub,

On Mon, Nov 8, 2021 at 10:46 AM Luiz Augusto von Dentz
<luiz.dentz@gmail.com> wrote:
>
> Hi David and Jakub,
>
> On Tue, Nov 2, 2021 at 2:33 PM Luiz Augusto von Dentz
> <luiz.dentz@gmail.com> wrote:
> >
> > The following changes since commit d0f1c248b4ff71cada1b9e4ed61a1992cd94c3df:
> >
> >   Merge tag 'for-net-next-2021-10-01' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next (2021-10-05 07:41:16 -0700)
> >
> > are available in the Git repository at:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2021-11-02
> >
> > for you to fetch changes up to 258f56d11bbbf39df5bc5faf0119d28be528f27d:
> >
> >   Bluetooth: aosp: Support AOSP Bluetooth Quality Report (2021-11-02 19:37:52 +0100)
> >
> > ----------------------------------------------------------------
> > bluetooth-next pull request for net-next:
> >
> >  - Add support for AOSP Bluetooth Quality Report
> >  - Rework of HCI command execution serialization
> >
> > ----------------------------------------------------------------
> > Archie Pusaka (1):
> >       Bluetooth: Fix removing adv when processing cmd complete
> >
> > Brian Gix (13):
> >       Bluetooth: hci_sync: Convert MGMT_OP_SET_FAST_CONNECTABLE
> >       Bluetooth: hci_sync: Enable synch'd set_bredr
> >       Bluetooth: hci_sync: Convert MGMT_OP_GET_CONN_INFO
> >       Bluetooth: hci_sync: Convert MGMT_OP_SET_SECURE_CONN
> >       Bluetooth: hci_sync: Convert MGMT_OP_GET_CLOCK_INFO
> >       Bluetooth: hci_sync: Convert MGMT_OP_SET_LE
> >       Bluetooth: hci_sync: Convert MGMT_OP_READ_LOCAL_OOB_DATA
> >       Bluetooth: hci_sync: Convert MGMT_OP_READ_LOCAL_OOB_EXT_DATA
> >       Bluetooth: hci_sync: Convert MGMT_OP_SET_LOCAL_NAME
> >       Bluetooth: hci_sync: Convert MGMT_OP_SET_PHY_CONFIGURATION
> >       Bluetooth: hci_sync: Convert MGMT_OP_SET_ADVERTISING
> >       Bluetooth: hci_sync: Convert adv_expire
> >       Bluetooth: hci_sync: Convert MGMT_OP_SSP
> >
> > David Yang (1):
> >       Bluetooth: btusb: Fix application of sizeof to pointer
> >
> > Johan Hovold (1):
> >       Bluetooth: bfusb: fix division by zero in send path
> >
> > Joseph Hwang (2):
> >       Bluetooth: Add struct of reading AOSP vendor capabilities
> >       Bluetooth: aosp: Support AOSP Bluetooth Quality Report
> >
> > Kiran K (2):
> >       Bluetooth: Read codec capabilities only if supported
> >       Bluetooth: btintel: Fix bdaddress comparison with garbage value
> >
> > Kyle Copperfield (1):
> >       Bluetooth: btsdio: Do not bind to non-removable BCM4345 and BCM43455
> >
> > Luiz Augusto von Dentz (16):
> >       Bluetooth: hci_vhci: Fix calling hci_{suspend,resume}_dev
> >       Bluetooth: Fix handling of SUSPEND_DISCONNECTING
> >       Bluetooth: L2CAP: Fix not initializing sk_peer_pid
> >       Bluetooth: vhci: Add support for setting msft_opcode and aosp_capable
> >       Bluetooth: vhci: Fix checking of msft_opcode
> >       Bluetooth: hci_sync: Make use of hci_cmd_sync_queue set 1
> >       Bluetooth: hci_sync: Make use of hci_cmd_sync_queue set 2
> >       Bluetooth: hci_sync: Make use of hci_cmd_sync_queue set 3
> >       Bluetooth: hci_sync: Enable advertising when LL privacy is enabled
> >       Bluetooth: hci_sync: Rework background scan
> >       Bluetooth: hci_sync: Convert MGMT_SET_POWERED
> >       Bluetooth: hci_sync: Convert MGMT_OP_START_DISCOVERY
> >       Bluetooth: hci_sync: Rework init stages
> >       Bluetooth: hci_sync: Rework hci_suspend_notifier
> >       Bluetooth: hci_sync: Fix missing static warnings
> >       Bluetooth: hci_sync: Fix not setting adv set duration
> >
> > Marcel Holtmann (1):
> >       Bluetooth: Add helper for serialized HCI command execution
> >
> > Mark-YW.Chen (1):
> >       Bluetooth: btusb: fix memory leak in btusb_mtk_submit_wmt_recv_urb()
> >
> > Mark-yw Chen (1):
> >       Bluetooth: btmtksdio: transmit packet according to status TX_EMPTY
> >
> > Nguyen Dinh Phi (1):
> >       Bluetooth: hci_sock: purge socket queues in the destruct() callback
> >
> > Paul Cercueil (1):
> >       Bluetooth: hci_bcm: Remove duplicated entry in OF table
> >
> > Sean Wang (9):
> >       Bluetooth: mediatek: add BT_MTK module
> >       Bluetooth: btmtksido: rely on BT_MTK module
> >       Bluetooth: btmtksdio: add .set_bdaddr support
> >       Bluetooth: btmtksdio: explicitly set WHISR as write-1-clear
> >       Bluetooth: btmtksdio: move interrupt service to work
> >       Bluetooth: btmtksdio: update register CSDIOCSR operation
> >       Bluetooth: btmtksdio: use register CRPLR to read packet length
> >       mmc: add MT7921 SDIO identifiers for MediaTek Bluetooth devices
> >       Bluetooth: btmtksdio: add MT7921s Bluetooth support
> >
> > Soenke Huster (1):
> >       Bluetooth: virtio_bt: fix memory leak in virtbt_rx_handle()
> >
> > Tedd Ho-Jeong An (2):
> >       Bluetooth: hci_vhci: Fix to set the force_wakeup value
> >       Bluetooth: mgmt: Fix Experimental Feature Changed event
> >
> > Tim Jiang (1):
> >       Bluetooth: btusb: Add support using different nvm for variant WCN6855 controller
> >
> > Wang Hai (1):
> >       Bluetooth: cmtp: fix possible panic when cmtp_init_sockets() fails
> >
> > Wei Yongjun (2):
> >       Bluetooth: Fix debugfs entry leak in hci_register_dev()
> >       Bluetooth: Fix memory leak of hci device
> >
> >  drivers/bluetooth/Kconfig         |    6 +
> >  drivers/bluetooth/Makefile        |    1 +
> >  drivers/bluetooth/bfusb.c         |    3 +
> >  drivers/bluetooth/btintel.c       |   22 +-
> >  drivers/bluetooth/btmtk.c         |  289 +++
> >  drivers/bluetooth/btmtk.h         |  111 +
> >  drivers/bluetooth/btmtksdio.c     |  496 ++--
> >  drivers/bluetooth/btsdio.c        |    2 +
> >  drivers/bluetooth/btusb.c         |  389 +--
> >  drivers/bluetooth/hci_bcm.c       |    1 -
> >  drivers/bluetooth/hci_vhci.c      |  120 +-
> >  drivers/bluetooth/virtio_bt.c     |    3 +
> >  include/linux/mmc/sdio_ids.h      |    1 +
> >  include/net/bluetooth/bluetooth.h |    2 +
> >  include/net/bluetooth/hci_core.h  |   22 +-
> >  include/net/bluetooth/hci_sync.h  |   97 +
> >  net/bluetooth/Makefile            |    2 +-
> >  net/bluetooth/aosp.c              |  168 +-
> >  net/bluetooth/aosp.h              |   13 +
> >  net/bluetooth/cmtp/core.c         |    4 +-
> >  net/bluetooth/hci_codec.c         |   18 +-
> >  net/bluetooth/hci_conn.c          |   20 +-
> >  net/bluetooth/hci_core.c          | 1334 +----------
> >  net/bluetooth/hci_event.c         |  159 +-
> >  net/bluetooth/hci_request.c       |  338 +--
> >  net/bluetooth/hci_request.h       |   10 +
> >  net/bluetooth/hci_sock.c          |   11 +-
> >  net/bluetooth/hci_sync.c          | 4799 +++++++++++++++++++++++++++++++++++++
> >  net/bluetooth/hci_sysfs.c         |    2 +
> >  net/bluetooth/l2cap_sock.c        |   19 +
> >  net/bluetooth/mgmt.c              | 2086 ++++++++--------
> >  net/bluetooth/mgmt_util.c         |   15 +-
> >  net/bluetooth/mgmt_util.h         |    4 +
> >  net/bluetooth/msft.c              |  511 ++--
> >  net/bluetooth/msft.h              |   15 +-
> >  35 files changed, 7472 insertions(+), 3621 deletions(-)
> >  create mode 100644 drivers/bluetooth/btmtk.c
> >  create mode 100644 drivers/bluetooth/btmtk.h
> >  create mode 100644 include/net/bluetooth/hci_sync.h
> >  create mode 100644 net/bluetooth/hci_sync.c
>
> Any chance to get these changes in before the merge window closes?

I guess these won't be able to be merged after all, is there a define
process on how/when pull-request shall be sent to net-next, Ive assume
next-next is freezed now the documentation says the the merge window
lasts for approximately two weeks but I guess that is for the Linus
tree not net-next?


-- 
Luiz Augusto von Dentz
