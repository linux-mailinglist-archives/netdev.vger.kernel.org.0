Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1EC2CD685
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 14:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730624AbgLCNS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 08:18:28 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:43494 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbgLCNS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 08:18:28 -0500
Received: from marcel-macbook.holtmann.net (unknown [37.83.193.87])
        by mail.holtmann.org (Postfix) with ESMTPSA id C4728CECFC;
        Thu,  3 Dec 2020 14:24:58 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.20.0.2.21\))
Subject: Re: [PATCH v11 1/5] Bluetooth: Interleave with allowlist scan
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20201126122109.v11.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
Date:   Thu, 3 Dec 2020 14:17:44 +0100
Cc:     BlueZ development <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Alain Michaud <alainm@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Manish Mandlik <mmandlik@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <59863C55-684D-46F0-B2E8-97BEF6A355A9@holtmann.org>
References: <20201126122109.v11.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
To:     Howard Chung <howardchung@google.com>
X-Mailer: Apple Mail (2.3654.20.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Howard,

> This patch implements the interleaving between allowlist scan and
> no-filter scan. It'll be used to save power when at least one monitor is
> registered and at least one pending connection or one device to be
> scanned for.
> 
> The durations of the allowlist scan and the no-filter scan are
> controlled by MGMT command: Set Default System Configuration. The
> default values are set randomly for now.
> 
> Signed-off-by: Howard Chung <howardchung@google.com>
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> Reviewed-by: Manish Mandlik <mmandlik@chromium.org>
> ---
> 
> Changes in v11:
> - Add signed-off-by lines in patch 4/5, 5/5
> 
> Changes in v10:
> - remove comment about setting default values
> - rename should_interleaving to use_interleaving
> - rebase on new bluetooth-next/master (previous patch was applied)
> 
> Changes in v9:
> - Fix compile warning on patch 6/6
> 
> Changes in v8:
> - Simplified logic in __hci_update_interleaved_scan
> - Remove hdev->name when calling bt_dev_dbg
> - Remove 'default' in hci_req_add_le_interleaved_scan switch block
> - Remove {} around :1915
> - Update commit message and title in v7 4/5
> - Add a cleanup patch for replacing BT_DBG with bt_dev_dbg
> 
> Changes in v7:
> - Fix bt_dev_warn argument type warning
> 
> Changes in v6:
> - Set parameter EnableAdvMonInterleaveScan to 1 byte long
> 
> Changes in v5:
> - Rename 'adv_monitor' from many functions/variables
> - Move __hci_update_interleaved_scan into hci_req_add_le_passive_scan
> - Update the logic of update_adv_monitor_scan_state
> 
> Changes in v4:
> - Rebase to bluetooth-next/master (previous 2 patches are applied)
> - Fix over 80 chars limit in mgmt_config.c
> - Set EnableAdvMonInterleaveScan default to Disable
> 
> Changes in v3:
> - Remove 'Bluez' prefix
> 
> Changes in v2:
> - remove 'case 0x001c' in mgmt_config.c
> 
> include/net/bluetooth/hci_core.h |  10 +++
> net/bluetooth/hci_core.c         |   3 +
> net/bluetooth/hci_request.c      | 128 +++++++++++++++++++++++++++++--
> net/bluetooth/mgmt_config.c      |  10 +++
> 4 files changed, 144 insertions(+), 7 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

