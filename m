Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6613B6759
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 19:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbhF1RNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 13:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbhF1RNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 13:13:08 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289C0C061574;
        Mon, 28 Jun 2021 10:10:42 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id g19so9009402ybe.11;
        Mon, 28 Jun 2021 10:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5PVPcKnsSweDpSLYQhuO82TIT1xE0upl1GkK15sJLec=;
        b=RNiU65wZ0IlGd97qPqZUiy0qBek3iORKqKnw64htqT+htarS7qcHnZwn8Vd9PpJ9AM
         nAJJQUnZUEZXIbHPi8VNTTMHk8Ej6hQPBLy38xH/sq/H7BC3aYundY1QVLrzQ3HxmRfd
         r/Nhw407PJh3+ogmZA63HzWo4w97T21mD7stzWK76P4vBID8uV1NIH0KVlWYU+O2lHvR
         9psYzWDXctOGKPMFt2bVYOnMsVdSov5aDnq8p3QI8rdjzXSPYFXLYDPte8d+r/FxluLp
         wrkAq48YlaftvQCuN2dK42MZNPBbSFn0wjDFvQqeuPJJcQYjGbYTprW9C/lbdvdcce3W
         nmNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5PVPcKnsSweDpSLYQhuO82TIT1xE0upl1GkK15sJLec=;
        b=ghmqSlv44E3ms+0cWySgD6UcQ71igVe01XVAzIcINFWFQbj26OfsH1sBlG7gAYn0g6
         3uIj2m4L+HojhKKmkf8M/GYruzNcPgb+Euk8JYv+rSl2CocmO6NZAMWsmP8PIuX+igwe
         yP0WStEKlw9dHZDsjRTkuK8NfiEoCHDrSfi69tYnhlmCjc5vwVN9ep1e0gX6o3vIOliT
         mz8jgcqGQeWHKJqnobOycbPDIlndsyhAIkLkbt1z2zmIgFms/5OwGaApRebuf0CEa6SZ
         J6MHeXBG7q87Wjtw861KiMaBGu8mLewz2N88VkoTTpfN5qKVIkF99/EqsYuFwNMYUDs0
         1QyQ==
X-Gm-Message-State: AOAM5301FLNfNAhLoWMggtlOBiQVimy8Npz2N70pkZQbDZQQU/PLCwlc
        XlLROXkWqUjpWcAMS3PHqH74P1hH9xmnCrtNAis=
X-Google-Smtp-Source: ABdhPJxFOcl//64pUUGHZji3dkAkaA0fEnSNJnG8lnBLi8kK+eWiJkTcUhaDWQFdKQsoh3W3PVZDKjkYxvCFn7D02bQ=
X-Received: by 2002:a25:acdf:: with SMTP id x31mr33674367ybd.222.1624900241351;
 Mon, 28 Jun 2021 10:10:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210628170858.312168-1-luiz.dentz@gmail.com>
In-Reply-To: <20210628170858.312168-1-luiz.dentz@gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 28 Jun 2021 10:10:30 -0700
Message-ID: <CABBYNZJyqWe+8tJ4ii=9pXN5gGd_2V_RN8Gn14pKmXLU35C16w@mail.gmail.com>
Subject: Re: pull request: bluetooth-next 2021-06-28
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Jakub,

Please disregard this, looks like the tag description is wrong, I will
send a new one shortly.

