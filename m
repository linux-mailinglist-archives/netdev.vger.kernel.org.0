Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2D32CECA3
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 11:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387662AbgLDK7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 05:59:46 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:57542 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbgLDK7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 05:59:46 -0500
Received: from marcel-macbook.holtmann.net (unknown [37.83.193.87])
        by mail.holtmann.org (Postfix) with ESMTPSA id C7F76CED13;
        Fri,  4 Dec 2020 12:06:16 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.20.0.2.21\))
Subject: Re: [PATCH v1] Bluetooth: Set missing suspend task bits
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20201204111038.v1.1.I4557a89427f61427e65d85bc51cca9e65607488e@changeid>
Date:   Fri, 4 Dec 2020 10:55:03 +0100
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Alain Michaud <alainm@chromium.org>,
        Manish Mandlik <mmandlik@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <F412C116-ECEF-4437-BCBD-9BDB9B15AF26@holtmann.org>
References: <20201204111038.v1.1.I4557a89427f61427e65d85bc51cca9e65607488e@changeid>
To:     Howard Chung <howardchung@google.com>
X-Mailer: Apple Mail (2.3654.20.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Howard,

> When suspending, mark SUSPEND_SCAN_ENABLE and SUSPEND_SCAN_DISABLE tasks
> correctly when either classic or le scanning is modified.
> 
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Signed-off-by: Howard Chung <howardchung@google.com>
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> ---
> 
> net/bluetooth/hci_request.c | 8 ++++++++
> 1 file changed, 8 insertions(+)

patch has been applied to bluetooth-next tree.

Regards

Marcel

