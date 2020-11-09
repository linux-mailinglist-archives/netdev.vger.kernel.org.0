Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96B62AB82C
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 13:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729697AbgKIMZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 07:25:33 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:47099 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729303AbgKIMZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 07:25:32 -0500
Received: from marcel-macbook.fritz.box (p4fefcf0f.dip0.t-ipconnect.de [79.239.207.15])
        by mail.holtmann.org (Postfix) with ESMTPSA id D7864CECC5;
        Mon,  9 Nov 2020 13:32:39 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v7 2/5] Bluetooth: Handle system suspend resume case
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20201109155659.v7.2.I3774a8f0d748c7c6ec3402c4adcead32810c9164@changeid>
Date:   Mon, 9 Nov 2020 13:25:30 +0100
Cc:     Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Manish Mandlik <mmandlik@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <8320ECFF-1AA8-4FBE-8548-8C5F85D60876@holtmann.org>
References: <20201109155659.v7.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
 <20201109155659.v7.2.I3774a8f0d748c7c6ec3402c4adcead32810c9164@changeid>
To:     Howard Chung <howardchung@google.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Howard,

> This patch adds code to handle the system suspension during interleave
> scan. The interleave scan will be canceled when the system is going to
> sleep, and will be restarted after waking up.
> 
> Commit-changes 5:
> - Remove the change in hci_req_config_le_suspend_scan

this does not belong here. So please avoid this in the future.

> Signed-off-by: Howard Chung <howardchung@google.com>
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> Reviewed-by: Manish Mandlik <mmandlik@chromium.org>
> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> ---
> 
> (no changes since v1)
> 
> net/bluetooth/hci_request.c | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)

Patch has been applied to bluetooth-next tree.

Regards

Marcel

