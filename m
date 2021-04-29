Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29F8636E623
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 09:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239514AbhD2HiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 03:38:15 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:48614 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbhD2HiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 03:38:11 -0400
Received: from smtpclient.apple (p4fefc624.dip0.t-ipconnect.de [79.239.198.36])
        by mail.holtmann.org (Postfix) with ESMTPSA id C5F08CECDC;
        Thu, 29 Apr 2021 09:44:11 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.80.0.2.43\))
Subject: Re: [PATCH v1] Bluetooth: Fix the HCI to MGMT status conversion table
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210419165323.v1.1.I9f9e8bcc849d91c1bb588a5181317c3e2ad48461@changeid>
Date:   Thu, 29 Apr 2021 09:36:22 +0200
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <8FB7AEF0-3E8A-4CC9-82FD-B647BAEF9765@holtmann.org>
References: <20210419165323.v1.1.I9f9e8bcc849d91c1bb588a5181317c3e2ad48461@changeid>
To:     Yu Liu <yudiliu@google.com>
X-Mailer: Apple Mail (2.3654.80.0.2.43)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yu,

> 0x2B, 0x31 and 0x33 are reserved for future use but were not present in
> the HCI to MGMT conversion table, this caused the conversion to be
> incorrect for the HCI status code greater than 0x2A.
> 
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> Signed-off-by: Yu Liu <yudiliu@google.com>
> ---
> 
> Changes in v1:
> - Initial change
> 
> net/bluetooth/mgmt.c | 3 +++
> 1 file changed, 3 insertions(+)

patch has been applied to bluetooth-next tree.

Regards

Marcel

