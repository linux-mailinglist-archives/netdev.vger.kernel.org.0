Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D404533F5
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 15:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237207AbhKPOVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 09:21:22 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:43294 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236925AbhKPOVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 09:21:21 -0500
Received: from smtpclient.apple (p4fefc15c.dip0.t-ipconnect.de [79.239.193.92])
        by mail.holtmann.org (Postfix) with ESMTPSA id 6447DCECD8;
        Tue, 16 Nov 2021 15:18:22 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [PATCH v3 2/2] Bluetooth: Attempt to clear HCI_LE_ADV on adv set
 terminated error event
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20211111132045.v3.2.I4e34d9e5fdd7515aa15d0ee2ef94d57dcb48a927@changeid>
Date:   Tue, 16 Nov 2021 15:18:21 +0100
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <A1DD3249-8BC1-4297-906A-13B3C88ADB18@holtmann.org>
References: <20211111132045.v3.1.I3ba1a76d72da5a813cf6e6f219838c9ef28c5eaa@changeid>
 <20211111132045.v3.2.I4e34d9e5fdd7515aa15d0ee2ef94d57dcb48a927@changeid>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3693.20.0.1.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

> We should clear the flag if the adv instance removed due to receiving
> this error status is the last one we have.
> 
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> 
> ---
> 
> Changes in v3:
> * Check adv->enabled rather than just checking for list empty
> 
> net/bluetooth/hci_event.c | 9 ++++++++-
> 1 file changed, 8 insertions(+), 1 deletion(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

