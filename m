Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B533B2CD698
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 14:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730714AbgLCNVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 08:21:47 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:48043 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbgLCNVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 08:21:47 -0500
Received: from marcel-macbook.holtmann.net (unknown [37.83.193.87])
        by mail.holtmann.org (Postfix) with ESMTPSA id 8D253CECFE;
        Thu,  3 Dec 2020 14:28:18 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.20.0.2.21\))
Subject: Re: [PATCH v11 2/5] Bluetooth: Handle system suspend resume case
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20201126122109.v11.2.I3774a8f0d748c7c6ec3402c4adcead32810c9164@changeid>
Date:   Thu, 3 Dec 2020 14:21:04 +0100
Cc:     BlueZ development <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        alainm@chromium.org, mcchou@chromium.org, mmandlik@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <1152BFFD-976E-412F-9CF8-762D30FAE961@holtmann.org>
References: <20201126122109.v11.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
 <20201126122109.v11.2.I3774a8f0d748c7c6ec3402c4adcead32810c9164@changeid>
To:     Howard Chung <howardchung@google.com>
X-Mailer: Apple Mail (2.3654.20.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Howard,

> This patch adds code to handle the system suspension during interleave
> scan. The interleave scan will be canceled when the system is going to
> sleep, and will be restarted after waking up.
> 
> Signed-off-by: Howard Chung <howardchung@google.com>
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> Reviewed-by: Manish Mandlik <mmandlik@chromium.org>
> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> ---
> 
> (no changes since v5)
> 
> Changes in v5:
> - Remove the change in hci_req_config_le_suspend_scan
> 
> net/bluetooth/hci_request.c | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

