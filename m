Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82B0449BF4
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 19:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236033AbhKHStk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 13:49:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236019AbhKHStj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 13:49:39 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594E1C061570;
        Mon,  8 Nov 2021 10:46:55 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id i11so8773844ilv.13;
        Mon, 08 Nov 2021 10:46:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qz3gce6oSSpXDY6j3/EeyxRV69SFnHX86nsrwsvI9fA=;
        b=Mf54uY4rHVPJByMoo9hQQ6gudmZrfhWiIoB6yTR3rom4D8Q9mB+7g16ZPvUZ9ZsDBb
         SdFWFMvbUE8jMekfnQH7j4ra3WzJ8VmRvZVvIMCZAqGmvnMAl7c9EefRhK5zhtoGMPKD
         zv+R0CSeb4gHvhPJFf3avq6Au+HfgJ/9mN1ozkcxciu22IxF9JOaVYUiBaGR5g2v2vhd
         jSsi2tnCw5I8yNpy1Fw63BEiGs33Lra/ki4yNoXxckxdjbrpNv7x409pU/+33iUMLtMy
         GzlvQ79Cat3t0oT+mjnzMab2Q7ASFqGRxLNCehnX1DIXmsYbsTvSgZl42HT/hnCjcapw
         yzsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qz3gce6oSSpXDY6j3/EeyxRV69SFnHX86nsrwsvI9fA=;
        b=SQp0S55NO31sWtm1ZHylR9V9h3IxsWBmwBlXThd4gtsJms+hY2QIi7ujf0OaAziT3Y
         LZB2gEA7fAP0Ssye7l5yPzXsIvLsL+/cUm9VeoS3G/8uQLycgI3/DM614D4bi7ro1lWG
         typ1S7vTPgMaXQTlvnZnatp5TivNBdykNuCYWNNB+RmSqLWLCrSavrSvUx3MIXbqcC2S
         wt5+VDDy3MZdQUUaav129HOfZJPm7oq0oVoMiNZYJv+ThLIIObNSf9+C1Hbt4LCzqLzo
         ha6AU7VyWZjyMiBP/sexU5nFwMA2pK82/qGedFyqKm7mur+KUKzNwO808ZoZ+W3Ypp0v
         wecg==
X-Gm-Message-State: AOAM533ryQs6IxYH0zbEk9VgWmg1qqlMLbs3pxHFI0e4rRUwb/MSEcLy
        YkBfTAUB6d85yuu837mAc1VQw3xAb2PkbRdqWIs=
X-Google-Smtp-Source: ABdhPJyqzkYAD970I9CDZaHCulMaLdF2LVNPpx1c6+Utkc5OqhiunW7xHoREoCYJMBPmA0Cy5kYuUEgUxnucVgC3Osk=
X-Received: by 2002:a92:c56b:: with SMTP id b11mr851648ilj.243.1636397214669;
 Mon, 08 Nov 2021 10:46:54 -0800 (PST)
MIME-Version: 1.0
References: <20211102213321.18680-1-luiz.dentz@gmail.com>
In-Reply-To: <20211102213321.18680-1-luiz.dentz@gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 8 Nov 2021 10:46:43 -0800
Message-ID: <CABBYNZ+i4aR5OjMppG+3+EkaOyFh06p18u6FNr6pZA8wws-hpg@mail.gmail.com>
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

