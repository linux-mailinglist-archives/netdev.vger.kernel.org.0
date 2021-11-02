Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5816B4435DC
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 19:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235189AbhKBSn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 14:43:58 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:40067 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbhKBSnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 14:43:55 -0400
Received: from smtpclient.apple (p4fefc15c.dip0.t-ipconnect.de [79.239.193.92])
        by mail.holtmann.org (Postfix) with ESMTPSA id 330B7CECF7;
        Tue,  2 Nov 2021 19:41:19 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [PATCH v7 1/2] Bluetooth: Add struct of reading AOSP vendor
 capabilities
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20211102151908.v7.1.I139e71adfd3f00b88fe9edb63d013f9cd3e24506@changeid>
Date:   Tue, 2 Nov 2021 19:41:18 +0100
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        =?utf-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Joseph Hwang <josephsih@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <32223CC8-EAC3-42F3-8C34-F60A2B62F9DD@holtmann.org>
References: <20211102151908.v7.1.I139e71adfd3f00b88fe9edb63d013f9cd3e24506@changeid>
To:     Joseph Hwang <josephsih@chromium.org>
X-Mailer: Apple Mail (2.3693.20.0.1.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joseph,

> This patch adds the struct of reading AOSP vendor capabilities.
> New capabilities are added incrementally. Note that the
> version_supported octets will be used to determine whether a
> capability has been defined for the version.
> 
> Signed-off-by: Joseph Hwang <josephsih@chromium.org>
> 
> ---
> 
> Changes in v7:
> - Use the full struct aosp_rp_le_get_vendor_capa. If the
>  version_supported is >= 98, check bluetooth_quality_report_support.
> - Use __le16 and __le32.
> - Use proper bt_dev_err and bt_dev_warn per review comments.
> - Skip unnecessary bt_dev_dbg.
> - Remove unnecessary rp->status check.
> - Skip unnecessary check about version_supported on versions that we
>  do not care about. For now, we only care about quality report support.
> - Add the define for the length of the struct.
> - Mediatek will submit a separate patch to enable aosp.
> 
> Changes in v6:
> - Add historical versions of struct aosp_rp_le_get_vendor_capabilities.
> - Perform the basic check about the struct length.
> - Through the version, bluetooth_quality_report_support can be checked.
> 
> Changes in v5:
> - This is a new patch.
> - Add struct aosp_rp_le_get_vendor_capabilities so that next patch
>  can determine whether a particular capability is supported or not.
> 
> include/net/bluetooth/hci_core.h |  1 +
> net/bluetooth/aosp.c             | 83 +++++++++++++++++++++++++++++++-
> 2 files changed, 83 insertions(+), 1 deletion(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

