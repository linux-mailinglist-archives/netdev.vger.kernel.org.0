Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACD2303209
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 03:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730417AbhAYPrP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 25 Jan 2021 10:47:15 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:34198 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730377AbhAYPq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 10:46:29 -0500
Received: from marcel-macbook.holtmann.net (p4ff9f11c.dip0.t-ipconnect.de [79.249.241.28])
        by mail.holtmann.org (Postfix) with ESMTPSA id 44C42CECC6;
        Mon, 25 Jan 2021 16:16:34 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.40.0.2.32\))
Subject: Re: [PATCH v6 0/7] MSFT offloading support for advertisement monitor
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210122083617.3163489-1-apusaka@google.com>
Date:   Mon, 25 Jan 2021 16:09:08 +0100
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <6C36E164-E3DC-44D3-A223-E75DC33CC090@holtmann.org>
References: <20210122083617.3163489-1-apusaka@google.com>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3654.40.0.2.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

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
> Changes in v6:
> * New patch "advmon offload MSFT interleave scanning integration"
> * New patch "disable advertisement filters during suspend"
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
>  the old one.
> 
> Archie Pusaka (6):
>  Bluetooth: advmon offload MSFT add rssi support
>  Bluetooth: advmon offload MSFT add monitor
>  Bluetooth: advmon offload MSFT remove monitor
>  Bluetooth: advmon offload MSFT handle controller reset
>  Bluetooth: advmon offload MSFT handle filter enablement
>  Bluetooth: advmon offload MSFT interleave scanning integration
> 
> Howard Chung (1):
>  Bluetooth: disable advertisement filters during suspend
> 
> include/net/bluetooth/hci_core.h |  36 ++-
> include/net/bluetooth/mgmt.h     |  16 ++
> net/bluetooth/hci_core.c         | 174 +++++++++---
> net/bluetooth/hci_request.c      |  49 +++-
> net/bluetooth/mgmt.c             | 391 +++++++++++++++++++-------
> net/bluetooth/msft.c             | 460 ++++++++++++++++++++++++++++++-
> net/bluetooth/msft.h             |  30 ++
> 7 files changed, 1015 insertions(+), 141 deletions(-)

all 7 patches have been applied to bluetooth-next tree.

Regards

Marcel