On Tue, Nov 2, 2021 at 2:33 PM Luiz Augusto von Dentz
<luiz.dentz@gmail.com> wrote:
>
> The following changes since commit d0f1c248b4ff71cada1b9e4ed61a1992cd94c3df:
>
>   Merge tag 'for-net-next-2021-10-01' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next (2021-10-05 07:41:16 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2021-11-02
>
> for you to fetch changes up to 258f56d11bbbf39df5bc5faf0119d28be528f27d:
>
>   Bluetooth: aosp: Support AOSP Bluetooth Quality Report (2021-11-02 19:37:52 +0100)
>
> ----------------------------------------------------------------
> bluetooth-next pull request for net-next:
>
>  - Add support for AOSP Bluetooth Quality Report
>  - Rework of HCI command execution serialization
>
> ----------------------------------------------------------------
> Archie Pusaka (1):
>       Bluetooth: Fix removing adv when processing cmd complete
>
> Brian Gix (13):
>       Bluetooth: hci_sync: Convert MGMT_OP_SET_FAST_CONNECTABLE
>       Bluetooth: hci_sync: Enable synch'd set_bredr
>       Bluetooth: hci_sync: Convert MGMT_OP_GET_CONN_INFO
>       Bluetooth: hci_sync: Convert MGMT_OP_SET_SECURE_CONN
>       Bluetooth: hci_sync: Convert MGMT_OP_GET_CLOCK_INFO
>       Bluetooth: hci_sync: Convert MGMT_OP_SET_LE
>       Bluetooth: hci_sync: Convert MGMT_OP_READ_LOCAL_OOB_DATA
>       Bluetooth: hci_sync: Convert MGMT_OP_READ_LOCAL_OOB_EXT_DATA
>       Bluetooth: hci_sync: Convert MGMT_OP_SET_LOCAL_NAME
>       Bluetooth: hci_sync: Convert MGMT_OP_SET_PHY_CONFIGURATION
>       Bluetooth: hci_sync: Convert MGMT_OP_SET_ADVERTISING
>       Bluetooth: hci_sync: Convert adv_expire
>       Bluetooth: hci_sync: Convert MGMT_OP_SSP
>
> David Yang (1):
>       Bluetooth: btusb: Fix application of sizeof to pointer
>
> Johan Hovold (1):
>       Bluetooth: bfusb: fix division by zero in send path
>
> Joseph Hwang (2):
>       Bluetooth: Add struct of reading AOSP vendor capabilities
>       Bluetooth: aosp: Support AOSP Bluetooth Quality Report
>
> Kiran K (2):
>       Bluetooth: Read codec capabilities only if supported
>       Bluetooth: btintel: Fix bdaddress comparison with garbage value
>
> Kyle Copperfield (1):
>       Bluetooth: btsdio: Do not bind to non-removable BCM4345 and BCM43455
>
> Luiz Augusto von Dentz (16):
>       Bluetooth: hci_vhci: Fix calling hci_{suspend,resume}_dev
>       Bluetooth: Fix handling of SUSPEND_DISCONNECTING
>       Bluetooth: L2CAP: Fix not initializing sk_peer_pid
>       Bluetooth: vhci: Add support for setting msft_opcode and aosp_capable
>       Bluetooth: vhci: Fix checking of msft_opcode
>       Bluetooth: hci_sync: Make use of hci_cmd_sync_queue set 1
>       Bluetooth: hci_sync: Make use of hci_cmd_sync_queue set 2
>       Bluetooth: hci_sync: Make use of hci_cmd_sync_queue set 3
>       Bluetooth: hci_sync: Enable advertising when LL privacy is enabled
>       Bluetooth: hci_sync: Rework background scan
>       Bluetooth: hci_sync: Convert MGMT_SET_POWERED
>       Bluetooth: hci_sync: Convert MGMT_OP_START_DISCOVERY
>       Bluetooth: hci_sync: Rework init stages
>       Bluetooth: hci_sync: Rework hci_suspend_notifier
>       Bluetooth: hci_sync: Fix missing static warnings
>       Bluetooth: hci_sync: Fix not setting adv set duration
>
> Marcel Holtmann (1):
>       Bluetooth: Add helper for serialized HCI command execution
>
> Mark-YW.Chen (1):
>       Bluetooth: btusb: fix memory leak in btusb_mtk_submit_wmt_recv_urb()
>
> Mark-yw Chen (1):
>       Bluetooth: btmtksdio: transmit packet according to status TX_EMPTY
>
> Nguyen Dinh Phi (1):
>       Bluetooth: hci_sock: purge socket queues in the destruct() callback
>
> Paul Cercueil (1):
>       Bluetooth: hci_bcm: Remove duplicated entry in OF table
>
> Sean Wang (9):
>       Bluetooth: mediatek: add BT_MTK module
>       Bluetooth: btmtksido: rely on BT_MTK module
>       Bluetooth: btmtksdio: add .set_bdaddr support
>       Bluetooth: btmtksdio: explicitly set WHISR as write-1-clear
>       Bluetooth: btmtksdio: move interrupt service to work
>       Bluetooth: btmtksdio: update register CSDIOCSR operation
>       Bluetooth: btmtksdio: use register CRPLR to read packet length
>       mmc: add MT7921 SDIO identifiers for MediaTek Bluetooth devices
>       Bluetooth: btmtksdio: add MT7921s Bluetooth support
>
> Soenke Huster (1):
>       Bluetooth: virtio_bt: fix memory leak in virtbt_rx_handle()
>
> Tedd Ho-Jeong An (2):
>       Bluetooth: hci_vhci: Fix to set the force_wakeup value
>       Bluetooth: mgmt: Fix Experimental Feature Changed event
>
> Tim Jiang (1):
>       Bluetooth: btusb: Add support using different nvm for variant WCN6855 controller
>
> Wang Hai (1):
>       Bluetooth: cmtp: fix possible panic when cmtp_init_sockets() fails
>
> Wei Yongjun (2):
>       Bluetooth: Fix debugfs entry leak in hci_register_dev()
>       Bluetooth: Fix memory leak of hci device
>
>  drivers/bluetooth/Kconfig         |    6 +
>  drivers/bluetooth/Makefile        |    1 +
>  drivers/bluetooth/bfusb.c         |    3 +
>  drivers/bluetooth/btintel.c       |   22 +-
>  drivers/bluetooth/btmtk.c         |  289 +++
>  drivers/bluetooth/btmtk.h         |  111 +
>  drivers/bluetooth/btmtksdio.c     |  496 ++--
>  drivers/bluetooth/btsdio.c        |    2 +
>  drivers/bluetooth/btusb.c         |  389 +--
>  drivers/bluetooth/hci_bcm.c       |    1 -
>  drivers/bluetooth/hci_vhci.c      |  120 +-
>  drivers/bluetooth/virtio_bt.c     |    3 +
>  include/linux/mmc/sdio_ids.h      |    1 +
>  include/net/bluetooth/bluetooth.h |    2 +
>  include/net/bluetooth/hci_core.h  |   22 +-
>  include/net/bluetooth/hci_sync.h  |   97 +
>  net/bluetooth/Makefile            |    2 +-
>  net/bluetooth/aosp.c              |  168 +-
>  net/bluetooth/aosp.h              |   13 +
>  net/bluetooth/cmtp/core.c         |    4 +-
>  net/bluetooth/hci_codec.c         |   18 +-
>  net/bluetooth/hci_conn.c          |   20 +-
>  net/bluetooth/hci_core.c          | 1334 +----------
>  net/bluetooth/hci_event.c         |  159 +-
>  net/bluetooth/hci_request.c       |  338 +--
>  net/bluetooth/hci_request.h       |   10 +
>  net/bluetooth/hci_sock.c          |   11 +-
>  net/bluetooth/hci_sync.c          | 4799 +++++++++++++++++++++++++++++++++++++
>  net/bluetooth/hci_sysfs.c         |    2 +
>  net/bluetooth/l2cap_sock.c        |   19 +
>  net/bluetooth/mgmt.c              | 2086 ++++++++--------
>  net/bluetooth/mgmt_util.c         |   15 +-
>  net/bluetooth/mgmt_util.h         |    4 +
>  net/bluetooth/msft.c              |  511 ++--
>  net/bluetooth/msft.h              |   15 +-
>  35 files changed, 7472 insertions(+), 3621 deletions(-)
>  create mode 100644 drivers/bluetooth/btmtk.c
>  create mode 100644 drivers/bluetooth/btmtk.h
>  create mode 100644 include/net/bluetooth/hci_sync.h
>  create mode 100644 net/bluetooth/hci_sync.c

Any chance to get these changes in before the merge window closes?

-- 
Luiz Augusto von Dentz
