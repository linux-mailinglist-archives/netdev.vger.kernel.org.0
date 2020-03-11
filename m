Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3919181B67
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 15:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729980AbgCKOfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 10:35:03 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:50064 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729782AbgCKOfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 10:35:03 -0400
Received: from [172.20.10.2] (x59cc8a78.dyn.telefonica.de [89.204.138.120])
        by mail.holtmann.org (Postfix) with ESMTPSA id 11C81CECDF;
        Wed, 11 Mar 2020 15:44:30 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH] Bluetooth: mgmt: add mgmt_cmd_status in add_advertising
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200310093101.1.Iaa45f22c4b2bb1828e88211b2d28c24d6ddd50a7@changeid>
Date:   Wed, 11 Mar 2020 15:35:00 +0100
Cc:     Alain Michaud <alainm@chromium.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Joseph Hwang <josephsih@chromium.org>,
        Yoni Shavit <yshavit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <DB1BFC8C-3BD3-4828-9FA3-9079DB34B1E9@holtmann.org>
References: <20200310093101.1.Iaa45f22c4b2bb1828e88211b2d28c24d6ddd50a7@changeid>
To:     Manish Mandlik <mmandlik@google.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

> If an error occurs during request building in add_advertising(),
> remember to send MGMT_STATUS_FAILED command status back to bluetoothd.
> 
> Signed-off-by: Joseph Hwang <josephsih@chromium.org>
> Signed-off-by: Manish Mandlik <mmandlik@google.com>
> ---
> 
> net/bluetooth/mgmt.c | 5 ++++-
> 1 file changed, 4 insertions(+), 1 deletion(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

