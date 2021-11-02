Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B482F4435D9
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 19:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235170AbhKBSnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 14:43:53 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:34655 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbhKBSnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 14:43:52 -0400
Received: from smtpclient.apple (p4fefc15c.dip0.t-ipconnect.de [79.239.193.92])
        by mail.holtmann.org (Postfix) with ESMTPSA id 30E6BCECF5;
        Tue,  2 Nov 2021 19:41:15 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [PATCH v7 2/2] Bluetooth: aosp: Support AOSP Bluetooth Quality
 Report
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20211102151908.v7.2.Iaa4a0269e51d8e8d8784a6ac8e05899b49a1377d@changeid>
Date:   Tue, 2 Nov 2021 19:41:14 +0100
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        =?utf-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        josephsih@google.com, Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <70E30E57-1478-466B-B02E-1E05FC38F625@holtmann.org>
References: <20211102151908.v7.1.I139e71adfd3f00b88fe9edb63d013f9cd3e24506@changeid>
 <20211102151908.v7.2.Iaa4a0269e51d8e8d8784a6ac8e05899b49a1377d@changeid>
To:     Joseph Hwang <josephsih@chromium.org>
X-Mailer: Apple Mail (2.3693.20.0.1.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joseph,

> This patch adds the support of the AOSP Bluetooth Quality Report
> (BQR) events.
> 
> Multiple vendors have supported the AOSP Bluetooth Quality Report.
> When a Bluetooth controller supports the capability, it can enable
> the aosp capability through hci_set_aosp_capable. Then hci_core will
> set up the hdev->aosp_set_quality_report callback through aosp_do_open
> if the controller responds to support the quality report capability.
> 
> Note that Intel also supports a distinct telemetry quality report
> specification. Intel sets up the hdev->set_quality_report callback
> in the btusb driver module.
> 
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> Signed-off-by: Joseph Hwang <josephsih@chromium.org>
> 
> ---
> 
> Changes in v7:
> - Remove the unnecessary debug print.
> 
> Changes in v6:
> - Use the decimal version instead of hexadecimal version to be
>  consistent with the AOSP specification.
> - Move the code of checking the bluetooth_quality_report_support field
>  to the previous patch.
> 
> Changes in v5:
> - Fix the patch per
>  [RFC PATCH] Bluetooth: Add framework for AOSP quality report setting
> - Declare aosp_set_quality_report.
> - Use aosp_do_open() to set hdev->aosp_set_quality_report.
> - Add aosp_has_quality_report().
> - In mgmt, use hdev->aosp_set_quality_report and
>  hdev->set_quality_report separately.
> 
> Changes in v4:
> - Move the AOSP BQR support from the driver level to net/bluetooth/aosp.
> - Fix the drivers to use hci_set_aosp_capable to enable aosp.
> - Add Mediatek to support the capability too.
> 
> Changes in v3:
> - Fix the auto build test ERROR
>  "undefined symbol: btandroid_set_quality_report" that occurred
>  with some kernel configs.
> - Note that the mgmt-tester "Read Exp Feature - Success" failed.
>  But on my test device, the same test passed. Please kindly let me
>  know what may be going wrong. These patches do not actually
>  modify read/set experimental features.
> - As to CheckPatch failed. No need to modify the MAINTAINERS file.
>  Thanks.
> 
> Changes in v2:
> - Fix the titles of patches 2/3 and 3/3 and reduce their lengths.
> 
> net/bluetooth/aosp.c | 87 ++++++++++++++++++++++++++++++++++++++++++++
> net/bluetooth/aosp.h | 13 +++++++
> net/bluetooth/mgmt.c | 17 ++++++---
> 3 files changed, 112 insertions(+), 5 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

