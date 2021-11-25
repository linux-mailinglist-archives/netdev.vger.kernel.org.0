Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAFF45E160
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 21:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356814AbhKYUOG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Nov 2021 15:14:06 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:51487 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356931AbhKYUMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 15:12:06 -0500
Received: from smtpclient.apple (p5b3d2e91.dip0.t-ipconnect.de [91.61.46.145])
        by mail.holtmann.org (Postfix) with ESMTPSA id 90D3FCECC5;
        Thu, 25 Nov 2021 21:08:53 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [PATCH v3 1/2] Bluetooth: Send device found event on name resolve
 failure
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20211125150430.v3.1.Id7366eb14b6f48173fcbf17846ace59479179c7c@changeid>
Date:   Thu, 25 Nov 2021 21:08:53 +0100
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <70A5230B-F6F2-4707-97F3-EE786B1F2D8F@holtmann.org>
References: <20211125150430.v3.1.Id7366eb14b6f48173fcbf17846ace59479179c7c@changeid>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3693.20.0.1.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

> Introducing NAME_REQUEST_FAILED flag that will be sent together with
> device found event on name resolve failure. This will provide the
> userspace with an information so it can decide not to resolve the
> name for these devices in the future.
> 
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> 
> ---
> Hi maintainers,
> 
> This is the patch series for remote name request as was discussed here.
> https://patchwork.kernel.org/project/bluetooth/patch/20211028191805.1.I35b7f3a496f834de6b43a32f94b6160cb1467c94@changeid/
> Please also review the corresponding userspace change.
> 
> Thanks,
> Archie
> 
> Changes in v3:
> * Reindent defines
> * Assign variables inside if block instead of initializing
> 
> Changes in v2:
> * Remove the part which accepts DONT_CARE flag in MGMT_OP_CONFIRM_NAME
> * Rename MGMT constant to conform with the docs
> 
> include/net/bluetooth/mgmt.h |  9 +++++----
> net/bluetooth/hci_event.c    | 11 ++++-------
> net/bluetooth/mgmt.c         | 12 ++++++++++--
> 3 files changed, 19 insertions(+), 13 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

