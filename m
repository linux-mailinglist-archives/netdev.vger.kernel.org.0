Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99C492AEF5D
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 12:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgKKLPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 06:15:17 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:33378 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgKKLPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 06:15:16 -0500
Received: from marcel-macbook.holtmann.net (unknown [37.83.201.106])
        by mail.holtmann.org (Postfix) with ESMTPSA id 2D2CDCECFE;
        Wed, 11 Nov 2020 12:22:23 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v9 1/6] Bluetooth: Replace BT_DBG with bt_dev_dbg in HCI
 request
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20201111150115.v9.1.I55fa38874edc240d726c1de6e82b2ce57b64f5eb@changeid>
Date:   Wed, 11 Nov 2020 12:15:13 +0100
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Alain Michaud <alainm@chromium.org>,
        Manish Mandlik <mmandlik@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <930CC61B-FFE0-44A4-93E4-D48C07793324@holtmann.org>
References: <20201111150115.v9.1.I55fa38874edc240d726c1de6e82b2ce57b64f5eb@changeid>
To:     Howard Chung <howardchung@google.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Howard,

> This replaces the BT_DBG function to bt_dev_dbg as it is cleaner to show
> the controller index in the debug message.
> 
> Signed-off-by: Howard Chung <howardchung@google.com>
> ---
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
> net/bluetooth/hci_request.c | 52 ++++++++++++++++++-------------------
> 1 file changed, 26 insertions(+), 26 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

