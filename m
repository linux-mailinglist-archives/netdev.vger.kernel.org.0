Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98237258D64
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 13:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbgIALZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 07:25:31 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:35854 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbgIALZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 07:25:24 -0400
Received: from marcel-macbook.fritz.box (p4ff9f430.dip0.t-ipconnect.de [79.249.244.48])
        by mail.holtmann.org (Postfix) with ESMTPSA id AEE5ECECDF;
        Tue,  1 Sep 2020 13:31:27 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v2] Bluetooth: Clear suspend tasks on unregister
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200831095119.v2.1.I24fb6cc377d03d64d74f83cec748afd12ee33e37@changeid>
Date:   Tue, 1 Sep 2020 13:24:34 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Miao-chen Chou <mcchou@chromium.org>
Content-Transfer-Encoding: 7bit
Message-Id: <86419845-3365-4925-8CD4-9D3F35BE5ED7@holtmann.org>
References: <20200831095119.v2.1.I24fb6cc377d03d64d74f83cec748afd12ee33e37@changeid>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> While unregistering, make sure to clear the suspend tasks before
> cancelling the work. If the unregister is called during resume from
> suspend, this will unnecessarily add 2s to the resume time otherwise.
> 
> Fixes: 4e8c36c3b0d73d (Bluetooth: Fix suspend notifier race)
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> ---
> This was discovered with RT8822CE using the btusb driver. This chipset
> will reset on resume during system suspend and was unnecessarily adding
> 2s to every resume. Since we're unregistering anyway, there's no harm in
> just clearing the pending events.
> 
> Changes in v2:
> - ++i to i++
> 
> net/bluetooth/hci_core.c | 11 +++++++++++
> 1 file changed, 11 insertions(+)

patch has been applied to bluetooth-next tree.

Regards

Marcel

