Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3345A37622A
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 10:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236335AbhEGIg6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 7 May 2021 04:36:58 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:40403 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbhEGIg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 04:36:57 -0400
Received: from smtpclient.apple (p4fefc624.dip0.t-ipconnect.de [79.239.198.36])
        by mail.holtmann.org (Postfix) with ESMTPSA id CF60CCECDB;
        Fri,  7 May 2021 10:43:46 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.80.0.2.43\))
Subject: Re: [PATCH v2 2/2] Bluetooth: Support the vendor specific debug
 events
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210413074521.264802-2-josephsih@chromium.org>
Date:   Fri, 7 May 2021 10:35:55 +0200
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        =?utf-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        josephsih@google.com, chromeos-bluetooth-upstreaming@chromium.org,
        Chethan Tumkur Narayan 
        <chethan.tumkur.narayan@intel.corp-partner.google.com>,
        Kiran Krishnappa <kiran.k@intel.corp-partner.google.com>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <A5D0DBF6-7C55-49E2-80EA-B1C6D44F14A8@holtmann.org>
References: <20210413074521.264802-1-josephsih@chromium.org>
 <20210413074521.264802-2-josephsih@chromium.org>
To:     Joseph Hwang <josephsih@chromium.org>
X-Mailer: Apple Mail (2.3654.80.0.2.43)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joseph,

> This patch allows a user space process to enable/disable the vendor
> specific (vs) debug events dynamically through the set experimental
> feature mgmt interface if CONFIG_BT_FEATURE_VS_DBG_EVT is enabled.
> 
> Since the debug event feature needs to invoke the callback function
> provided by the driver, i.e., hdev->set_vs_dbg_evt, a valid controller
> index is required.
> 
> For generic Linux machines, the vendor specific debug events are
> disabled by default.
> 
> Reviewed-by: Chethan Tumkur Narayan <chethan.tumkur.narayan@intel.corp-partner.google.com>
> Reviewed-by: Kiran Krishnappa <kiran.k@intel.corp-partner.google.com>
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> Signed-off-by: Joseph Hwang <josephsih@chromium.org>
> ---
> 
> (no changes since v1)
> 
> drivers/bluetooth/btintel.c      |  73 ++++++++++++++++++++-
> drivers/bluetooth/btintel.h      |  13 ++++
> drivers/bluetooth/btusb.c        |  16 +++++
> include/net/bluetooth/hci.h      |   4 ++
> include/net/bluetooth/hci_core.h |  10 +++
> net/bluetooth/Kconfig            |  10 +++
> net/bluetooth/mgmt.c             | 108 ++++++++++++++++++++++++++++++-
> 7 files changed, 232 insertions(+), 2 deletions(-)

maybe I forgot to mention this, we don’t intermix core changes with driver changes to support it.

You first need to introduce the core feature and then patch the driver to support it.

Regards

Marcel