On Mon, Jun 28, 2021 at 10:09 AM Luiz Augusto von Dentz
<luiz.dentz@gmail.com> wrote:
>
> The following changes since commit ff8744b5eb116fdf9b80a6ff774393afac7325bd:
>
>   Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue (2021-06-25 11:59:11 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2021-06-28
>
> for you to fetch changes up to 1f0536139cb8e8175ca034e12706b86f77f9061e:
>
>   Bluetooth: hci_uart: Remove redundant assignment to fw_ptr (2021-06-26 07:52:41 +0200)
>
> ----------------------------------------------------------------
> bluetooth-next pull request for net-next:
>
>  - Proper support for BCM4330 and BMC4334
>  - Various improvements for firmware download of Intel controllers
>  - Update management interface revision to 20
>  - Support for AOSP HCI vendor commands
>  - Initial Virtio support
>
> ----------------------------------------------------------------
> Archie Pusaka (9):
>       Bluetooth: hci_h5: Add RTL8822CS capabilities
>       Bluetooth: use inclusive language in hci_core.h
>       Bluetooth: use inclusive language to describe CPB
>       Bluetooth: use inclusive language in HCI LE features
>       Bluetooth: use inclusive language in SMP
>       Bluetooth: use inclusive language in comments
>       Bluetooth: use inclusive language in HCI role comments
>       Bluetooth: use inclusive language when tracking connections
>       Bluetooth: use inclusive language when filtering devices
>
> Colin Ian King (2):
>       Bluetooth: virtio_bt: add missing null pointer check on alloc_skb call return
>       Bluetooth: btmrvl: remove redundant continue statement
>
> Connor Abbott (1):
>       Bluetooth: btqca: Don't modify firmware contents in-place
>
> Daniel Lenski (1):
>       Bluetooth: btusb: Add a new QCA_ROME device (0cf3:e500)
>
> Hilda Wu (1):
>       Bluetooth: btusb: Add support USB ALT 3 for WBS
>
> Jiapeng Chong (1):
>       Bluetooth: 6lowpan: remove unused function
>
> Joakim Tjernlund (2):
>       Bluetooth: btusb: Add 0x0b05:0x190e Realtek 8761BU (ASUS BT500) device.
>       Bluetooth: btrtl: rename USB fw for RTL8761
>
> Kai Ye (11):
>       Bluetooth: 6lowpan: delete unneeded variable initialization
>       Bluetooth: bnep: Use the correct print format
>       Bluetooth: cmtp: Use the correct print format
>       Bluetooth: hidp: Use the correct print format
>       Bluetooth: 6lowpan: Use the correct print format
>       Bluetooth: a2mp: Use the correct print format
>       Bluetooth: amp: Use the correct print format
>       Bluetooth: mgmt: Use the correct print format
>       Bluetooth: msft: Use the correct print format
>       Bluetooth: sco: Use the correct print format
>       Bluetooth: smp: Use the correct print format
>
> Kai-Heng Feng (1):
>       Bluetooth: Shutdown controller after workqueues are flushed or cancelled
>
> Kiran K (1):
>       Bluetooth: Fix alt settings for incoming SCO with transparent coding format
>
> Luiz Augusto von Dentz (5):
>       Bluetooth: L2CAP: Fix invalid access if ECRED Reconfigure fails
>       Bluetooth: L2CAP: Fix invalid access on ECRED Connection response
>       Bluetooth: mgmt: Fix slab-out-of-bounds in tlv_data_is_valid
>       Bluetooth: Fix Set Extended (Scan Response) Data
>       Bluetooth: Fix handling of HCI_LE_Advertising_Set_Terminated event
>
> Manish Mandlik (1):
>       Bluetooth: Add ncmd=0 recovery handling
>
> Marcel Holtmann (1):
>       Bluetooth: Increment management interface revision
>
> Mikhail Rudenko (1):
>       Bluetooth: btbcm: Add entry for BCM43430B0 UART Bluetooth
>
> Muhammad Usama Anjum (1):
>       Bluetooth: btusb: fix memory leak
>
> Nigel Christian (1):
>       Bluetooth: hci_uart: Remove redundant assignment to fw_ptr
>
> Pavel Skripkin (1):
>       Bluetooth: hci_qca: fix potential GPF
>
> Qiheng Lin (1):
>       Bluetooth: use flexible-array member instead of zero-length array
>
> Sathish Narasimman (1):
>       Bluetooth: Translate additional address type during le_conn_comp
>
> Szymon Janc (1):
>       Bluetooth: Remove spurious error message
>
> Tedd Ho-Jeong An (1):
>       Bluetooth: mgmt: Fix the command returns garbage parameter value
>
> Thadeu Lima de Souza Cascardo (1):
>       Bluetooth: cmtp: fix file refcount when cmtp_attach_device fails
>
> Tim Jiang (2):
>       Bluetooth: btusb: use default nvm if boardID is 0 for wcn6855.
>       Bluetooth: btusb: fix bt fiwmare downloading failure issue for qca btsoc.
>
> Venkata Lakshmi Narayana Gubba (5):
>       Bluetooth: hci_qca: Add support for QTI Bluetooth chip wcn6750
>       Bluetooth: btqca: Add support for firmware image with mbn type for WCN6750
>       Bluetooth: btqca: Moved extracting rom version info to common place
>       dt-bindings: net: bluetooth: Convert Qualcomm BT binding to DT schema
>       dt-bindings: net: bluetooth: Add device tree bindings for QTI chip wcn6750
>
> Yu Liu (2):
>       Bluetooth: Return whether a connection is outbound
>       Bluetooth: Fix the HCI to MGMT status conversion table
>
> YueHaibing (1):
>       Bluetooth: RFCOMM: Use DEVICE_ATTR_RO macro
>
> Yun-Hao Chung (1):
>       Bluetooth: disable filter dup when scan for adv monitor
>
> Zhang Qilong (1):
>       Bluetooth: btmtkuart: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
>
> mark-yw.chen (2):
>       Bluetooth: btusb: Fixed too many in-token issue for Mediatek Chip.
>       Bluetooth: btusb: Add support for Lite-On Mediatek Chip
>
>  .../devicetree/bindings/net/qualcomm-bluetooth.txt |  69 -------
>  .../bindings/net/qualcomm-bluetooth.yaml           | 183 +++++++++++++++++++
>  drivers/bluetooth/btbcm.c                          |   1 +
>  drivers/bluetooth/btmrvl_sdio.c                    |   4 +-
>  drivers/bluetooth/btmtkuart.c                      |   6 +-
>  drivers/bluetooth/btqca.c                          | 113 +++++++++---
>  drivers/bluetooth/btqca.h                          |  14 +-
>  drivers/bluetooth/btrtl.c                          |  35 ++--
>  drivers/bluetooth/btrtl.h                          |   7 +
>  drivers/bluetooth/btusb.c                          |  45 ++++-
>  drivers/bluetooth/hci_ag6xx.c                      |   1 -
>  drivers/bluetooth/hci_h5.c                         |   5 +-
>  drivers/bluetooth/hci_qca.c                        | 118 +++++++++---
>  drivers/bluetooth/virtio_bt.c                      |   3 +
>  include/net/bluetooth/hci.h                        |  99 +++++-----
>  include/net/bluetooth/hci_core.h                   |  29 +--
>  include/net/bluetooth/mgmt.h                       |   3 +-
>  net/bluetooth/6lowpan.c                            |  54 +-----
>  net/bluetooth/a2mp.c                               |  24 +--
>  net/bluetooth/amp.c                                |   6 +-
>  net/bluetooth/bnep/core.c                          |   8 +-
>  net/bluetooth/cmtp/capi.c                          |  22 +--
>  net/bluetooth/cmtp/core.c                          |   5 +
>  net/bluetooth/hci_conn.c                           |  10 +-
>  net/bluetooth/hci_core.c                           |  78 +++++---
>  net/bluetooth/hci_debugfs.c                        |   8 +-
>  net/bluetooth/hci_event.c                          | 187 +++++++++++--------
>  net/bluetooth/hci_request.c                        | 203 +++++++++++++--------
>  net/bluetooth/hci_sock.c                           |  12 +-
>  net/bluetooth/hidp/core.c                          |   8 +-
>  net/bluetooth/l2cap_core.c                         |  16 +-
>  net/bluetooth/mgmt.c                               |  58 +++---
>  net/bluetooth/mgmt_config.c                        |   4 +-
>  net/bluetooth/msft.c                               |   8 +-
>  net/bluetooth/rfcomm/tty.c                         |  10 +-
>  net/bluetooth/sco.c                                |   8 +-
>  net/bluetooth/smp.c                                |  78 ++++----
>  net/bluetooth/smp.h                                |   6 +-
>  38 files changed, 967 insertions(+), 581 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt
>  create mode 100644 Documentation/devicetree/bindings/net/qualcomm-bluetooth.yaml



-- 
Luiz Augusto von Dentz
